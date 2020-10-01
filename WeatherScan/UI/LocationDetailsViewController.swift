//
//  LocationDetailsViewController.swift
//  WeatherScan
//
//  Created by Toni Järvinen on 1.10.2020.
//

import UIKit

class LocationDetailsViewController: UIViewController, WeatherServiceDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var latestTemperatureTitleLabel: UILabel!
    @IBOutlet weak var latestTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureTitleLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureTitleLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var addObservationTextField: UITextField!
    @IBOutlet weak var observationTextFieldInstructionLabel: UILabel!
    
    var location: Location?
    weak var weatherService: WeatherService?
    private let validator = WeatherValidator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        latestTemperatureTitleLabel.text = NSLocalizedString("latest_temperature", comment: "")
        maxTemperatureTitleLabel.text = NSLocalizedString("24h_max_temperature", comment: "")
        minTemperatureTitleLabel.text = NSLocalizedString("24h_min_temperature", comment: "")
        update(addObservationTextField, borderColor: UIColor.lightGray.cgColor)
        weatherService?.delegate = self

        let toolbar = UIToolbar(frame:CGRect(x:0, y:0, width: 100, height: 100))
        toolbar.barStyle = .default
        toolbar.setItems([
            UIBarButtonItem(title: NSLocalizedString("cancel", comment: ""), style: .plain, target: self, action: #selector(onAddObservationCancelled)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title:  NSLocalizedString("send", comment: ""), style: .done, target: self, action: #selector(onAddObservationPressed))
        ], animated: false)
        toolbar.sizeToFit()

        addObservationTextField.inputAccessoryView = toolbar
        
        updateData()
    }
    
    private func updateData() {
        if let location = location {
            nameLabel.text = location.name
            let observationData = weatherService?.getObservationData(for: location)
            latestTemperatureLabel.text = observationData?.text(for: .latest)
            maxTemperatureLabel.text = observationData?.text(for: .max)
            minTemperatureLabel.text = observationData?.text(for: .min)
        }
    }
    
    @objc func onAddObservationCancelled() {
        addObservationTextField.resignFirstResponder()
    }
    
    @objc func onAddObservationPressed() {
        if let location = location,
           let observationInput = addObservationTextField.text,
           let floatValue = Float(observationInput) {
            if validator.isValid(observation: floatValue) {
                weatherService?.add(temperatureObservation: floatValue, for: location)
                
                addObservationTextField.resignFirstResponder()
                addObservationTextField.text = ""
                observationTextFieldInstructionLabel.text = ""
                
                update(addObservationTextField, borderColor: UIColor.lightGray.cgColor)
                update(observationTextFieldInstructionLabel, textColor: UIColor.systemTeal)
                observationTextFieldInstructionLabel.text = NSLocalizedString("temperature_submitted", comment: "")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
                    self?.observationTextFieldInstructionLabel.text = ""
                })
            } else {
                showInvalidObservationMessage()
            }
        } else {
            showInvalidObservationMessage()
        }
    }
    
    private func showInvalidObservationMessage() {
        update(observationTextFieldInstructionLabel, textColor: UIColor.red)
        observationTextFieldInstructionLabel.text = NSLocalizedString("invalid_temperature", comment: "")
        update(addObservationTextField, borderColor: UIColor.systemRed.cgColor)
    }
    
    private func update(_ view: UIView, borderColor: CGColor) {
        view.layer.borderColor = borderColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 4.0
    }
    
    private func update(_ label: UILabel, textColor: UIColor) {
        label.textColor = textColor
    }
    
    func weatherService(_ weatherService: WeatherService, didRefresh observations: [Observation]) {
        updateData()
    }
    
    func weatherService(_ weatherService: WeatherService, didRefresh locations: [Location]) {
    }
}
