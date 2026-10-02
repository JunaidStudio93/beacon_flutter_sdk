# Beacon Flutter SDK

Event tracking SDK for Flutter with Drift-backed local batching.

## Features

- Initialize with an API key, base URL, and configurable batch size
- Persist events locally with Drift (SQLite) until the batch limit
- Flush automatically when the batch size is reached
- Optional `immediate: true` to upload without waiting for the batch
- Manual `flush()` for app lifecycle (background / dispose)
- `refresh()` to upload everything pending and start a new session
- `identify()` to attach a real email and uid to a device's anonymous history on sign-in
- Auto-attaches platform, app version, and timezone
- Country is set server-side from the request IP (not by the SDK)

## Getting started

Add the package to your app `pubspec.yaml`, then initialize early in `main()`:

```dart
import 'package:beacon_flutter_sdk/beacon_flutter_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Beacon.initialize(
    apiKey: 'bcn_live_sk_...',
    baseUrl: 'https://your-beacon-endpoint.example.com',
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

// End the current session: upload everything pending, then start a new one.
// Events keep the token they were pushed under; the new session starts even
// if the upload failed.
await Beacon.instance.refresh();
```

## Anonymous users

While nobody is signed in there is no email to send, so pass the device id in
the `email` field:

```dart
await Beacon.instance.push(
  eventName: 'screen_view',
  funnel: 'onboarding',
  type: 'navigation',
  email: deviceId, // stands in for the real email until sign-in
);
```

`email` is the identity column every dashboard aggregate groups by, so each
device counts as its own user rather than collapsing into one anonymous blob.

When the user signs in, hand over the real email:

```dart
await Beacon.instance.identify(deviceId, user.email, user.uid);
```

The backend rewrites every event already recorded under that device id onto the
real email, so the anonymous and signed-in halves become one user. Events
pushed after this call should carry the real email directly.

Notes:

- The rewrite is asynchronous. The call returns as soon as the server accepts
  it; the dashboard catches up a few seconds later.
- It flushes the local queue first, so events still waiting to upload are not
  stranded under the old identity.
- Nothing is retried. A failure is logged, never thrown — analytics must not
  break sign-in.
- The backend only looks back 90 days by default (`IDENTIFY_LOOKBACK_DAYS`).

Events are `POST`ed to `{baseUrl}/track` with header `x-api-key`.
A successful response is HTTP **202**; otherwise events stay in the local DB for the next flush.

## Additional information

This package stores pending events in an on-device SQLite database (`beacon_events.sqlite`).
Call `flush()` from your app lifecycle if you need pending events uploaded before the batch fills.
