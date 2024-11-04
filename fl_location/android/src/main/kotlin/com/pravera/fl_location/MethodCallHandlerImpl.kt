package com.pravera.fl_location

import android.app.Activity
import android.content.Context
import com.pravera.fl_location.errors.ErrorCodes
import com.pravera.fl_location.models.LocationData
import com.pravera.fl_location.models.LocationPermission
import com.pravera.fl_location.models.LocationServicesStatus
import com.pravera.fl_location.models.LocationSettings
import com.pravera.fl_location.service.LocationDataCallback
import com.pravera.fl_location.service.LocationPermissionCallback
import com.pravera.fl_location.service.ServiceProvider
import com.pravera.fl_location.utils.ErrorHandleUtils
import com.pravera.fl_location.utils.LocationServicesUtils
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** MethodCallHandlerImpl */
class MethodCallHandlerImpl(
		private val context: Context,
		private val serviceProvider: ServiceProvider):
		MethodChannel.MethodCallHandler, FlLocationPluginChannel {

	private lateinit var channel: MethodChannel
	private var activity: Activity? = null

	override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
		when (call.method) {
			"isLocationServicesEnabled" -> {
				val locationServicesStatus =
					LocationServicesUtils.checkLocationServicesStatus(context)
				result.success(locationServicesStatus == LocationServicesStatus.ENABLED)
			}
			"checkLocationPermission" -> {
				val locationPermission = serviceProvider
					.getLocationPermissionManager()
					.checkLocationPermission()
				result.success(locationPermission.ordinal)
			}
			"requestLocationPermission" -> {
				val currentActivity = activity
				if (currentActivity == null) {
					ErrorHandleUtils.handleMethodCallError(result, ErrorCodes.ACTIVITY_NOT_ATTACHED)
					return
				}

				val callback = object : LocationPermissionCallback {
					override fun onResult(locationPermission: LocationPermission) {
						result.success(locationPermission.ordinal)
					}

					override fun onError(errorCode: ErrorCodes) {
						ErrorHandleUtils.handleMethodCallError(result, errorCode)
					}
				}

				serviceProvider
					.getLocationPermissionManager()
					.requestLocationPermission(currentActivity, callback)
			}
			"getLocation" -> {
				val callback = object : LocationDataCallback {
					override fun onUpdate(locationData: LocationData) {
						result.success(locationData.toJson())
					}

					override fun onError(errorCode: ErrorCodes) {
						ErrorHandleUtils.handleMethodCallError(result, errorCode)
					}
				}

				val settingsMap = call.arguments as? Map<*, *>
				val settings = LocationSettings.fromMap(settingsMap)

				serviceProvider
					.getLocationDataProviderManager()
					.getLocation(callback, settings)
			}
			else -> result.notImplemented()
		}
	}

	override fun initChannel(messenger: BinaryMessenger) {
		channel = MethodChannel(messenger, "fl_location/methods")
		channel.setMethodCallHandler(this)
	}

	override fun setActivity(activity: Activity?) {
		this.activity = activity
	}

	override fun disposeChannel() {
		if (::channel.isInitialized) {
			channel.setMethodCallHandler(null)
		}
	}
}
