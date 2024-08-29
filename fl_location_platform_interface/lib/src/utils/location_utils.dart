import 'dart:math';

import 'package:vector_math/vector_math.dart';

/// Utility class for plugins that collect location data.
class LocationUtils {
  /// Calculate the distance between origin and destination.
  static double distanceBetween(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  ) {
    final double dLat = _toRadians(endLat - startLat);
    final double dLon = _toRadians(endLon - startLon);

    final double a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(_toRadians(startLat)) *
            cos(_toRadians(endLat));
    final double c = 2 * asin(sqrt(a));

    return 6378137.0 * c;
  }

  /// Calculate the bearing between origin and destination.
  static double bearingBetween(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  ) {
    final double startLatRadians = radians(startLat);
    final double startLonRadians = radians(startLon);
    final double endLatRadians = radians(endLat);
    final double endLonRadians = radians(endLon);

    final double y = sin(endLonRadians - startLonRadians) * cos(endLatRadians);
    final double x = cos(startLatRadians) * sin(endLatRadians) -
        sin(startLatRadians) *
            cos(endLatRadians) *
            cos(endLonRadians - startLonRadians);

    return degrees(atan2(y, x));
  }

  static double _toRadians(double degree) => degree * pi / 180;
}
