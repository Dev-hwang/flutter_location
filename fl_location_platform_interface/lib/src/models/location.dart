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
    final double? lat = double.tryParse(json['latitude'].toString());
    final double? lon = double.tryParse(json['longitude'].toString());
    if (lat == null) throw ArgumentError.notNull('latitude');
    if (lon == null) throw ArgumentError.notNull('longitude');

    double? millisecondsSinceEpoch =
        double.tryParse(json['millisecondsSinceEpoch'].toString());
    if (millisecondsSinceEpoch == null) {
      millisecondsSinceEpoch =
          DateTime.timestamp().millisecondsSinceEpoch.toDouble();
    }

    final DateTime timestamp =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch.toInt());

    return Location(
      latitude: lat,
      longitude: lon,
      accuracy: double.tryParse(json['accuracy'].toString()) ?? 0.0,
      altitude: double.tryParse(json['altitude'].toString()) ?? 0.0,
      heading: double.tryParse(json['heading'].toString()) ?? 0.0,
      speed: double.tryParse(json['speed'].toString()) ?? 0.0,
      speedAccuracy: double.tryParse(json['speedAccuracy'].toString()) ?? 0.0,
      millisecondsSinceEpoch: millisecondsSinceEpoch,
      timestamp: timestamp,
      isMock: json['isMock'] ?? false,
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
      timestamp == other.timestamp &&
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
