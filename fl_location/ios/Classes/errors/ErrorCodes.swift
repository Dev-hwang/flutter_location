//
//  ErrorCodes.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/27.
//

import Foundation

enum ErrorCodes: String {
  case LOCATION_USAGE_DESCRIPTION_NOT_FOUND
  case LOCATION_UPDATE_FAILED
  case LOCATION_DATA_ENCODING_FAILED
  
  func message() -> String {
    switch self {
      case .LOCATION_USAGE_DESCRIPTION_NOT_FOUND:
        return "The location usage description key could not be found in the Info.plist file. You are required to include the NSLocationWhenInUseUsageDescription and NSLocationAlwaysAndWhenInUsageDescription keys in your app's Info.plist file. (If your app supports iOS 10 and earlier, the NSLocationAlwaysUsageDescription key is also required.) If those keys are not present, authorization requests fail immediately."
      case .LOCATION_UPDATE_FAILED:
        return "Unable to get location due to LocationManager error."
      case .LOCATION_DATA_ENCODING_FAILED:
        return "Failed to encode location data in JSON format."
    }
  }
}
