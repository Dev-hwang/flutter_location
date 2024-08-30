import 'dart:html' as html;
import 'dart:developer' as dev;

import 'package:fl_location_platform_interface/fl_location_platform_interface.dart';
import 'package:flutter/foundation.dart';
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
    // ref: https://developer.chrome.com/blog/permissions-api-for-the-web
    final html.PermissionStatus? permissionStatus =
        await _permissions?.query({'name': 'geolocation'});

    final String? permissionState = permissionStatus?.state;

    switch (permissionState) {
      case 'granted':
        return LocationPermission.whileInUse;
      case 'prompt':
        return LocationPermission.denied;
      case 'denied':
        return LocationPermission.deniedForever;
      default:
        dev.log('location permission denied: $permissionState');
        return LocationPermission.denied;
    }
  }

  @override
  Future<LocationPermission> requestLocationPermission() async {
    try {
      // show permission prompt
      await _geolocation.getCurrentPosition();
      return LocationPermission.whileInUse;
    } catch (e) {
      dev.log('location permission denied: $e');
      return LocationPermission.deniedForever;
    }
  }

  @override
  Future<Location> getLocation({
    LocationAccuracy accuracy = LocationAccuracy.best,
    Duration? timeLimit,
  }) async {
    final html.Geoposition position = await _geolocation.getCurrentPosition(
      enableHighAccuracy: accuracy.index >= LocationAccuracy.high.index,
      timeout: timeLimit,
    );

    return toLocation(position);
  }

  @override
  Stream<Location> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.best,
    int interval = 5000,
    double distanceFilter = 0.0,
  }) {
    return _geolocation
        .watchPosition(
            enableHighAccuracy: accuracy.index >= LocationAccuracy.high.index)
        .map(toLocation);
  }

  @visibleForTesting
  Location toLocation(html.Geoposition position) {
    return Location.fromJson({
      'latitude': position.coords?.latitude,
      'longitude': position.coords?.longitude,
      'accuracy': position.coords?.accuracy,
      'altitude': position.coords?.altitude,
      'heading': position.coords?.heading,
      'speed': position.coords?.speed,
      'speedAccuracy': 0.0,
      'millisecondsSinceEpoch': position.timestamp,
      'isMock': false,
    });
  }
}
