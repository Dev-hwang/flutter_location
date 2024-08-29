/// An enumeration of location permission.
enum LocationPermission {
  /// The app can read location at any time.
  ///
  /// The app need this permission to read location in the background.
  always,

  /// The location can only be read while using the app.
  whileInUse,

  /// The location cannot be read because permission is denied.
  ///
  /// The app can request runtime permissions again.
  denied,

  /// The location cannot be read because permission is denied.
  ///
  /// The app can no longer request runtime permissions and must grant permissions manually.
  deniedForever;

  static LocationPermission fromIndex(int? index) =>
      LocationPermission.values[index ?? LocationPermission.denied.index];
}
