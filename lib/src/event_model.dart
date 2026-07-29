import 'dart:convert';

/// Event payload sent to the Beacon `/track` endpoint.
class BeaconEvent {
  const BeaconEvent({
    required this.eventName,
    required this.uid,
    required this.funnel,
    required this.sessionToken,
    required this.timestamp,
    required this.email,
    required this.properties,
  });

  final String eventName;
  final String uid;
  final String funnel;
  final String sessionToken;
  final String timestamp;
  final String email;
  final Map<String, dynamic> properties;

  Map<String, dynamic> toJson() => {
        'eventName': eventName,
        'uid': uid,
        'funnel': funnel,
        'sessionToken': sessionToken,
        'timestamp': timestamp,
        'email': email,
        'properties': properties,
      };

  factory BeaconEvent.fromStored({
    required String eventName,
    required String uid,
    required String funnel,
    required String sessionToken,
    required String timestamp,
    required String email,
    required String propertiesJson,
  }) {
    final decoded = jsonDecode(propertiesJson);
    return BeaconEvent(
      eventName: eventName,
      uid: uid,
      funnel: funnel,
      sessionToken: sessionToken,
      timestamp: timestamp,
      email: email,
      properties: decoded is Map<String, dynamic>
          ? decoded
          : Map<String, dynamic>.from(decoded as Map),
    );
  }
}
