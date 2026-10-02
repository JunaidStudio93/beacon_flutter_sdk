import 'dart:convert';

import 'package:beacon_flutter_sdk/beacon_flutter_sdk.dart';
import 'package:beacon_flutter_sdk/src/db/beacon_database.dart';
import 'package:beacon_flutter_sdk/src/device_context.dart';
import 'package:beacon_flutter_sdk/src/sanitize.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('sanitizeName', () {
    test('replaces invalid characters and truncates', () {
      expect(sanitizeName('  hello-world!  '), 'hello_world_');
      expect(sanitizeName('123bad'), 'e_123bad');
      expect(
        sanitizeName('a' * 50),
        'a' * 40,
      );
    });

    test('prefixes empty result', () {
      expect(sanitizeName('!!!'), 'e____');
    });
  });

  group('sanitizeValue', () {
    test('handles null empty and long values', () {
      expect(sanitizeValue(null), '');
      expect(sanitizeValue(''), '');
      expect(sanitizeValue('short'), 'short');
      expect(sanitizeValue('x' * 150), 'x' * 100);
    });
  });

  group('Beacon batching', () {
    tearDown(() async {
      if (Beacon.isInitialized) {
        await Beacon.instance.dispose();
      }
    });

    test('queues below batchSize without uploading', () async {
      var postCount = 0;
      final client = MockClient((request) async {
        postCount++;
        return http.Response('', 202);
      });

      await Beacon.initialize(
        apiKey: 'test_key',
        baseUrl: 'https://example.com',
        batchSize: 3,
        httpClient: client,
        database: BeaconDatabase.memory(),
        deviceContext: const DeviceContext(
          platform: 'test',
          appVersion: '1.0.0',
          timezone: 'UTC',
        ),
      );

      await Beacon.instance.push(
        eventName: 'one',
        funnel: 'funnel',
        type: 'click',
      );
      await Beacon.instance.push(
        eventName: 'two',
        funnel: 'funnel',
        type: 'click',
      );

      expect(postCount, 0);
    });

    test('flushes when batchSize is reached and clears on 202', () async {
      var postCount = 0;
      List<dynamic>? sentEvents;
      final client = MockClient((request) async {
        postCount++;
        expect(request.headers['x-api-key'], 'test_key');
        expect(request.url.path, endsWith('/track'));
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        sentEvents = body['events'] as List<dynamic>;
        return http.Response('', 202);
      });

      await Beacon.initialize(
        apiKey: 'test_key',
        baseUrl: 'https://example.com',
        batchSize: 2,
        httpClient: client,
        database: BeaconDatabase.memory(),
        deviceContext: const DeviceContext(
          platform: 'test',
          appVersion: '1.0.0',
          timezone: 'UTC',
        ),
      );

      await Beacon.instance.push(
        eventName: 'one',
        funnel: 'onboarding',
        type: 'nav',
        value: 'a',
        uid: 'u1',
        email: 'a@b.com',
      );
      expect(postCount, 0);

      await Beacon.instance.push(
        eventName: 'two',
        funnel: 'onboarding',
        type: 'nav',
        value: 'b',
        uid: 'u1',
        email: 'a@b.com',
      );

      expect(postCount, 1);
      expect(sentEvents, hasLength(2));

      // Queue should be empty; another push should not upload yet.
      await Beacon.instance.push(
        eventName: 'three',
        funnel: 'onboarding',
        type: 'nav',
      );
      expect(postCount, 1);
    });

    test('immediate pushes without waiting for batch', () async {
      var postCount = 0;
      final client = MockClient((request) async {
        postCount++;
        return http.Response('', 202);
      });

      await Beacon.initialize(
        apiKey: 'test_key',
        baseUrl: 'https://example.com',
        batchSize: 10,
        httpClient: client,
        database: BeaconDatabase.memory(),
        deviceContext: const DeviceContext(
          platform: 'test',
          appVersion: '1.0.0',
          timezone: 'UTC',
        ),
      );

      await Beacon.instance.push(
        eventName: 'urgent',
        funnel: 'checkout',
        type: 'purchase',
        immediate: true,
      );

      expect(postCount, 1);
    });

    test('keeps events when upload is not 202', () async {
      var postCount = 0;
      final client = MockClient((request) async {
        postCount++;
        return http.Response('error', 500);
      });

      await Beacon.initialize(
        apiKey: 'test_key',
        baseUrl: 'https://example.com',
        batchSize: 1,
        httpClient: client,
        database: BeaconDatabase.memory(),
        deviceContext: const DeviceContext(
          platform: 'test',
          appVersion: '1.0.0',
          timezone: 'UTC',
        ),
      );

      await Beacon.instance.push(
        eventName: 'fail',
        funnel: 'funnel',
        type: 'error',
      );
      expect(postCount, 1);

      // Still pending — flush again should retry.
      await Beacon.instance.flush();
      expect(postCount, 2);
    });
  });

  group('Beacon refresh', () {
    tearDown(() async {
      if (Beacon.isInitialized) {
        await Beacon.instance.dispose();
      }
    });

    test('uploads pending events and starts a new session', () async {
      var postCount = 0;
      final batches = <List<dynamic>>[];
      final client = MockClient((request) async {
        postCount++;
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        batches.add(body['events'] as List<dynamic>);
        return http.Response('', 202);
      });

      await Beacon.initialize(
        apiKey: 'test_key',
        baseUrl: 'https://example.com',
        batchSize: 100, // high, so only refresh triggers the upload
        httpClient: client,
        database: BeaconDatabase.memory(),
        deviceContext: const DeviceContext(
          platform: 'test',
          appVersion: '1.0.0',
          timezone: 'UTC',
        ),
      );

      final firstSession = Beacon.instance.sessionToken;

      await Beacon.instance.push(
        eventName: 'one',
        funnel: 'f',
        type: 't',
      );
      await Beacon.instance.push(
        eventName: 'two',
        funnel: 'f',
        type: 't',
      );
      expect(postCount, 0);

      await Beacon.instance.refresh();

      // Everything pending went up, under the session it was pushed in.
      expect(postCount, 1);
      expect(batches[0], hasLength(2));
      for (final event in batches[0]) {
        expect((event as Map<String, dynamic>)['sessionToken'], firstSession);
      }

      // A new session token is now in effect.
      final secondSession = Beacon.instance.sessionToken;
      expect(secondSession, isNot(firstSession));

      // Events pushed after refresh carry the new token.
      await Beacon.instance.push(
        eventName: 'three',
        funnel: 'f',
        type: 't',
      );
      await Beacon.instance.flush();
      expect(postCount, 2);
      expect(
        (batches[1][0] as Map<String, dynamic>)['sessionToken'],
        secondSession,
      );
    });

    test('starts the new session even when the upload fails', () async {
      final statuses = <int>[500, 202];
      final batches = <List<dynamic>>[];
      final client = MockClient((request) async {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        batches.add(body['events'] as List<dynamic>);
        final status = statuses.isEmpty ? 202 : statuses.removeAt(0);
        return http.Response('', status);
      });

      await Beacon.initialize(
        apiKey: 'test_key',
        baseUrl: 'https://example.com',
        batchSize: 100,
        httpClient: client,
        database: BeaconDatabase.memory(),
        deviceContext: const DeviceContext(
          platform: 'test',
          appVersion: '1.0.0',
          timezone: 'UTC',
        ),
      );

      final firstSession = Beacon.instance.sessionToken;
      await Beacon.instance.push(
        eventName: 'stranded',
        funnel: 'f',
        type: 't',
      );

      await Beacon.instance.refresh();

      final secondSession = Beacon.instance.sessionToken;
      expect(secondSession, isNot(firstSession));

      // The undelivered event stayed queued and still belongs to session one.
      await Beacon.instance.push(
        eventName: 'fresh',
        funnel: 'f',
        type: 't',
      );
      await Beacon.instance.flush();

      final retried = batches[1];
      expect(retried, hasLength(2));
      expect(
        (retried[0] as Map<String, dynamic>)['sessionToken'],
        firstSession,
      );
      expect(
        (retried[1] as Map<String, dynamic>)['sessionToken'],
        secondSession,
      );
    });
  });

  group('Beacon identify', () {
    const ctx = DeviceContext(
      platform: 'test',
      appVersion: '1.0.0',
      timezone: 'UTC',
    );

    tearDown(() async {
      if (Beacon.isInitialized) {
        await Beacon.instance.dispose();
      }
    });

    Future<void> init(http.Client client) => Beacon.initialize(
          apiKey: 'test_key',
          baseUrl: 'https://example.com',
          batchSize: 100, // high, so nothing auto-flushes mid-test
          httpClient: client,
          database: BeaconDatabase.memory(),
          deviceContext: ctx,
        );

    test('posts deviceId, email and uid to /identify with the api key', () async {
      final calls = <http.Request>[];
      final client = MockClient((request) async {
        calls.add(request);
        return http.Response('', 202);
      });

      await init(client);
      await Beacon.instance.identify('device_abc', 'user@example.com', 'uid_123');

      final identifyCalls =
          calls.where((c) => c.url.path.endsWith('/identify')).toList();
      expect(identifyCalls, hasLength(1));
      expect(identifyCalls.first.headers['x-api-key'], 'test_key');
      expect(
        jsonDecode(identifyCalls.first.body),
        {'deviceId': 'device_abc', 'email': 'user@example.com', 'uid': 'uid_123'},
      );
    });

    test('uploads queued events before asking for the rewrite', () async {
      final order = <String>[];
      final client = MockClient((request) async {
        order.add(request.url.path.endsWith('/identify') ? 'identify' : 'track');
        return http.Response('', 202);
      });

      final db = BeaconDatabase.memory();
      await Beacon.initialize(
        apiKey: 'test_key',
        baseUrl: 'https://example.com',
        batchSize: 100,
        httpClient: client,
        database: db,
        deviceContext: ctx,
      );

      await Beacon.instance.push(
        eventName: 'anon_view',
        funnel: 'onboarding',
        type: 'nav',
        email: 'device_abc',
      );
      expect(await db.pendingCount(), 1);

      await Beacon.instance.identify('device_abc', 'user@example.com', 'uid_123');

      // The queued event must reach the server BEFORE the rewrite runs,
      // otherwise it lands after the UPDATE and keeps the device id forever.
      expect(order, ['track', 'identify']);
      expect(await db.pendingCount(), 0);
    });

    test('trims both arguments', () async {
      final calls = <http.Request>[];
      final client = MockClient((request) async {
        calls.add(request);
        return http.Response('', 202);
      });

      await init(client);
      await Beacon.instance.identify('  device_abc  ', '  user@example.com  ', '  uid_123  ');

      final body = jsonDecode(
        calls.firstWhere((c) => c.url.path.endsWith('/identify')).body,
      );
      expect(
        body,
        {'deviceId': 'device_abc', 'email': 'user@example.com', 'uid': 'uid_123'},
      );
    });

    test('rejects empty arguments', () async {
      await init(MockClient((_) async => http.Response('', 202)));

      expect(
        () => Beacon.instance.identify('   ', 'user@example.com', 'uid_123'),
        throwsArgumentError,
      );
      expect(
        () => Beacon.instance.identify('device_abc', '  ', 'uid_123'),
        throwsArgumentError,
      );
      expect(
        () => Beacon.instance.identify('device_abc', 'user@example.com', '  '),
        throwsArgumentError,
      );
    });

    test('does not throw when the server rejects', () async {
      await init(MockClient((request) async {
        return http.Response('', request.url.path.endsWith('/identify') ? 500 : 202);
      }));

      await expectLater(
        Beacon.instance.identify('device_abc', 'user@example.com', 'uid_123'),
        completes,
      );
    });

    test('does not throw when the network fails', () async {
      await init(MockClient((request) async {
        if (request.url.path.endsWith('/identify')) {
          throw const SocketExceptionStub();
        }
        return http.Response('', 202);
      }));

      await expectLater(
        Beacon.instance.identify('device_abc', 'user@example.com', 'uid_123'),
        completes,
      );
    });
  });
}

/// Stand-in for a transport failure; MockClient has no built-in way to throw
/// a network error, and the SDK only cares that *something* was thrown.
class SocketExceptionStub implements Exception {
  const SocketExceptionStub();
}
