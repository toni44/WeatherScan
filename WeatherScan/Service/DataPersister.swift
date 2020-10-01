//
//  DataPersister.swift
//  WeatherScan
//
//  Created by Toni Järvinen on 1.10.2020.
//

import Foundation

let locationsFilename = "locations.json"
let observationsFilename = "observations.json"

class DataPersister {
    func persist<T: Codable>(data: [T], into jsonFileName: String) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            let jsonString = String(data: jsonData, encoding: .utf8)!
                    
            if let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent(jsonFileName)
                do {
                    try jsonString.write(to: fileURL, atomically: false, encoding: .utf8)
                } catch {
                    print("Error persisting local data")
                }
            }
        } catch {
            print("Error persisting local data")
        }
    }
    
    func read<T: Codable>(from jsonFileName: String) -> [T]? {
        if let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(jsonFileName)
            do {
                let jsonString = try String(contentsOf: fileURL, encoding: .utf8)
                let jsonData = jsonString.data(using: .utf8)!
                let array = try JSONDecoder().decode([T].self, from: jsonData)
                return array
            } catch {
                print("Error reading local data")
                return nil
            }
        }
        return nil
    }
}
