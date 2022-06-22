//
//  MainViewModel.swift
//  WeatherMap
//
//  Created by Dylan Nguyen on 22/06/2022.
//

import Foundation

protocol MainViewDelegate: NSObjectProtocol {
    func didGetData()
}

class MainViewModel {
    var weatherRDS: WeatherRDS
    var cityWeather: WeatherBaseResponse?
    var isCelsius: Bool = false
    weak var delegate: MainViewDelegate?
    
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
    
    func updateUnit() {
        isCelsius = !isCelsius
    }
    
    func changeTempUnit() -> String {
        if let cityWeather = cityWeather {
            if !isCelsius {
                return String(format: "%.2f", ((cityWeather.main?.temp ?? 0) - 32) / 1.8)
            } else {
                return String(format: "%.2f", cityWeather.main?.temp ?? 0)
            }
        }
        return ""
    }
}
