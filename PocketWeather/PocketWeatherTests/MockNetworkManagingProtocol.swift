//
//  MockNetworkManagingProtocol.swift
//  PocketWeatherTests
//
//  Created by anthony byrd on 5/13/24.
//

import Foundation
@testable import PocketWeather

final class MockNetworkManaging: NetworkManagingProtocol, Mockable {
        
    func fetchWeather(latitude: Double, longitude: Double) async throws -> PocketWeather.PocketWeatherDataModel? {
        return loadJSON(filename: "CurrentLocationResponse", type: PocketWeatherDataModel.self) 
    }
    
    func fetchWeather(_ cityName: String) async throws -> PocketWeather.PocketWeatherDataModel? {
        return loadJSON(filename: "CityNameResponse", type: PocketWeatherDataModel.self)
    }
}
