//
//  WeatherValidator.swift
//  WeatherScan
//
//  Created by Toni Järvinen on 1.10.2020.
//

import Foundation

class WeatherValidator {
    private let absoluteZero:Float = -273.15
    private let maxTemperatureAllowed:Float = 100.0
    func isValid(observation: Float) -> Bool {
        return observation >= absoluteZero && observation <= maxTemperatureAllowed
    }
}
