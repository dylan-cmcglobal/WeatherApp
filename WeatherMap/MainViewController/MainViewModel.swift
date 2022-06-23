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
    var currentWeather: WeatherBaseResponse?
    var listWeather: [List]?
    
    init() {
        weatherRDS = WeatherRDS()
    }
    
    func returnTemp() -> String {
        if let cityWeather = cityWeather {
            switch currentTempUnit {
            case .celsius:
                let temp = cityWeather.main?.temp ?? 0
                return "\(String(format: "%.1f", temp - 273.15))°C"
            case .fahrenheit:
                let temp = cityWeather.main?.temp ?? 0
                return "\(String(format: "%.1f", 1.8 * (temp - 273) + 32))°F"
            case .kelvin:
                return "\(String(format: "%.1f", cityWeather.main?.temp ?? 0))°K"
            }
        }
        return ""
    }
    
    func getWeatherOf(params: String) {
        weatherRDS.getWeather(params: params, completion: { [weak self ] result, error in
            guard let self = self else {
                return
            }
            if error == nil {
                self.cityWeather = result
                self.delegate?.didGetData()
                
                self.getCurrentWeather(lat: "\(result?.coord?.lat ?? 0)", lon: "\(result?.coord?.lon ?? 0)")
                self.getWeatherOf5Days(lat: "\(result?.coord?.lat ?? 0)", lon: "\(result?.coord?.lon ?? 0)")
            } else {
                print(error?.message ?? "")
            }
        })
    }
    
    func getCurrentWeather(lat: String, lon: String) {
        weatherRDS.getCurrentWeather(lat: lat, lon: lon, completion: { [weak self ] result, error in
            guard let self = self else {
                return
            }
            if error == nil {
                self.currentWeather = result
            } else {
                print(error?.message ?? "")
            }
        })
    }
    
    func getWeatherOf5Days(lat: String, lon: String) {
        weatherRDS.getWeatherOf5Days(lat: lat, lon: lon, completion: { [weak self ] result, error in
            guard let self = self else {
                return
            }
            if error == nil {
                self.listWeather = result?.list
            } else {
                print(error?.message ?? "")
            }
        })
    }
    
    
}
