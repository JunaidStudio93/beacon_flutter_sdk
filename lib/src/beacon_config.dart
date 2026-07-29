/// Runtime Beacon configuration and session state.
class BeaconConfig {
  BeaconConfig({
    required this.apiKey,
    required this.baseUrl,
    required this.batchSize,
    required this.sessionToken,
  });

  final String apiKey;
  final String baseUrl;
  final int batchSize;
  final String sessionToken;

  Uri get trackUri {
    final normalized = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return Uri.parse('$normalized/track');
  }
}
