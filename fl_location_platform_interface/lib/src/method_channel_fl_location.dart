part of fl_location_platform_interface;

/// The [FlLocationPlatform] implementation that delegates to a [MethodChannel].
class MethodChannelFlLocation extends FlLocationPlatform {
  /// The method channel used to invoke methods implemented on the platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fl_location/methods');

  /// The event channel used to receive location updates from the platform.
  @visibleForTesting
  final locationEventChannel = const EventChannel('fl_location/location');

  /// The event channel used to receive location services status updates from the platform.
  @visibleForTesting
  final locationServicesStatusEventChannel =
      const EventChannel('fl_location/location_services_status');

  Stream<Location>? _locationStream;
  Stream<LocationServicesStatus>? _locationServicesStatusStream;

  @override
  Future<bool> isLocationServicesEnabled() async {
    return await methodChannel.invokeMethod('isLocationServicesEnabled');
  }

  @override
  Future<LocationPermission> checkLocationPermission() async {
    final int result =
        await methodChannel.invokeMethod('checkLocationPermission');
    return LocationPermission.fromIndex(result);
  }

  @override
  Future<LocationPermission> requestLocationPermission() async {
    final int result =
        await methodChannel.invokeMethod('requestLocationPermission');
    return LocationPermission.fromIndex(result);
  }

  @override
  Future<Location> getLocation({
    LocationAccuracy accuracy = LocationAccuracy.best,
    Duration? timeLimit,
  }) async {
    final Map<String, dynamic> settings = {
      'accuracy': accuracy.index,
    };

    final dynamic locationJson = (timeLimit == null)
        ? await methodChannel.invokeMethod('getLocation', settings)
        : await methodChannel
            .invokeMethod('getLocation', settings)
            .timeout(timeLimit);

    return Location.fromJson(_cast(locationJson));
  }

  @override
  Stream<Location> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.best,
    int interval = 5000,
    double distanceFilter = 0.0,
  }) {
    final Map<String, dynamic> settings = {
      'accuracy': accuracy.index,
      'interval': interval,
      'distanceFilter': distanceFilter,
    };

    return _locationStream ??= locationEventChannel
        .receiveBroadcastStream(settings)
        .map((event) => Location.fromJson(_cast(event)));
  }

  @override
  Stream<LocationServicesStatus> getLocationServicesStatusStream() {
    return _locationServicesStatusStream ??= locationServicesStatusEventChannel
        .receiveBroadcastStream()
        .map((event) => LocationServicesStatus.fromIndex(event));
  }

  Map<String, dynamic> _cast(dynamic result) {
    final Map<String, dynamic> castedResult =
        (result as Map<Object?, Object?>).cast<String, dynamic>();

    return Map<String, dynamic>.of(castedResult);
  }
}
