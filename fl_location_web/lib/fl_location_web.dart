import 'dart:async';
import 'dart:developer' as dev;
import 'dart:js_interop';

import 'package:fl_location_platform_interface/fl_location_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'errors/geolocation_permission_denied_exception.dart';
import 'errors/position_unavailable_exception.dart';

class FlLocationWeb extends FlLocationPlatform {
  FlLocationWeb(web.Navigator navigator)
      : _permissions = navigator.permissions,
        _geolocation = navigator.geolocation;

  final web.Permissions _permissions;
  final web.Geolocation _geolocation;

  static void registerWith(Registrar registrar) =>
      FlLocationPlatform.instance = FlLocationWeb(web.window.navigator);

  @override
  Future<bool> isLocationServicesEnabled() => Future.value(true);

  @override
  Future<LocationPermission> checkLocationPermission() async {
    // ref: https://developer.chrome.com/blog/permissions-api-for-the-web
    final web.PermissionStatus permissionStatus =
        await _permissions.query(_PermissionDesc(name: 'geolocation')).toDart;

    return toLocationPermission(permissionStatus.state);
  }

  @override
  Future<LocationPermission> requestLocationPermission() async {
    try {
      // show location permission prompt
      await _getLocation();

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
    final web.PositionOptions options = web.PositionOptions(
      enableHighAccuracy: accuracy.index >= LocationAccuracy.high.index,
      timeout: timeLimit?.inMilliseconds ?? Duration(days: 1).inMilliseconds,
    );

    return _getLocation(options);
  }

  @override
  Stream<Location> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.best,
    int interval = 5000,
    double distanceFilter = 0.0,
  }) {
    final web.PositionOptions options = web.PositionOptions(
      enableHighAccuracy: accuracy.index >= LocationAccuracy.high.index,
    );

    int? watchId;
    final StreamController<Location> controller = StreamController(
      sync: true,
      onCancel: () {
        final int? id = watchId;
        if (id != null) {
          _geolocation.clearWatch(id);
        }
      },
    );

    controller.onListen = () {
      assert(watchId == null);
      watchId = _geolocation.watchPosition(
        (web.GeolocationPosition position) {
          controller.add(toLocation(position));
        }.toJS,
        (web.GeolocationPositionError error) {
          controller.addError(toLocationException(error));
        }.toJS,
        options,
      );
    };

    return controller.stream;
  }

  Future<Location> _getLocation([web.PositionOptions? options]) {
    final Completer<Location> completer = Completer();
    try {
      _geolocation.getCurrentPosition(
        (web.GeolocationPosition position) {
          completer.complete(toLocation(position));
        }.toJS,
        (web.GeolocationPositionError error) {
          completer.completeError(toLocationException(error));
        }.toJS,
        options ?? web.PositionOptions(),
      );
    } catch (_) {
      completer.completeError(PositionUnavailableException());
    }

    return completer.future;
  }

  @visibleForTesting
  LocationPermission toLocationPermission(String webPermission) {
    switch (webPermission) {
      case 'granted':
        return LocationPermission.whileInUse;
      case 'prompt':
        return LocationPermission.denied;
      case 'denied':
        return LocationPermission.deniedForever;
      default:
        dev.log('unknown permission: $webPermission');
        return LocationPermission.denied;
    }
  }

  @visibleForTesting
  Location toLocation(web.GeolocationPosition position) {
    return Location.fromJson({
      'latitude': position.coords.latitude,
      'longitude': position.coords.longitude,
      'accuracy': position.coords.accuracy,
      'altitude': position.coords.altitude,
      'heading': position.coords.heading,
      'speed': position.coords.speed,
      'millisecondsSinceEpoch': position.timestamp,
      'isMock': false,
    });
  }

  @visibleForTesting
  Exception toLocationException(web.GeolocationPositionError error) {
    // ref: https://developer.mozilla.org/en-US/docs/Web/API/GeolocationPositionError
    final int code = error.code;
    final String message = error.message;

    switch (code) {
      case 1:
        return GeolocationPermissionDeniedException(message);
      case 2:
        return PositionUnavailableException(message);
      case 3:
        return TimeoutException(message);
      default:
        return PlatformException(code: code.toString(), message: message);
    }
  }
}

extension type _PermissionDesc._(JSObject _) implements JSObject {
  external factory _PermissionDesc({required String name});

  external set name(String value);

  external String get name;
}
