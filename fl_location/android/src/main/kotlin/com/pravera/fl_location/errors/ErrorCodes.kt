package com.pravera.fl_location.errors

enum class ErrorCodes {
	ACTIVITY_NOT_ATTACHED,
	LOCATION_PERMISSION_REQUEST_CANCELLED,
	LOCATION_SETTINGS_CHANGE_FAILED,
	LOCATION_SERVICES_NOT_AVAILABLE;

	fun message(): String {
		return when (this) {
			ACTIVITY_NOT_ATTACHED ->
				"Cannot call method because Activity is not attached to FlutterEngine."
			LOCATION_PERMISSION_REQUEST_CANCELLED ->
				"The location permission request dialog was closed or the request was cancelled."
			LOCATION_SETTINGS_CHANGE_FAILED ->
				"Failed to change location settings."
			LOCATION_SERVICES_NOT_AVAILABLE ->
				"Location services are not available."
		}
	}
}
