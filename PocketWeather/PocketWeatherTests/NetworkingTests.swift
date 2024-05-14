//
//  NetworkingTests.swift
//  PocketWeatherTests
//
//  Created by anthony byrd on 5/13/24.
//

import XCTest
@testable import PocketWeather

final class NetworkingTests: XCTestCase {
    let networkManager = MockNetworkManaging()
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func test_fetchWeatherForLocationSuccessfully() async throws {
        do {
            let pocketWeatherModel = try await networkManager.fetchWeather(latitude: 10.99, longitude: 44.34)
            
            XCTAssertNotNil(pocketWeatherModel)
            XCTAssertEqual(pocketWeatherModel?.name, "Zocca")
            XCTAssertNotEqual(pocketWeatherModel?.main.temp, 29)
        } catch {
            print(error)
        }
    }
    
    func test_fetchWeatherForCitySuccessfully() async throws {
        do {
            let pocketWeatherModel = try await networkManager.fetchWeather("London")
            
            XCTAssertNotNil(pocketWeatherModel)
            XCTAssertEqual(pocketWeatherModel?.name, "London")
            XCTAssertNotEqual(pocketWeatherModel?.weather[0].description, "sunny")
        } catch {
            print(error)
        }
    }
}
