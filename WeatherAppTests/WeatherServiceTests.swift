//
//  WeatherServiceTests.swift
//  WeatherAppTests
//
//  Created by Manpreet Kaur on 8/16/24.
//

import XCTest
import Combine
@testable import WeatherApp

class WeatherServiceTests: XCTestCase {
    
    var weatherService: WeatherService!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        weatherService = WeatherService(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchWeatherSuccess() {
        let jsonResponse = """
        {
            "main": {
                "temp": 95.0
            },
            "weather": [
                {
                    "icon": "omg"
                }
            ],
            "name": "Plano"
        }
        """.data(using: .utf8)!
        
        mockNetworkManager.response = .success(jsonResponse)
        
        let expectation = self.expectation(description: "Fetch Weather")
        
        weatherService.fetchWeather(for: "Plano")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error.localizedDescription)")
                }
            }, receiveValue: { weatherResponse in
                XCTAssertEqual(weatherResponse.main.temp, 95.0)
                XCTAssertEqual(weatherResponse.weather.first?.icon, "omg")
                XCTAssertEqual(weatherResponse.name, "Plano")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchWeatherFailure() {
        mockNetworkManager.response = .failure(NSError(domain: "", code: -1, userInfo: nil))
        
        let expectation = self.expectation(description: "Fetch Weather Failure")
        
        weatherService.fetchWeather(for: "Plano")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual((error as NSError).code, -1)
                } else {
                    XCTFail("Expected failure but got success")
                }
                expectation.fulfill()
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
