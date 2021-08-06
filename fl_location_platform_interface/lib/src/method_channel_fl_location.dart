part of fl_location_platform_interface;

/// The [FlLocationPlatform] implementation that delegates to a [MethodChannel].
class MethodChannelFlLocation extends FlLocationPlatform {
  /// The method channel used to invoke methods implemented on the platform.
  static const MethodChannel methodChannel =
      MethodChannel('plugins.pravera.com/fl_location');

  /// The event channel used to receive location updates from the platform.
  static const EventChannel locationEventChannel =
      EventChannel('plugins.pravera.com/fl_location/updates');

  /// The event channel used to receive location services status updates from the platform.
  static const EventChannel locationServicesStatusEventChannel =
      EventChannel('plugins.pravera.com/fl_location/location_services_status');

  Stream<Location>? _locationStream;
  Stream<LocationServicesStatus>? _locationServicesStatusStream;

  @override
  Future<bool> isLocationServicesEnabled() async {
    final int result =
        await methodChannel.invokeMethod('checkLocationServicesStatus');
    return result == LocationServicesStatus.enabled.index;
  }

  @override
  Future<LocationPermission> checkLocationPermission() async {
    final int result =
        await methodChannel.invokeMethod('checkLocationPermission');
    return getLocationPermissionFromIndex(result);
  }

  @override
  Future<LocationPermission> requestLocationPermission() async {
    final int result =
        await methodChannel.invokeMethod('requestLocationPermission');
    return getLocationPermissionFromIndex(result);
  }

  @override
  Future<Location> getLocation({
    LocationAccuracy accuracy = LocationAccuracy.best,
    Duration? timeLimit,
  }) async {
    final locationSettings = Map<String, dynamic>();
    locationSettings['accuracy'] = accuracy.index;

    final locationJson = timeLimit == null
        ? await methodChannel.invokeMethod('getLocation', locationSettings)
        : await methodChannel
            .invokeMethod('getLocation', locationSettings)
            .timeout(timeLimit);
    return Location.fromJson(jsonDecode(locationJson));
  }

  @override
  Stream<Location> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.best,
    int interval = 5000,
    double distanceFilter = 0.0,
  }) {
    final locationSettings = Map<String, dynamic>();
    locationSettings['accuracy'] = accuracy.index;
    locationSettings['interval'] = interval;
    locationSettings['distanceFilter'] = distanceFilter;

    return _locationStream ??= locationEventChannel
        .receiveBroadcastStream(locationSettings)
        .map((event) => Location.fromJson(jsonDecode(event)));
  }

  @override
  Stream<LocationServicesStatus> getLocationServicesStatusStream() {
    return _locationServicesStatusStream ??= locationServicesStatusEventChannel
        .receiveBroadcastStream()
        .map((event) => getLocationServicesStatusFromIndex(event));
  }
}
