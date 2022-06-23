//
//  MainViewModel.swift
//  WeatherMap
//
//  Created by Dylan Nguyen on 22/06/2022.
//

import Foundation

enum MainWeather: String {
    case clear
    case clouds
    case rain
    case snow
    case wind
}

enum TempUnit: String {
    case celsius
    case fahrenheit
    case kelvin
}

protocol MainViewDelegate: NSObjectProtocol {
    func didGetData()
}

class MainViewModel {
    var weatherRDS: WeatherRDS
    var cityWeather: WeatherBaseResponse?
    weak var delegate: MainViewDelegate?
    var currentTempUnit: TempUnit = .kelvin
    
    init() {
        weatherRDS = WeatherRDS()
    }
    
    func getWeatherOf(params: String) {
        weatherRDS.getWeather(params: params, completion: { [weak self ] result, error in
            guard let self = self else {
                return
            }
            if error == nil {
                self.cityWeather = result
                self.delegate?.didGetData()
            } else {
                print(error?.message ?? "")
            }
        })
    }
    
    func returnTemp() -> String {
        if let cityWeather = cityWeather {
            switch currentTempUnit {
            case .celsius:
                let temp = cityWeather.main?.temp ?? 0
                return "\(String(format: "%.2f", temp - 273.15))°C"
            case .fahrenheit:
                let temp = cityWeather.main?.temp ?? 0
                return "\(String(format: "%.2f", 1.8 * (temp - 273) + 32))°F"
            case .kelvin:
                return "\(String(format: "%.2f", cityWeather.main?.temp ?? 0))°K"
            }
        }
        return ""
    }
}
