//
//  ViewController.swift
//  WeatherMap
//
//  Created by Dylan Nguyen on 22/06/2022.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    let model = MainViewModel()

    @IBOutlet private weak var statusImageView: UIImageView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var unitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        model.delegate = self
        searchTextField.delegate = self
        unitButton.setTitle("Celsius", for: .normal)
        unitButton.layer.cornerRadius = 12
    }
    
    func updateTemperature() {
        unitButton.setTitle(model.isCelsius ? "Celsius" : "Fahrenheit", for: .normal)
        temperatureLabel.text = "Temperature: \(model.changeTempUnit())"
    }
    
    func reloadView() {
        if let weather = model.cityWeather {
            temperatureLabel.text = "Temperature: \(weather.main?.temp ?? 0)"
            humidityLabel.text = "Humidity: \(weather.main?.humidity ?? 0)"
        } else {
            temperatureLabel.text = "Temperature:"
            humidityLabel.text = "Humidity:"
        }
    }
    
    @IBAction private func onTapChangeUnitButton(_ sender: UIButton) {
        if let _ = model.cityWeather {
            model.updateUnit()
            updateTemperature()
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let previousText:NSString = textField.text! as NSString
        let updatedText = previousText.replacingCharacters(in: range, with: string)
        if updatedText.count > 2 {
            model.getWeatherOf(params: updatedText.trimmingCharacters(in: .whitespaces))
        }
        return true
    }
}

extension MainViewController: MainViewDelegate {
    func didGetData() {
        reloadView()
    }
}

