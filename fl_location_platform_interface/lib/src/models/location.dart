/// A data class that represents a location model.
class Location {
  /// The latitude of the location.
  final double latitude;

  /// The longitude of the location.
  final double longitude;

  /// The accuracy of the location.
  final double accuracy;

  /// The altitude of the location.
  final double altitude;

  /// The angle in the direction the device is moving.
  final double heading;

  /// The movement speed of the device.
  final double speed;

  /// The accuracy of [speed].
  final double speedAccuracy;

  /// The millisecondsSinceEpoch at which the location update occurred.
  final double millisecondsSinceEpoch;

  /// The device time at which the location update occurred.
  final DateTime timestamp;

  /// Whether the mock location.
  final bool isMock;

  /// Constructs an instance of [Location].
  const Location({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.heading,
    required this.speed,
    required this.speedAccuracy,
    required this.millisecondsSinceEpoch,
    required this.timestamp,
    required this.isMock,
  });

  /// Constructs an instance of [Location] from [json].
  factory Location.fromJson(Map<String, dynamic> json) {
    final double latitude = json['latitude'] as double? ?? 0;
    final double longitude = json['longitude'] as double? ?? 0;
    final double accuracy = json['accuracy'] as double? ?? 0;
    final double altitude = json['altitude'] as double? ?? 0;
    final double heading = json['heading'] as double? ?? 0;
    final double speed = json['speed'] as double? ?? 0;
    final double speedAccuracy = json['speedAccuracy'] as double? ?? 0;

    double? millisecondsSinceEpoch = json['millisecondsSinceEpoch'] as double?;
    if (millisecondsSinceEpoch == null) {
      millisecondsSinceEpoch =
          DateTime.timestamp().millisecondsSinceEpoch.toDouble();
    }

    final DateTime timestamp =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch.toInt());

    final bool isMock = json['isMock'] ?? false;

    return Location(
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      altitude: altitude,
      heading: heading,
      speed: speed,
      speedAccuracy: speedAccuracy,
      millisecondsSinceEpoch: millisecondsSinceEpoch,
      timestamp: timestamp,
      isMock: isMock,
    );
  }

  /// Returns the data fields of [Location] in JSON format.
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'heading': heading,
      'speed': speed,
      'speedAccuracy': speedAccuracy,
      'millisecondsSinceEpoch': millisecondsSinceEpoch,
      'timestamp': timestamp.toString(),
      'isMock': isMock,
    };
  }

  @override
  String toString() => 'Location($latitude, $longitude)';

  @override
  bool operator ==(Object other) =>
      other is Location &&
      latitude == other.latitude &&
      longitude == other.longitude &&
      accuracy == other.accuracy &&
      altitude == other.altitude &&
      heading == other.heading &&
      speed == other.speed &&
      speedAccuracy == other.speedAccuracy &&
      millisecondsSinceEpoch == other.millisecondsSinceEpoch &&
      timestamp.millisecondsSinceEpoch ==
          other.timestamp.millisecondsSinceEpoch &&
      isMock == other.isMock;

  @override
  int get hashCode =>
      latitude.hashCode ^
      longitude.hashCode ^
      accuracy.hashCode ^
      altitude.hashCode ^
      heading.hashCode ^
      speed.hashCode ^
      speedAccuracy.hashCode ^
      millisecondsSinceEpoch.hashCode ^
      timestamp.hashCode ^
      isMock.hashCode;
}
