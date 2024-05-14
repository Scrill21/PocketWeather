//
//  NetworkManager.swift
//  PocketWeather
//
//  Created by anthony byrd on 5/11/24.
//

import Foundation

protocol NetworkManagingProtocol {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> PocketWeatherDataModel?
    func fetchWeather(_ cityName: String) async throws -> PocketWeatherDataModel?
}

class NetworkManager: NetworkManagingProtocol {
    
    //MARK: - Singleton
    
    static let shared = NetworkManager()
    
    //MARK: - Properties
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    private let apiKey = "9538ff15c4bc60c08dad03be6066dbb4"
    
    
    //MARK: - Initialization
    
    init() {}
}

//MARK: - Methods

extension NetworkManager {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> PocketWeatherDataModel? {
        let endpoint = baseURL + "lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponseStatus
        }
        
        let decoder = JSONDecoder()
        let pocketWeatherDataModel = try decoder.decode(PocketWeatherDataModel.self, from: data)
        
        return pocketWeatherDataModel
    }
    
    func fetchWeather(_ cityName: String) async throws -> PocketWeatherDataModel? {
        let endpoint = baseURL + "q=\(cityName)&appid=\(apiKey)&units=imperial"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponseStatus
        }
        
        let decoder = JSONDecoder()
        let pocketWeatherDataModel = try decoder.decode(PocketWeatherDataModel.self, from: data)
        
        return pocketWeatherDataModel
    }
}
