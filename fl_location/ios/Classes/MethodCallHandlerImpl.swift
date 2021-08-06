//
//  MethodCallHandlerImpl.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/26.
//

import Flutter
import Foundation

class MethodCallHandlerImpl: NSObject, LocationPermissionHandler, LocationDataHandler {
  private let channel: FlutterMethodChannel
  private let serviceProvider: ServiceProvider
  
  private var locationPermissionResult: FlutterResult? = nil
  private var locationDataResult: FlutterResult? = nil
  private var locationDataProviderHashCode: Int? = nil
  
  init(messenger: FlutterBinaryMessenger, serviceProvider: ServiceProvider) {
    self.channel = FlutterMethodChannel(name: "plugins.pravera.com/fl_location", binaryMessenger: messenger)
    self.serviceProvider = serviceProvider
    super.init()
    self.channel.setMethodCallHandler(onMethodCall)
  }
  
  func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "checkLocationServicesStatus":
        result(LocationServicesUtils.checkLocationServicesStatus().rawValue)
      case "checkLocationPermission":
        locationPermissionResult = result
        serviceProvider.getLocationPermissionManager().checkLocationPermission(handler: self)
      case "requestLocationPermission":
        locationPermissionResult = result
        serviceProvider.getLocationPermissionManager().requestLocationPermission(handler: self)
      case "getLocation":
        let argsDict = call.arguments as? Dictionary<String, Any>
        let settings = LocationSettings(from: argsDict)
        
        locationDataResult = result
        locationDataProviderHashCode = serviceProvider
          .getLocationDataProviderManager()
          .startUpdatingLocation(handler: self, settings: settings)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
  
  func onPermissionResult(locationPermission: LocationPermission) {
    locationPermissionResult?(locationPermission.rawValue)
    locationPermissionResult = nil
  }
  
  func onPermissionError(errorCode: ErrorCodes) {
    if locationPermissionResult == nil { return }
    ErrorHandleUtils.handleMethodCallError(result: locationPermissionResult!, errorCode: errorCode)
    locationPermissionResult = nil
  }
  
  func onLocationUpdate(locationJson: String) {
    if locationDataProviderHashCode != nil {
      serviceProvider
        .getLocationDataProviderManager()
        .stopUpdatingLocation(hashCode: locationDataProviderHashCode!)
      locationDataProviderHashCode = nil
    }
    
    locationDataResult?(locationJson)
    locationDataResult = nil
  }
  
  func onLocationError(errorCode: ErrorCodes) {
    if locationDataProviderHashCode != nil {
      serviceProvider
        .getLocationDataProviderManager()
        .stopUpdatingLocation(hashCode: locationDataProviderHashCode!)
      locationDataProviderHashCode = nil
    }
    
    if locationDataResult == nil { return }
    ErrorHandleUtils.handleMethodCallError(result: locationDataResult!, errorCode: errorCode)
    locationDataResult = nil
  }
}
