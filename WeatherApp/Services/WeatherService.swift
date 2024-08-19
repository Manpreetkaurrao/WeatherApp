//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Manpreet Kaur on 8/16/24.
//

import Alamofire
import Combine

class WeatherService {
    private let networkManager: NetworkManaging
    private let apiKey = "18dbd03ca03fb5cfcbe61478f16ac7b2"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    init(networkManager: NetworkManaging = NetworkService()) {
        self.networkManager = networkManager
    }
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        let parameters: [String: String] = [
            "q": city,
            "appid": apiKey,
            "units": "imperial" // Fahrenheit
        ]
        
        return networkManager.request(baseURL, parameters: parameters)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

