## Utility

### :lollipop: distanceBetween

Calculate the distance between origin and destination.

```dart
double function() {
  final double startLat = 32.0;
  final double startLon = 128.0;
  final double endLat = 33.0;
  final double endLon = 129.0;

  return LocationUtils.distanceBetween(startLat, startLon, endLat, endLon);
}
```

### :lollipop: bearingBetween

Calculate the bearing between origin and destination.

```dart
double function() {
  final double startLat = 32.0;
  final double startLon = 128.0;
  final double endLat = 33.0;
  final double endLon = 129.0;

  return LocationUtils.bearingBetween(startLat, startLon, endLat, endLon);
}
```
