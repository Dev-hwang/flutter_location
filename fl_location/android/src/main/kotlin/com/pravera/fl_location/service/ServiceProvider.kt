package com.pravera.fl_location.service

interface ServiceProvider {
	fun getLocationPermissionManager(): LocationPermissionManager
	fun getLocationDataProvider(): LocationDataProvider
	fun getLocationServicesStatusWatcher(): LocationServicesStatusWatcher
}
