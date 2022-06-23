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
}
extension WeatherAPI {
    
    var path: String {
        switch self {
        case .searchByName(let params):
            return Constant.baseURL + "q=\(params)&appid=\(Constant.APIKey)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchByName:
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
}
