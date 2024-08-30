/// An enumeration of location accuracy.
enum LocationAccuracy {
  /// The location has an accuracy of 10km on Android and 3km on iOS.
  powerSave,

  /// The location has an accuracy of 10km on Android and 1km on iOS.
  low,

  /// The location has an accuracy of 100m for both Android and iOS.
  balanced,

  /// The location has an accuracy of ~100m on Android and 10m on iOS.
  high,

  /// The location has an accuracy of ~100m on Android and ~10m on iOS.
  best,

  /// The location has an accuracy of ~100m on Android and optimized for navigation on iOS.
  navigation;

  static LocationAccuracy fromIndex(int? index) =>
      LocationAccuracy.values[index ?? LocationAccuracy.powerSave.index];
}
