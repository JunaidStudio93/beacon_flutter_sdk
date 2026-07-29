# Beacon Flutter SDK

Event tracking SDK for Flutter with Drift-backed local batching.

## Features

- Initialize with an API key and configurable batch size
- Persist events locally with Drift (SQLite) until the batch limit
- Flush automatically when the batch size is reached
- Optional `immediate: true` to upload without waiting for the batch
- Manual `flush()` for app lifecycle (background / dispose)
- Auto-attaches platform, country, app version, and timezone

## Getting started

Add the package to your app `pubspec.yaml`, then initialize early in `main()`:

```dart
import 'package:beacon_flutter_sdk/beacon_flutter_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Beacon.initialize(
    apiKey: 'bcn_live_sk_...',
    batchSize: 10,
  );

  runApp(const MyApp());
}
```

## Usage

```dart
await Beacon.instance.push(
  eventName: 'screen_view',
  funnel: 'onboarding',
  type: 'navigation',
  value: 'home',
  uid: user.uid,       // defaults to 'anonymous'
  email: user.email,   // defaults to 'anonymous'
);

// Bypass batching and send now (still persists first; clears on 202)
await Beacon.instance.push(
  eventName: 'purchase_completed',
  funnel: 'checkout',
  type: 'conversion',
  value: '99.00',
  uid: user.uid,
  email: user.email,
  immediate: true,
);

// Flush leftover events (e.g. on app pause)
await Beacon.instance.flush();
```

Events are `POST`ed to the static Beacon endpoint `/track` with header `x-api-key`.
A successful response is HTTP **202**; otherwise events stay in the local DB for the next flush.

## Additional information

This package stores pending events in an on-device SQLite database (`beacon_events.sqlite`).
Call `flush()` from your app lifecycle if you need pending events uploaded before the batch fills.
