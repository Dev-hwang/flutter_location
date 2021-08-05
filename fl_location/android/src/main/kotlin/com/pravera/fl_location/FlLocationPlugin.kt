package com.pravera.fl_location

import com.pravera.fl_location.service.LocationDataProvider
import com.pravera.fl_location.service.LocationPermissionManager
import com.pravera.fl_location.service.LocationServicesStatusWatcher
import com.pravera.fl_location.service.ServiceProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** FlLocationPlugin */
class FlLocationPlugin: FlutterPlugin, ActivityAware, ServiceProvider {
  private lateinit var locationPermissionManager: LocationPermissionManager
  private lateinit var locationDataProvider: LocationDataProvider
  private lateinit var locationServicesStatusWatcher: LocationServicesStatusWatcher

  private var activityBinding: ActivityPluginBinding? = null
  private lateinit var methodCallHandler: MethodCallHandlerImpl
  private lateinit var locationStreamHandler: LocationStreamHandlerImpl
  private lateinit var locationServicesStatusStreamHandler: LocationServicesStatusStreamHandlerImpl

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    val applicationContext = binding.applicationContext
    val binaryMessenger = binding.binaryMessenger

    locationPermissionManager = LocationPermissionManager()
    locationDataProvider = LocationDataProvider(applicationContext)
    locationServicesStatusWatcher = LocationServicesStatusWatcher()

    methodCallHandler = MethodCallHandlerImpl(applicationContext, this)
    methodCallHandler.initChannel(binaryMessenger)
    locationStreamHandler = LocationStreamHandlerImpl(applicationContext, this)
    locationStreamHandler.initChannel(binaryMessenger)
    locationServicesStatusStreamHandler =
        LocationServicesStatusStreamHandlerImpl(applicationContext, this)
    locationServicesStatusStreamHandler.initChannel(binaryMessenger)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    if (::methodCallHandler.isInitialized)
      methodCallHandler.disposeChannel()
    if (::locationStreamHandler.isInitialized)
      locationStreamHandler.disposeChannel()
    if (::locationServicesStatusStreamHandler.isInitialized)
      locationServicesStatusStreamHandler.disposeChannel()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    methodCallHandler.setActivity(binding.activity)
    locationStreamHandler.setActivity(binding.activity)
    locationServicesStatusStreamHandler.setActivity(binding.activity)
    binding.addRequestPermissionsResultListener(locationPermissionManager)
    binding.addActivityResultListener(locationDataProvider)
    activityBinding = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    activityBinding?.removeRequestPermissionsResultListener(locationPermissionManager)
    activityBinding?.removeActivityResultListener(locationDataProvider)
    activityBinding = null
    methodCallHandler.setActivity(null)
    locationStreamHandler.setActivity(null)
    locationServicesStatusStreamHandler.setActivity(null)
  }

  override fun getLocationPermissionManager() = locationPermissionManager

  override fun getLocationDataProvider() = locationDataProvider

  override fun getLocationServicesStatusWatcher() = locationServicesStatusWatcher
}
