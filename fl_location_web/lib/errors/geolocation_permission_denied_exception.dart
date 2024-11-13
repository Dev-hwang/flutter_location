class GeolocationPermissionDeniedException implements Exception {
  GeolocationPermissionDeniedException(
      [this.message =
          "The acquisition of the geolocation information failed because the page didn't have the necessary permissions."]);

  final String message;

  @override
  String toString() => "GeolocationPermissionDeniedException: $message";
}
