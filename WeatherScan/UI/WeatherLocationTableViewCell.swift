//
//  WeatherLocationTableViewCell.swift
//  WeatherScan
//
//  Created by Toni Järvinen on 30.9.2020.
//

import UIKit

class WeatherLocationTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    
    func populate(with location: Location, observationData: ObservationData? = nil) {
        nameLabel.text = location.name
        if let obsData = observationData {
            currentTempLabel.text = obsData.text(for: .latest)
            maxTemperatureLabel.text = "Max \(obsData.text(for: .max))"
            minTemperatureLabel.text = "Min \(obsData.text(for: .min))"
        } else {
            currentTempLabel.text = NSLocalizedString("no_data", comment: "")
            maxTemperatureLabel.text = ""
            minTemperatureLabel.text = ""
        }
    }
    
    func showOnly(mainText: String) {
        nameLabel.text = mainText
        currentTempLabel.text = ""
        maxTemperatureLabel.text = ""
        minTemperatureLabel.text = ""
    }
}
