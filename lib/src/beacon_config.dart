/// Static Beacon configuration and session state.
class BeaconConfig {
  BeaconConfig({
    required this.apiKey,
    required this.batchSize,
    required this.sessionToken,
  });

  static const String baseUrl =
      'https://studio93-beacon-967772126083.us-central1.run.app';

  final String apiKey;
  final int batchSize;
  final String sessionToken;

  Uri get trackUri => Uri.parse('$baseUrl/track');
}
