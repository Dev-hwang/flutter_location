package com.pravera.fl_location.service

import com.pravera.fl_location.errors.ErrorCodes
import com.pravera.fl_location.models.LocationData

interface LocationDataCallback {
	fun onUpdate(locationData: LocationData)
	fun onError(errorCode: ErrorCodes)
}
