import 'dart:html' as html;

import 'package:fl_location_platform_interface/fl_location_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FlLocationWeb extends FlLocationPlatform {
  FlLocationWeb(html.Navigator navigator)
      : _permissions = navigator.permissions,
        _geolocation = navigator.geolocation;

  final html.Permissions? _permissions;
  final html.Geolocation _geolocation;

  static void registerWith(Registrar registrar) =>
      FlLocationPlatform.instance = FlLocationWeb(html.window.navigator);

  @override
  Future<bool> isLocationServicesEnabled() => Future.value(true);

  @override
  Future<LocationPermission> checkLocationPermission() async {
    final permissionStatus = await _permissions?.query({'name': 'geolocation'});

    switch (permissionStatus?.state) {
      case 'granted':
        return LocationPermission.whileInUse;
      case 'prompt':
        return LocationPermission.denied;
      case 'denied':
        return LocationPermission.deniedForever;
      default:
        throw ArgumentError(
            'Unknown permission status ${permissionStatus?.state}');
    }
  }

  @override
  Future<LocationPermission> requestLocationPermission() async {
    try {
      await _geolocation.getCurrentPosition();
      return LocationPermission.whileInUse;
    } catch (_) {
      return LocationPermission.deniedForever;
    }
  }

  @override
  Future<Location> getLocation({
    LocationAccuracy accuracy = LocationAccuracy.best,
    Duration? timeLimit,
  }) async {
    final position = await _geolocation.getCurrentPosition(
      enableHighAccuracy: accuracy.index >= LocationAccuracy.high.index,
      timeout: timeLimit,
    );

    return _toLocation(position);
  }

  @override
  Stream<Location> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.best,
    int interval = 5000,
    double distanceFilter = 0.0,
  }) {
    return _geolocation
        .watchPosition(
          enableHighAccuracy: accuracy.index >= LocationAccuracy.high.index,
        )
        .map(_toLocation);
  }

  Location _toLocation(html.Geoposition position) {
    return Location.fromJson({
      'latitude': position.coords?.latitude,
      'longitude': position.coords?.longitude,
      'accuracy': position.coords?.accuracy,
      'altitude': position.coords?.altitude,
      'heading': position.coords?.heading,
      'speed': position.coords?.speed,
      'speedAccuracy': 0.0,
      'millisecondsSinceEpoch': position.timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(position.timestamp!)
          : DateTime.now(),
      'isMock': false,
    });
  }
}
