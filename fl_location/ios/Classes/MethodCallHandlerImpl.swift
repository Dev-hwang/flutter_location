//
//  MethodCallHandlerImpl.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/26.
//

import Flutter
import Foundation

class MethodCallHandlerImpl: NSObject {
  private let channel: FlutterMethodChannel
  private let serviceProvider: ServiceProvider
  
  init(messenger: FlutterBinaryMessenger, serviceProvider: ServiceProvider) {
    self.channel = FlutterMethodChannel(name: "fl_location/methods", binaryMessenger: messenger)
    self.serviceProvider = serviceProvider
    super.init()
    self.channel.setMethodCallHandler(onMethodCall)
  }
  
  func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "isLocationServicesEnabled":
        let locationServicesStatus = LocationServicesUtils.checkLocationServicesStatus()
        result(locationServicesStatus == LocationServicesStatus.ENABLED)
      case "checkLocationPermission":
        let handler = LocationPermissionHandlerImpl(result)
        serviceProvider.getLocationPermissionManager().checkLocationPermission(handler: handler)
      case "requestLocationPermission":
        let handler = LocationPermissionHandlerImpl(result)
        serviceProvider.getLocationPermissionManager().requestLocationPermission(handler: handler)
      case "getLocation":
        let argsDict = call.arguments as? Dictionary<String, Any>
        let settings = LocationSettings(from: argsDict)
        
        let handler = LocationDataHandlerImpl(result)
        serviceProvider
          .getLocationDataProviderManager()
          .getLocation(handler: handler, settings: settings)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
