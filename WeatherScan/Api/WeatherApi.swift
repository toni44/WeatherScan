//
//  WeatherApi.swift
//  WeatherScan
//
//  Created by Toni Järvinen on 28.9.2020.
//

import Foundation

protocol WeatherApi {
    func fetchObservationLocations(success: @escaping ([Location]) -> Void, error: ((Error) -> Void)?)
    func fetchAllObservations(success: @escaping ([Observation]) -> Void, error: ((Error) -> Void)?)
    func fetchObservations(for location: Location, success: @escaping ([Observation]) -> Void, error: ((Error) -> Void)?)
    func postObservation(_ observation: Observation, success: @escaping () -> Void, error: ((Error) -> Void)?)
}
