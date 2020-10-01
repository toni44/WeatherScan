//
//  Observation.swift
//  WeatherScan
//
//  Created by Toni Järvinen on 28.9.2020.
//

import Foundation

struct Observation: Codable {
    let temperature: Float
    let timestamp: Double
    let locationId: Int
}

struct ObservationData {
    enum TemperatureType {
        case latest
        case min
        case max
    }
    
    let latestTemperature: Float
    let minTemperature: Float
    let maxTemperature: Float
    
    func text(for temperatureType: TemperatureType) -> String {
        var temperature: Float = 0
        switch temperatureType {
        case .latest:
            temperature = latestTemperature
        case .min:
            temperature = minTemperature
        case .max:
            temperature = maxTemperature
        }
        if temperature < MAXFLOAT {
            return String(format: NSLocalizedString("temperature_format", comment: ""), temperature)
        } else {
            return NSLocalizedString("no_data", comment: "")
        }
    }
}
