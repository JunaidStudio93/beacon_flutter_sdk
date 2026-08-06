/// Device/app context resolved once at init and attached to every event.
///
/// Country is intentionally omitted; the Beacon backend sets
/// `properties.country` from the request IP on `/track`.
class DeviceContext {
  const DeviceContext({
    required this.platform,
    required this.appVersion,
    required this.timezone,
  });

  final String platform;
  final String appVersion;
  final String timezone;

  Map<String, dynamic> toMap() => {
        'platform': platform,
        'appVersion': appVersion,
        'timezone': timezone,
      };
}
