import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'beacon_config.dart';
import 'db/beacon_database.dart';
import 'device_context.dart';
import 'device_context_resolver.dart';
import 'event_model.dart';
import 'sanitize.dart';
import 'uploader.dart';

/// Beacon event tracking SDK facade.
class Beacon {
  Beacon._({
    required BeaconConfig config,
    required BeaconDatabase database,
    required DeviceContext deviceContext,
    required BeaconUploader uploader,
  })  : _config = config,
        _database = database,
        _deviceContext = deviceContext,
        _uploader = uploader;

  static Beacon? _instance;

  /// Returns the initialized singleton. Throws if [initialize] was not called.
  static Beacon get instance {
    final current = _instance;
    if (current == null) {
      throw StateError(
        'Beacon has not been initialized. Call Beacon.initialize() first.',
      );
    }
    return current;
  }

  /// Whether [initialize] has completed successfully.
  static bool get isInitialized => _instance != null;

  final BeaconConfig _config;
  final BeaconDatabase _database;
  final DeviceContext _deviceContext;
  final BeaconUploader _uploader;

  /// Mutex so concurrent push/flush calls do not double-send the same rows.
  Future<void> _flushLock = Future<void>.value();

  /// Initializes the SDK. Safe to call once per process; subsequent calls
  /// replace the previous instance after closing its database.
  static Future<Beacon> initialize({
    required String apiKey,
    int batchSize = 10,
    http.Client? httpClient,
    BeaconDatabase? database,
    DeviceContext? deviceContext,
  }) async {
    if (apiKey.trim().isEmpty) {
      throw ArgumentError.value(apiKey, 'apiKey', 'must not be empty');
    }
    if (batchSize < 1) {
      throw ArgumentError.value(batchSize, 'batchSize', 'must be >= 1');
    }

    final previous = _instance;
    if (previous != null) {
      await previous._database.close();
      _instance = null;
    }

    final config = BeaconConfig(
      apiKey: apiKey,
      batchSize: batchSize,
      sessionToken: const Uuid().v4(),
    );

    final db = database ?? BeaconDatabase();
    final context = deviceContext ?? await resolveDeviceContext();
    final uploader = BeaconUploader(config: config, client: httpClient);

    final beacon = Beacon._(
      config: config,
      database: db,
      deviceContext: context,
      uploader: uploader,
    );
    _instance = beacon;

    // Flush any leftover events from a previous session.
    await beacon.flush();

    return beacon;
  }

  /// Queues an event. When [immediate] is true, or the pending count reaches
  /// [BeaconConfig.batchSize], flushes the queue to the API.
  Future<void> push({
    required String eventName,
    required String funnel,
    required String type,
    String? value,
    String uid = 'anonymous',
    String email = 'anonymous',
    Map<String, dynamic>? properties,
    bool immediate = false,
  }) async {
    final props = <String, dynamic>{
      'type': type,
      'value': sanitizeValue(value),
      ..._deviceContext.toMap(),
      if (properties != null) ...properties,
    };

    await _database.insertEvent(
      PendingEventsCompanion.insert(
        eventName: sanitizeName(eventName),
        funnel: sanitizeName(funnel),
        uid: uid,
        email: email,
        sessionToken: _config.sessionToken,
        timestamp: DateTime.now().toUtc().toIso8601String(),
        propertiesJson: jsonEncode(props),
      ),
    );

    if (immediate) {
      await flush();
      return;
    }

    final count = await _database.pendingCount();
    if (count >= _config.batchSize) {
      await flush();
    }
  }

  /// Uploads all pending events. On HTTP 202, deletes only the sent rows.
  Future<void> flush() {
    final previous = _flushLock;
    late Future<void> current;
    current = previous.then((_) => _flushInternal());
    _flushLock = current.catchError((_) {});
    return current;
  }

  Future<void> _flushInternal() async {
    final rows = await _database.allPending();
    if (rows.isEmpty) return;

    final events = rows
        .map(
          (row) => BeaconEvent.fromStored(
            eventName: row.eventName,
            uid: row.uid,
            funnel: row.funnel,
            sessionToken: row.sessionToken,
            timestamp: row.timestamp,
            email: row.email,
            propertiesJson: row.propertiesJson,
          ),
        )
        .toList();

    try {
      final accepted = await _uploader.upload(events);
      if (accepted) {
        await _database.deleteByIds(rows.map((r) => r.id).toList());
      } else {
        log('Beacon: upload rejected (non-202); events kept for retry');
      }
    } catch (e, st) {
      log('Beacon: upload failed; events kept for retry', error: e, stackTrace: st);
    }
  }

  /// Closes the local database. Useful in tests.
  Future<void> dispose() async {
    await _database.close();
    if (identical(_instance, this)) {
      _instance = null;
    }
  }
}
