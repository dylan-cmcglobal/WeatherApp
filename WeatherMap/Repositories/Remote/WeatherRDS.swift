//
//  WeatherRDS.swift
//  WeatherMap
//
//  Created by Dylan Nguyen on 22/06/2022.
//

import Foundation
import Alamofire
import Combine

enum WeatherAPI {
    case searchByName(params: String)
    case getCurrentWeather(lat: String, lon: String)
    case getWeatherOf5Days(lat: String, lon: String)
}
extension WeatherAPI {
    
    var path: String {
        switch self {
        case .searchByName(let params):
            return Constant.baseURL + "q=\(params)&appid=\(Constant.APIKey)"
        case .getCurrentWeather(let lat, let lon):
            return Constant.baseURL + "lat=\(lat)&lon=\(lon)&appid=\(Constant.APIKey)"
        case .getWeatherOf5Days(let lat, let lon):
            return Constant.forecastURL + "lat=\(lat)&lon=\(lon)&appid=\(Constant.APIKey)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchByName, .getCurrentWeather, .getWeatherOf5Days:
            return .get
        }
    }
    
    func body() throws -> Data? {
        switch self {
        default :
            return nil
        }
    }
}

class WeatherRDS {
    func getWeather(params: String, completion: @escaping (_ result: WeatherBaseResponse?, _ error: WeatherError?) -> Void) {
        AF.request(WeatherAPI.searchByName(params: params.replacingOccurrences(of: " ", with: "%20")).path).validate().responseData { response in
            switch response.result {
            case .success(_):
                guard let data = response.data else {
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(WeatherBaseResponse.self, from: data)
                    completion(result, nil)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(_):
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                do {
                    let error = try decoder.decode(WeatherError.self, from: data)
                    completion(nil, error)
                } catch {
                    print(error.localizedDescription)
                }
            }
            debugPrint("Response: \(response)")
        }
    }
    
    func getCurrentWeather(lat: String, lon: String, completion: @escaping (_ result: WeatherBaseResponse?, _ error: WeatherError?) -> Void) {
        AF.request(WeatherAPI.getCurrentWeather(lat: lat, lon: lon).path).validate().responseData { response in
            switch response.result {
            case .success(_):
                guard let data = response.data else {
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(WeatherBaseResponse.self, from: data)
                    completion(result, nil)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(_):
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                do {
                    let error = try decoder.decode(WeatherError.self, from: data)
                    completion(nil, error)
                } catch {
                    print(error.localizedDescription)
                }
            }
            debugPrint("Response: \(response)")
        }
    }
    
    func getWeatherOf5Days(lat: String, lon: String, completion: @escaping (_ result: WeatherOfCity?, _ error: WeatherError?) -> Void) {
        AF.request(WeatherAPI.getWeatherOf5Days(lat: lat, lon: lon).path).validate().responseData { response in
            switch response.result {
            case .success(_):
                guard let data = response.data else {
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(WeatherOfCity.self, from: data)
                    completion(result, nil)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(_):
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                do {
                    let error = try decoder.decode(WeatherError.self, from: data)
                    completion(nil, error)
                } catch {
                    print(error.localizedDescription)
                }
            }
            debugPrint("Response: \(response)")
        }
    }
}
