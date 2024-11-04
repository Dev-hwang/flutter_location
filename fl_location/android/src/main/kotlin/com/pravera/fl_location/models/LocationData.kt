package com.pravera.fl_location.models

data class LocationData(
	val latitude: Double,
	val longitude: Double,
	val accuracy: Double,
	val altitude: Double,
	val heading: Double,
	val speed: Double,
	val speedAccuracy: Double?,
	val millisecondsSinceEpoch: Double,
	val isMock: Boolean?
) {
	fun toJson(): Map<String, Any?> {
		val json = mutableMapOf<String, Any?>()
		json["latitude"] = latitude
		json["longitude"] = longitude
		json["accuracy"] = accuracy
		json["altitude"] = altitude
		json["heading"] = heading
		json["speed"] = speed
		json["speedAccuracy"] = speedAccuracy
		json["millisecondsSinceEpoch"] = millisecondsSinceEpoch
		json["isMock"] = isMock

		return json
	}
}
