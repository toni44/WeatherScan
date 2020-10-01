//
//  WeatherValidator.swift
//  WeatherScan
//
//  Created by Toni Järvinen on 1.10.2020.
//

import Foundation
import CoreLocation

class WeatherValidator {
    private let absoluteZero:Float = -273.15
    private let maxTemperatureAllowed:Float = 100.0
    private let maxDistanceFromLocation:Double = 10000
    
    func isValid(observation: Float) -> Bool {
        return observation >= absoluteZero && observation <= maxTemperatureAllowed
    }
    func isValid(userLocation: CLLocation, location: Location) -> Bool {
        let locationCoordinate = CLLocation(latitude: Double(location.latitude), longitude: Double(location.longitude))
        return userLocation.distance(from: locationCoordinate) <= maxDistanceFromLocation
    }
}
