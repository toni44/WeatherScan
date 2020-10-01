//
//  WeatherRepository.swift
//  WeatherScan
//
//  Created by Toni Järvinen on 1.10.2020.
//

import Foundation

protocol WeatherServiceDelegate: class {
    func weatherService(_ weatherService: WeatherService, didRefresh locations: [Location])
    func weatherService(_ weatherService: WeatherService, didRefresh observations: [Observation])
}

class WeatherService {
    private let api: WeatherApi
    private var locations: [Location]
    private var observations: [Observation]
    private let persister = DataPersister()
    
    weak var delegate: WeatherServiceDelegate? {
        didSet {
            delegate?.weatherService(self, didRefresh: locations)
            delegate?.weatherService(self, didRefresh: observations)
        }
    }
    
    init(api: WeatherApi) {
        self.api = api
        locations = persister.read(from: locationsFilename) ?? []
        observations = persister.read(from: observationsFilename) ?? []
        refreshData()
    }
    
    func refreshData() {
        refreshLocations()
        refreshObservations()
    }
    
    func refreshLocations() {
        api.fetchObservationLocations (success: { [weak self] locations in
            self?.locations = locations
            if let strongSelf = self {
                strongSelf.delegate?.weatherService(strongSelf, didRefresh: locations)
            }
            self?.persister.persist(data: locations, into: locationsFilename)
        }, error: nil)
    }
    
    func refreshObservations() {
        api.fetchAllObservations (success: { [weak self] observations in
            self?.observations = observations
            if let strongSelf = self {
                strongSelf.delegate?.weatherService(strongSelf, didRefresh: observations)
            }
            self?.persister.persist(data: observations, into: observationsFilename)
        }, error: nil)
    }
    
    func getLatestTemperature(for location: Location) -> Float {
        let locationObservations = observations.filter { $0.locationId == location.id }
        return locationObservations.max(by: { $0.timestamp < $1.timestamp })?.temperature ?? MAXFLOAT
    }
    
    func getDayMaxTemperature(for location: Location) -> Float {
        let locationObservations = observations.filter { $0.locationId == location.id }
        let dayBeginTimestamp = Date().addingTimeInterval(-24*60*60).timeIntervalSince1970
        let dayObservations = locationObservations.filter { $0.timestamp >= dayBeginTimestamp }
        return dayObservations.max(by: { $0.temperature < $1.temperature })?.temperature ?? MAXFLOAT
    }
    
    func getDayMinTemperature(for location: Location) -> Float {
        let locationObservations = observations.filter { $0.locationId == location.id }
        let dayBeginTimestamp = Date().addingTimeInterval(-24*60*60).timeIntervalSince1970
        let dayObservations = locationObservations.filter { $0.timestamp >= dayBeginTimestamp }
        return dayObservations.min(by: { $0.temperature < $1.temperature })?.temperature ?? MAXFLOAT
    }
    
    func getObservationData(for location: Location) -> ObservationData {
        let latestTemp = getLatestTemperature(for: location)
        let maxTemp = getDayMaxTemperature(for: location)
        let minTemp = getDayMinTemperature(for: location)
        return ObservationData(latestTemperature: latestTemp, minTemperature: minTemp, maxTemperature: maxTemp)
    }
    
    func add(temperatureObservation: Float, for location: Location) {
        let observation = Observation(temperature: temperatureObservation, timestamp: Date().timeIntervalSince1970, locationId: location.id)
        api.postObservation(observation, success: { [weak self] in
            self?.refreshObservations()
        }, error: nil)
    }
}
