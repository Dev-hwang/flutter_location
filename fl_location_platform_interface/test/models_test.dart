import 'package:fl_location_platform_interface/fl_location_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dummy/location_dummy.dart';

void main() {
  group('location', () {
    test('fromJson test', () {
      final Map<String, dynamic> locationJson = dummyLocationJsonA;
      final Location location = Location.fromJson(locationJson);

      expect(location.latitude, locationJson['latitude']);
      expect(location.longitude, locationJson['longitude']);
      expect(location.accuracy, locationJson['accuracy']);
      expect(location.altitude, locationJson['altitude']);
      expect(location.heading, locationJson['heading']);
      expect(location.speed, locationJson['speed']);
      expect(location.speedAccuracy, locationJson['speedAccuracy']);
      expect(location.millisecondsSinceEpoch,
          locationJson['millisecondsSinceEpoch']);
      expect(location.isMock, locationJson['isMock']);
    });

    test('toJson test', () {
      final Location location = Location.fromJson(dummyLocationJsonA);
      final Map<String, dynamic> locationJson = location.toJson();

      expect(location.latitude, locationJson['latitude']);
      expect(location.longitude, locationJson['longitude']);
      expect(location.accuracy, locationJson['accuracy']);
      expect(location.altitude, locationJson['altitude']);
      expect(location.heading, locationJson['heading']);
      expect(location.speed, locationJson['speed']);
      expect(location.speedAccuracy, locationJson['speedAccuracy']);
      expect(location.millisecondsSinceEpoch,
          locationJson['millisecondsSinceEpoch']);
      expect(location.isMock, locationJson['isMock']);
    });

    test('equals(true) test', () {
      final Location locationA = Location.fromJson(dummyLocationJsonA);
      final Location locationB = Location.fromJson(dummyLocationJsonA);
      expect(locationA, locationB);
    });

    test('equals(false) test', () {
      final Location locationA = Location.fromJson(dummyLocationJsonA);
      final Location locationB = Location.fromJson(dummyLocationJsonB);
      expect(locationA, isNot(locationB));
    });
  });

  group('location_accuracy', () {
    test('fromIndex test', () {
      expect(LocationAccuracy.fromIndex(0), LocationAccuracy.powerSave);
      expect(LocationAccuracy.fromIndex(1), LocationAccuracy.low);
      expect(LocationAccuracy.fromIndex(2), LocationAccuracy.balanced);
      expect(LocationAccuracy.fromIndex(3), LocationAccuracy.high);
      expect(LocationAccuracy.fromIndex(4), LocationAccuracy.best);
      expect(LocationAccuracy.fromIndex(5), LocationAccuracy.navigation);
      expect(LocationAccuracy.fromIndex(null), LocationAccuracy.powerSave);
    });
  });

  group('location_permission', () {
    test('fromIndex test', () {
      expect(LocationPermission.fromIndex(0), LocationPermission.always);
      expect(LocationPermission.fromIndex(1), LocationPermission.whileInUse);
      expect(LocationPermission.fromIndex(2), LocationPermission.denied);
      expect(LocationPermission.fromIndex(3), LocationPermission.deniedForever);
      expect(LocationPermission.fromIndex(null), LocationPermission.denied);
    });
  });

  group('location_services_status', () {
    test('fromIndex test', () {
      expect(
        LocationServicesStatus.fromIndex(0),
        LocationServicesStatus.enabled,
      );
      expect(
        LocationServicesStatus.fromIndex(1),
        LocationServicesStatus.disabled,
      );
      expect(
        LocationServicesStatus.fromIndex(null),
        LocationServicesStatus.disabled,
      );
    });
  });
}
