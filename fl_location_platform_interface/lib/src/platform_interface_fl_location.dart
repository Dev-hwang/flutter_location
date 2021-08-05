part of fl_location_platform_interface;

/// The interface that implementations of `fl_location` must extend.
///
/// Platform implementations should extend this class rather than implement it
/// as `fl_location` does not consider newly added methods to be breaking
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added
/// [FlLocationPlatform] methods.
abstract class FlLocationPlatform extends PlatformInterface {
  FlLocationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlLocationPlatform _instance = MethodChannelFlLocation();

  /// The default instance of [FlLocationPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlLocation].
  static FlLocationPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlLocationPlatform] when they register themselves.
  static set instance(FlLocationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Whether location services are enabled.
  Future<bool> isLocationServicesEnabled() {
    throw UnimplementedError(
        'isLocationServicesEnabled() has not been implemented.');
  }

  /// Check location permission.
  Future<LocationPermission> checkLocationPermission() {
    throw UnimplementedError(
        'checkLocationPermission() has not been implemented.');
  }

  /// Request location permission.
  Future<LocationPermission> requestLocationPermission() {
    throw UnimplementedError(
        'requestLocationPermission() has not been implemented.');
  }

  /// Get the current location.
  Future<Location> getLocation({
    LocationAccuracy accuracy = LocationAccuracy.best,
    Duration? timeLimit,
  }) {
    throw UnimplementedError('getLocation() has not been implemented.');
  }

  /// Get the location stream.
  Stream<Location> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.best,
    int interval = 5000,
    double distanceFilter = 0.0,
  }) {
    throw UnimplementedError('getLocationStream() has not been implemented.');
  }

  /// Get the location services status stream.
  Stream<LocationServicesStatus> getLocationServicesStatusStream() {
    throw UnimplementedError(
        'getLocationServicesStatusStream() has not been implemented.');
  }
}
