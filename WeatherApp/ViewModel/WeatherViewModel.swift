//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Manpreet Kaur on 8/16/24.
//

import Combine
import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var city: String = ""
    @Published var errorMessage: String?
    
    private var weatherService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    
    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
    }

    func fetchWeather(for city: String) {
        weatherService.fetchWeather(for: city)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { weatherResponse in
                self.weather = weatherResponse
            })
            .store(in: &cancellables)
    }
}
