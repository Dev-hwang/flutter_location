//
//  LocationData.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/29.
//

import CoreLocation
import Foundation

struct LocationData {
  let latitude: Double
  let longitude: Double
  let accuracy: Double
  let altitude: Double
  let heading: Double
  let speed: Double
  let speedAccuracy: Double
  let millisecondsSinceEpoch: Double
  let isMock: Bool
  
  init(from location: CLLocation) {
    self.latitude = location.coordinate.latitude
    self.longitude = location.coordinate.longitude
    self.accuracy = location.horizontalAccuracy
    self.altitude = location.altitude
    self.heading = location.course
    self.speed = location.speed
    
    if #available(iOS 10.0, *) {
      self.speedAccuracy = location.speedAccuracy
    } else {
      self.speedAccuracy = 0.0
    }
    
    self.millisecondsSinceEpoch = location.timestamp.timeIntervalSince1970 * 1000.0
    self.isMock = false
  }
  
  func toJson() -> Dictionary<String, Any?> {
    var json = Dictionary<String, Any?>()
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
