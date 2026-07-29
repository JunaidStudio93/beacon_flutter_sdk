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
        batchSize: 3,
        httpClient: client,
        database: BeaconDatabase.memory(),
        deviceContext: const DeviceContext(
          country: 'US',
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
        batchSize: 2,
        httpClient: client,
        database: BeaconDatabase.memory(),
        deviceContext: const DeviceContext(
          country: 'US',
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
        batchSize: 10,
        httpClient: client,
        database: BeaconDatabase.memory(),
        deviceContext: const DeviceContext(
          country: 'US',
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
        batchSize: 1,
        httpClient: client,
        database: BeaconDatabase.memory(),
        deviceContext: const DeviceContext(
          country: 'US',
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
}
