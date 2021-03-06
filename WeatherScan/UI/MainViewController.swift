//
//  ViewController.swift
//  WeatherScan
//
//  Created by Toni Järvinen on 28.9.2020.
//

import UIKit
import CoreLocation

class MainViewController: UITableViewController, WeatherServiceDelegate, CLLocationManagerDelegate {
    var weatherService: WeatherService?
    var locationManager: CLLocationManager!

    private var locations: [Location] = []
    private var currentLocation: CLLocation?
    
    private let weatherCellIdentifier = "Weather Location Cell"
    private let locationDetailsVCIdentifier = "LocationDetailsVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        weatherService?.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        max(locations.count, 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: weatherCellIdentifier) as? WeatherLocationTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if locations.isEmpty {
            cell.showOnly(mainText: NSLocalizedString("fetching_data", comment: ""))
        } else {
            let location = locations[indexPath.row]
            if let weatherService = weatherService {
                cell.populate(with: location, observationData: weatherService.getObservationData(for: location))
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: locationDetailsVCIdentifier) as? LocationDetailsViewController {
            vc.location = locations[indexPath.row]
            vc.weatherService = weatherService
            vc.currentLocation = currentLocation
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func weatherService(_ weatherService: WeatherService, didRefresh locations: [Location]) {
        self.locations = locations
        tableView.reloadData()
    }
    
    func weatherService(_ weatherService: WeatherService, didRefresh observations: [Observation]) {
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}

