//
//  LocationDataHandlerImplForManager.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/08/09.
//

import Foundation

class LocationDataHandlerImplForManager: NSObject, LocationDataHandler {
  private let handler: LocationDataHandler
  private let onComplete: () -> Void
  
  init(_ handler: LocationDataHandler, onComplete: @escaping () -> Void) {
    self.handler = handler
    self.onComplete = onComplete
  }
  
  func onLocationUpdate(locationData: LocationData) {
    onComplete()
    handler.onLocationUpdate(locationData: locationData)
  }
  
  func onLocationError(errorCode: ErrorCodes) {
    onComplete()
    handler.onLocationError(errorCode: errorCode)
  }
}
