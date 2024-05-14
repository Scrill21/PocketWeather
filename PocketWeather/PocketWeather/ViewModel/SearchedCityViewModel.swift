//
//  CityWeatherViewModel.swift
//  PocketWeather
//
//  Created by anthony byrd on 5/12/24.
//

import Foundation
import Combine

class SearchedCityViewModel: NSObject {
    
    //MARK: - Properties
    
    @Published var cityName: String?
    @Published var iconName: String = ""
    @Published var temperature: Double?
    @Published var forecastDescription: String?
    @Published var isLoading: Bool = false
    @Published var networkError: Error?
    
    private let networkManager = NetworkManager.shared
    
    //MARK: - Initialization
    
    override init() {}
}

//MARK: - Methods

extension SearchedCityViewModel {
    
    func createIconURL(from iconName: String) -> URL? {
        let urlString = "https://openweathermap.org/img/wn/\(iconName)@2x.png"

        return URL(string: urlString)
    }
    
    func measurementConversion(index: Int) {
        switch index {
        case 0:
            temperature = ((temperature ?? 0) * 9 / 5) + 32
        default:
            temperature = ((temperature ?? 0) - 32) * (5 / 9)
        }
    }
    
    func fetchWeather(cityName: String) {
        self.isLoading = true
        Task {
            do {
                let pocketWeatherModel = try await networkManager.fetchWeather(cityName)
                self.isLoading = false
                self.cityName = pocketWeatherModel?.name
                self.iconName = pocketWeatherModel?.weather[0].icon ?? ""
                self.temperature = pocketWeatherModel?.main.temp
                self.forecastDescription = pocketWeatherModel?.weather[0].description
            } catch {
                self.networkError = error
                self.isLoading = false
            }
        }
    }
}

