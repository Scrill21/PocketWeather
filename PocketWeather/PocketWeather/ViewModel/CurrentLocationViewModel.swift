//
//  PocketWeatherViewModel.swift
//  PocketWeather
//
//  Created by anthony byrd on 5/11/24.
//

import Foundation
import Combine
import CoreLocation

class CurrentLocationViewModel: NSObject {
    
    //MARK: - Properties
    @Published var cityName: String?
    @Published var iconName: String = ""
    @Published var temperature: Double?
    @Published var forecastDescription: String?
    @Published var isLoading: Bool = false
    @Published var networkError: Error?
    @Published var alertMessage: AlertMessage?
    
    private let locationManager = CLLocationManager()
    private let networkManager = NetworkManager.shared
    
    //MARK: - Initialization
    
    override init() {}
}

//MARK: - Methods

extension CurrentLocationViewModel {
    func checkIfLocationServiceIsEnabled() {
        isLoading = true
        DispatchQueue.global(qos: .utility).async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.delegate = self
                self?.locationManager.requestWhenInUseAuthorization()
                self?.locationManager.requestLocation()
            } else {
                self?.alertMessage = AlertMessage.locationDisabled
                self?.isLoading = false
            }
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.alertMessage = AlertMessage.restricted
            isLoading = false
        case .denied:
            self.alertMessage = AlertMessage.denied
            isLoading = false
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
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
}

//MARK: - CLLocationManagerDelegate

extension CurrentLocationViewModel: CLLocationManagerDelegate {
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            Task {
                do {
                    let pocketWeatherModel = try await networkManager.fetchWeather(latitude: latitude, longitude: longitude)
                    isLoading = false
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
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error:: \(error.localizedDescription)")
    }
}
