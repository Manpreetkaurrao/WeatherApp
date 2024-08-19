//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Manpreet Kaur on 8/16/24.
//

import Foundation
import XCTest
import Combine
@testable import WeatherApp

import XCTest
import Combine
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchWeatherSuccess() {
        let weatherResponse = WeatherResponse(
            main: Main(temp: 95.0),
            weather: [Weather(icon: "omg")],
            name: "Plano"
        )
        
        mockWeatherService.result = .success(weatherResponse)
        
        let expectation = self.expectation(description: "Weather fetched successfully")
        
        viewModel.$weather
            .dropFirst()
            .sink { fetchedWeather in
                XCTAssertEqual(fetchedWeather?.main.temp, 95.0)
                XCTAssertEqual(fetchedWeather?.weather.first?.icon, "omg")
                XCTAssertEqual(fetchedWeather?.name, "Plano")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchWeather(for: "Plano")
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchWeatherFailure() {
        mockWeatherService.result = .failure(NSError(domain: "", code: -1, userInfo: nil))
        
        let expectation = self.expectation(description: "Weather fetch failed")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "The operation couldn’t be completed. ( error -1.)")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchWeather(for: "Plano")
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
