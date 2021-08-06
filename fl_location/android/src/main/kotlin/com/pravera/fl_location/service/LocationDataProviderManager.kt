package com.pravera.fl_location.service

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.pravera.fl_location.errors.ErrorCodes
import com.pravera.fl_location.models.LocationSettings
import io.flutter.plugin.common.PluginRegistry

class LocationDataProviderManager(private val context: Context): PluginRegistry.ActivityResultListener {
	private val providers = mutableMapOf<Int, LocationDataProvider>()

	private fun buildLocationDataProvider() = LocationDataProvider(context)

	fun getLocation(
			activity: Activity?,
			callback: LocationDataCallback,
			settings: LocationSettings): Int {
		val newLocationDataProvider = buildLocationDataProvider()
		val hashCode = newLocationDataProvider.hashCode()
		providers[hashCode] = newLocationDataProvider

		val newCallback = object : LocationDataCallback {
			override fun onUpdate(locationJson: String) {
				stopLocationUpdates(hashCode)
				callback.onUpdate(locationJson)
			}

			override fun onError(errorCode: ErrorCodes) {
				stopLocationUpdates(hashCode)
				callback.onError(errorCode)
			}
		}

		newLocationDataProvider.requestLocationUpdates(activity, newCallback, settings)
		return hashCode
	}

	fun requestLocationUpdates(
			activity: Activity?,
			callback: LocationDataCallback,
			settings: LocationSettings): Int {
		val newLocationDataProvider = buildLocationDataProvider()
		val hashCode = newLocationDataProvider.hashCode()
		providers[hashCode] = newLocationDataProvider

		newLocationDataProvider.requestLocationUpdates(activity, callback, settings)
		return hashCode
	}

	fun stopLocationUpdates(hashCode: Int) {
		providers[hashCode]?.let {
			it.stopLocationUpdates()
			providers.remove(hashCode)
		}
	}

	override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
		for (provider in providers.values) {
			if (provider.onActivityResult(requestCode, resultCode)) {
				return true
			}
		}

		return false
	}
}
