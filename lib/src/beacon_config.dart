import 'package:uuid/uuid.dart';

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

  /// Mutable: [Beacon.refresh] starts a new session by replacing this.
  /// Events carry the token that was current when they were pushed.
  String sessionToken;

  /// Starts a new session. Events already queued keep the previous token.
  void regenerateSession() {
    sessionToken = const Uuid().v4();
  }

  Uri get trackUri {
    final normalized = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return Uri.parse('$normalized/track');
  }
}
