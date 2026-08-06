import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'device_context.dart';

/// Resolves device/app context once at SDK init.
Future<DeviceContext> resolveDeviceContext() async {
  final platform = kIsWeb ? 'web' : Platform.operatingSystem;

  String appVersion;
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  } catch (_) {
    appVersion = '';
  }

  String timezone;
  try {
    timezone = await FlutterTimezone.getLocalTimezone();
  } catch (_) {
    timezone = '';
  }

  return DeviceContext(
    platform: platform,
    appVersion: appVersion,
    timezone: timezone,
  );
}
