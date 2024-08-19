//
//  Mocks.swift
//  WeatherAppTests
//
//  Created by Manpreet Kaur on 8/16/24.
//

import Foundation
import Combine
@testable import WeatherApp

class MockNetworkManager: NetworkManaging {
    
    var response: Result<Data, Error>?
    
    func request(_ url: String, parameters: [String: String]) -> AnyPublisher<Data, Error> {
        guard let response = response else {
            fatalError("Mock response not set")
        }
        
        switch response {
        case .success(let data):
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}


class MockWeatherService: WeatherService {
    var result: Result<WeatherResponse, Error>!
    
    override func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        guard let result = result else {
            fatalError("Mock result not set")
        }
        
        switch result {
        case .success(let response):
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
