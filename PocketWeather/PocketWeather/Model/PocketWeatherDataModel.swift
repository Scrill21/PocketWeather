//
//  PocketWeatherDataModel.swift
//  PocketWeather
//
//  Created by anthony byrd on 5/11/24.
//

import UIKit

struct PocketWeatherDataModel: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
