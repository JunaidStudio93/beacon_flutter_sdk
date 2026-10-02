import 'dart:convert';

import 'package:http/http.dart' as http;

import 'beacon_config.dart';
import 'event_model.dart';

/// Posts batched events to the Beacon track endpoint.
class BeaconUploader {
  BeaconUploader({
    required BeaconConfig config,
    http.Client? client,
  })  : _config = config,
        _client = client ?? http.Client();

  final BeaconConfig _config;
  final http.Client _client;

  /// Returns `true` when the server accepts the batch (HTTP 202).
  Future<bool> upload(List<BeaconEvent> events) async {
    if (events.isEmpty) return true;

    final response = await _client.post(
      _config.trackUri,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _config.apiKey,
      },
      body: jsonEncode({
        'events': events.map((e) => e.toJson()).toList(),
      }),
    );

    return response.statusCode == 202;
  }

  /// Asks the API to rewrite a device's anonymous history onto a real email
  /// and uid. Returns `true` when the server accepts the request (HTTP 202).
  ///
  /// 202 means the backfill job was submitted, not that it has finished — the
  /// rewrite completes inside BigQuery a few seconds later.
  Future<bool> identify(String deviceId, String email, String uid) async {
    final response = await _client.post(
      _config.identifyUri,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _config.apiKey,
      },
      body: jsonEncode({'deviceId': deviceId, 'email': email, 'uid': uid}),
    );

    return response.statusCode == 202;
  }
}
