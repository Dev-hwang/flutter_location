package com.pravera.fl_location.service

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.pravera.fl_location.errors.ErrorCodes
import com.pravera.fl_location.models.LocationPermission
import io.flutter.plugin.common.PluginRegistry

class LocationPermissionManager(private val context: Context) : PluginRegistry.RequestPermissionsResultListener {
	companion object {
		private const val LOCATION_PERMISSION_REQ_CODE = 109
		private const val BACKGROUND_LOCATION_PERMISSION_REQ_CODE = 110
		private const val PREV_PERMISSION_STATUS_PREFS_NAME = "PREV_PERMISSION_STATUS_PREFS"
	}

	private var activity: Activity? = null
	private var callback: LocationPermissionCallback? = null

	private fun getLocationPermission(): String {
		val coarseLocationPermission = Manifest.permission.ACCESS_COARSE_LOCATION
		val fineLocationPermission = Manifest.permission.ACCESS_FINE_LOCATION
		if (hasPermissionInManifest(fineLocationPermission)) {
			return fineLocationPermission
		}
		return coarseLocationPermission
	}

	fun checkLocationPermission(): LocationPermission {
		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
			return LocationPermission.ALWAYS
		}

		val locationPermission = getLocationPermission()
		if (!isPermissionGranted(locationPermission)) {
			val prevLocationPermission = getPrevPermissionStatus(locationPermission)
			if (prevLocationPermission == LocationPermission.DENIED_FOREVER) {
				return LocationPermission.DENIED_FOREVER
			}

			return LocationPermission.DENIED
		}

		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
			return LocationPermission.ALWAYS
		}

		if (isPermissionGranted(Manifest.permission.ACCESS_BACKGROUND_LOCATION)) {
			return LocationPermission.ALWAYS
		}

		return LocationPermission.WHILE_IN_USE
	}

	fun requestLocationPermission(activity: Activity, callback: LocationPermissionCallback) {
		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
			callback.onResult(LocationPermission.ALWAYS)
			return
		}

		// The app has already requested location permission and is waiting for the result.
		if (this.callback != null) {
			callback.onError(ErrorCodes.LOCATION_PERMISSION_REQUEST_CANCELLED)
			return
		}

		this.activity = activity
		this.callback = callback

		val locationPermission = getLocationPermission()
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
            && isPermissionGranted(locationPermission)
            && hasPermissionInManifest(Manifest.permission.ACCESS_BACKGROUND_LOCATION)) {
            // request background location permission
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(Manifest.permission.ACCESS_BACKGROUND_LOCATION),
                BACKGROUND_LOCATION_PERMISSION_REQ_CODE)
		} else {
            // request location permission
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(locationPermission),
                LOCATION_PERMISSION_REQ_CODE)
        }
	}

	private fun hasPermissionInManifest(permission: String): Boolean {
		val packageName = context.packageName
		val packageInfo = context.packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS)
		val permissions = packageInfo.requestedPermissions

		return permissions?.any { perm -> perm == permission } ?: false
	}

	private fun isPermissionGranted(permission: String): Boolean {
		return ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED
	}

	private fun setPrevPermissionStatus(permission: String, status: LocationPermission) {
		val prefs = context.getSharedPreferences(
			PREV_PERMISSION_STATUS_PREFS_NAME, Context.MODE_PRIVATE) ?: return

		with (prefs.edit()) {
			putString(permission, status.toString())
			commit()
		}
	}

	private fun getPrevPermissionStatus(permission: String): LocationPermission? {
		val prefs = context.getSharedPreferences(
			PREV_PERMISSION_STATUS_PREFS_NAME, Context.MODE_PRIVATE) ?: return null
		val value = prefs.getString(permission, null) ?: return null

		return LocationPermission.valueOf(value)
	}

	private fun disposeResources() {
		this.activity = null
		this.callback = null
	}

	@SuppressLint("InlinedApi")
	override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
		val currentActivity = this.activity ?: return false
		val currentCallback = this.callback ?: return false

		if (grantResults.isEmpty()) {
			currentCallback.onError(ErrorCodes.LOCATION_PERMISSION_REQUEST_CANCELLED)
			disposeResources()
			return false
		}

		val permission: String
		val permissionIndex: Int
		val permissionResult: LocationPermission

		when (requestCode) {
			LOCATION_PERMISSION_REQ_CODE -> {
				permission = getLocationPermission()
				permissionIndex = permissions.indexOf(permission)

				permissionResult = if (permissionIndex >= 0 &&
					grantResults[permissionIndex] == PackageManager.PERMISSION_GRANTED) {
					if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
						LocationPermission.ALWAYS
					} else {
						LocationPermission.WHILE_IN_USE
					}
				} else {
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
						!currentActivity.shouldShowRequestPermissionRationale(permission)) {
						LocationPermission.DENIED_FOREVER
					} else {
						LocationPermission.DENIED
					}
				}
			}
			BACKGROUND_LOCATION_PERMISSION_REQ_CODE -> {
				permission = Manifest.permission.ACCESS_BACKGROUND_LOCATION
				permissionIndex = permissions.indexOf(permission)

				permissionResult = if (permissionIndex >= 0 &&
					grantResults[permissionIndex] == PackageManager.PERMISSION_GRANTED) {
					LocationPermission.ALWAYS
				} else {
					LocationPermission.WHILE_IN_USE
				}
			}
			else -> return false
		}

        setPrevPermissionStatus(permission, permissionResult)
        currentCallback.onResult(permissionResult)
        disposeResources()

        return true
    }
}
