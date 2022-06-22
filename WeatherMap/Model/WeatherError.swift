//
//  WeatherError.swift
//  WeatherMap
//
//  Created by Dylan Nguyen on 22/06/2022.
//

import Foundation
struct WeatherError: Codable, Error {
    let cod, message: String?
}
