class PositionUnavailableException implements Exception {
  PositionUnavailableException(
      [this.message =
          "The acquisition of the geolocation failed because at least one internal source of position returned an internal error."]);

  final String message;

  @override
  String toString() => "PositionUnavailableException: $message";
}
