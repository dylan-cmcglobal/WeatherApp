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
    @IBOutlet private weak var celsiusButton: UIButton!
    @IBOutlet private weak var fahrenheitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addNav()
        setupUI()
    }
    
    func setupUI() {
        model.delegate = self
        searchTextField.delegate = self

        celsiusButton.setTitle("Celsius", for: .normal)
        celsiusButton.layer.cornerRadius = 12
        celsiusButton.isEnabled = false
        fahrenheitButton.setTitle("Fahrenheit", for: .normal)
        fahrenheitButton.layer.cornerRadius = 12
        fahrenheitButton.isEnabled = false

        statusImageView.image = UIImage(named: "ic_weather")
    }

    func addNav() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 32, width: view.frame.size.width, height: 44))
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        view.addSubview(navBar)

        let navItem = UINavigationItem(title: "")
        let rightItem = UIBarButtonItem(title: "Show More", style: .plain, target: self, action: #selector(onShowDetail5Days))
        rightItem.tintColor = .black
        navItem.rightBarButtonItem = rightItem

        navBar.setItems([navItem], animated: false)
    }

    @objc func onShowDetail5Days() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CityDetailViewController") as? CityDetailViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    private func updateTemperature() {
        temperatureLabel.text = "Temperature: \(model.returnTemp())"
    }
    
    private func reloadView() {
        if let weather = model.cityWeather {
            temperatureLabel.text = "Temperature: \(weather.main?.temp ?? 0)°K"
            humidityLabel.text = "Humidity: \(weather.main?.humidity ?? 0)"

            switch weather.weather?.first?.main?.lowercased() {
            case MainWeather.wind.rawValue:
                statusImageView.image = UIImage(named: "ic_windy")
            case MainWeather.clouds.rawValue:
                statusImageView.image = UIImage(named: "ic_clouds")
            case MainWeather.rain.rawValue:
                statusImageView.image = UIImage(named: "ic_rain")
            case MainWeather.snow.rawValue:
                statusImageView.image = UIImage(named: "ic_snow")
            default:
                statusImageView.image = UIImage(named: "ic_weather")
            }
        } else {
            temperatureLabel.text = "Temperature:"
            humidityLabel.text = "Humidity:"
        }
    }

    func clearData() {
        celsiusButton.isEnabled = searchTextField.text?.count ?? 0 > 2
        fahrenheitButton.isEnabled = searchTextField.text?.count ?? 0 > 2
        statusImageView.image = UIImage(named: "ic_weather")
        temperatureLabel.text = "Temperature:"
        humidityLabel.text = "Humidity:"
    }
    
    @IBAction private func onTapCelsiusButton(_ sender: UIButton) {
        if let _ = model.cityWeather {
            if model.currentTempUnit == .celsius {
                model.currentTempUnit = .kelvin
            } else {
                model.currentTempUnit = .celsius
            }
            updateTemperature()
        }
    }

    @IBAction private func onTapFahrenheitButton(_ sender: UIButton) {
        if let _ = model.cityWeather {
            if model.currentTempUnit == .fahrenheit {
                model.currentTempUnit = .kelvin
            } else {
                model.currentTempUnit = .fahrenheit
            }
            updateTemperature()
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let previousText:NSString = textField.text! as NSString
        let updatedText = previousText.replacingCharacters(in: range, with: string)
        if updatedText.count > 2 {
            fahrenheitButton.isEnabled = true
            celsiusButton.isEnabled = true
            model.getWeatherOf(params: updatedText.trimmingCharacters(in: .whitespaces))
        } else {
            clearData()
        }
        return true
    }
}

extension MainViewController: MainViewDelegate {
    func didGetData() {
        reloadView()
    }
}

