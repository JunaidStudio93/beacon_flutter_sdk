/// Device/app context resolved once at init and attached to every event.
class DeviceContext {
  const DeviceContext({
    required this.country,
    required this.platform,
    required this.appVersion,
    required this.timezone,
  });

  final String country;
  final String platform;
  final String appVersion;
  final String timezone;

  Map<String, dynamic> toMap() => {
        'country': country,
        'platform': platform,
        'appVersion': appVersion,
        'timezone': timezone,
      };
}
