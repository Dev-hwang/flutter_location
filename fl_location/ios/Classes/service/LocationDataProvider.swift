//
//  LocationDataProvider.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/28.
//

import CoreLocation
import Foundation

class LocationDataProvider: NSObject, CLLocationManagerDelegate {
  private let locationManager: CLLocationManager
  
  private var handler: LocationDataHandler? = nil
  private var settings: LocationSettings? = nil
  
  override init() {
    self.locationManager = CLLocationManager()
    super.init()
    self.locationManager.delegate = self
  }
  
  func startUpdatingLocation(handler: LocationDataHandler, settings: LocationSettings) {
    if self.handler != nil { stopUpdatingLocation() }
    
    self.handler = handler
    self.settings = settings
    
    self.locationManager.desiredAccuracy = settings.accuracy.toCLLocationAccuracy()
    self.locationManager.distanceFilter = settings.distanceFilter ?? kCLDistanceFilterNone
    self.locationManager.allowsBackgroundLocationUpdates = containsBackgroundLocationMode()
    
    self.locationManager.startUpdatingLocation()
  }
  
  func stopUpdatingLocation() {
    self.locationManager.stopUpdatingLocation()
    
    self.handler = nil
    self.settings = nil
  }
  
  func containsBackgroundLocationMode() -> Bool {
    let backgroundModes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? NSArray
    return backgroundModes?.contains("location") ?? false
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if handler == nil { return }

    if let location = locations.last {
      let locationData = LocationData(from: location)
      handler?.onLocationUpdate(locationData: locationData)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    if handler == nil { return }
    
    NSLog("LocationManager error: \(error)")
    handler?.onLocationError(errorCode: ErrorCodes.LOCATION_UPDATE_FAILED)
  }
}
