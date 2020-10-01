//
//  MockApi.swift
//  WeatherScan
//
//  Created by Toni Järvinen on 28.9.2020.
//

import Foundation

class MockApi: WeatherApi {
    let locations = [
        Location(id: 1, name: "Tokyo", longitude: 139.7328635, latitude: 35.6584421),
        Location(id: 2, name: "Helsinki", longitude: 24.9490830, latitude: 60.1697530),
        Location(id: 3, name: "New York", longitude: -73.9938438, latitude: 40.7406905),
        Location(id: 4, name: "Amsterdam", longitude: 4.9040238, latitude: 52.3650691),
        Location(id: 5, name: "Dubai", longitude: 55.1562243, latitude: 25.092535)
    ]

    var observations = [
        Observation(temperature: 21.1, timestamp: Date().timeIntervalSince1970, locationId: 1),
        Observation(temperature: 19.4, timestamp: Date().timeIntervalSince1970 - 20000, locationId: 1),
        Observation(temperature: 18.9, timestamp: Date().timeIntervalSince1970 - 100000, locationId: 1),
        Observation(temperature: 14.2, timestamp: Date().timeIntervalSince1970 - 50000, locationId: 2),
        Observation(temperature: 12.4, timestamp: Date().timeIntervalSince1970 - 20000, locationId: 2),
        Observation(temperature: 11.1, timestamp: Date().timeIntervalSince1970 - 100000, locationId: 2),
        Observation(temperature: 21.4, timestamp: Date().timeIntervalSince1970, locationId: 3)
    ]
    
    init() {
        observations = DataPersister().read(from: observationsFilename) ?? observations
    }
    
    func fetchObservationLocations(success: @escaping ([Location]) -> Void, error: ((Error) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            if let strongSelf = self {
                success(strongSelf.locations)
            }
        })
    }
    
    func fetchAllObservations(success: @escaping ([Observation]) -> Void, error: ((Error) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            if let strongSelf = self {
                success(strongSelf.observations)
            }
        })
    }
    
    func fetchObservations(for location: Location, success: @escaping ([Observation]) -> Void, error: ((Error) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            if let strongSelf = self {
                success(strongSelf.observations.filter { $0.locationId == location.id } )
            }
        }
    }
    
    func postObservation(_ observation: Observation, success: @escaping () -> Void, error: ((Error) -> Void)?) {
        observations.append(observation)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            success()
        }
    }
}
