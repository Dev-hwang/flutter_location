import 'dart:convert';

import 'package:fl_location_platform_interface/fl_location_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dummy/location_dummy.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MethodChannelFlLocation platform = MethodChannelFlLocation();

  final Location dummyLocationA = Location.fromJson(dummyLocationJsonA);
  final Location dummyLocationB = Location.fromJson(dummyLocationJsonB);

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      platform.methodChannel,
      (MethodCall methodCall) async {
        final String method = methodCall.method;
        if (method == 'isLocationServicesEnabled') {
          return true;
        } else if (method == 'checkLocationPermission') {
          return LocationPermission.always.index;
        } else if (method == 'requestLocationPermission') {
          return LocationPermission.denied.index;
        } else if (method == 'getLocation') {
          final Map settings = methodCall.arguments;
          final int accuracy = settings['accuracy'];
          if (accuracy == LocationAccuracy.best.index) {
            return jsonEncode(dummyLocationA.toJson());
          } else {
            return jsonEncode(dummyLocationB.toJson());
          }
        } else {
          return true;
        }
      },
    );
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, null);
  });

  test('isLocationServicesEnabled test', () async {
    final bool result = await platform.isLocationServicesEnabled();
    expect(result, true);
  });

  test('checkLocationPermission test', () async {
    final LocationPermission result = await platform.checkLocationPermission();
    expect(result, LocationPermission.always);
  });

  test('requestLocationPermission test', () async {
    final LocationPermission result =
        await platform.requestLocationPermission();
    expect(result, LocationPermission.denied);
  });

  test('getLocation test', () async {
    final Location locationA =
        await platform.getLocation(accuracy: LocationAccuracy.best);
    expect(locationA, dummyLocationA);

    final Location locationB =
        await platform.getLocation(accuracy: LocationAccuracy.balanced);
    expect(locationB, dummyLocationB);
  });
}
