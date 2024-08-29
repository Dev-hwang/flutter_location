/// An enumeration of location services status.
enum LocationServicesStatus {
  /// Location services are enabled.
  enabled,

  /// Location services are disabled.
  disabled;

  static LocationServicesStatus fromIndex(int? index) => LocationServicesStatus
      .values[index ?? LocationServicesStatus.disabled.index];
}
