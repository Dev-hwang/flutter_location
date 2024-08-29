import 'package:fl_location_platform_interface/fl_location_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Offset latLngA = Offset(32.0, 128.0);
  final Offset latLngB = Offset(35.0, 129.0);

  test('distanceBetween test', () {
    final double distance = LocationUtils.distanceBetween(
      latLngA.dx,
      latLngA.dy,
      latLngB.dx,
      latLngB.dy,
    );
    expect(distance, 346613.0813496439);
  });

  test('bearingBetween test', () {
    final double bearing = LocationUtils.bearingBetween(
      latLngA.dx,
      latLngA.dy,
      latLngB.dx,
      latLngB.dy,
    );

    expect(bearing, 15.259902697661822);
  });
}
