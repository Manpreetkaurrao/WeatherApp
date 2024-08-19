//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Manpreet Kaur on 8/16/24.
//

import SwiftUI
import SDWebImageSwiftUI

import SwiftUI
import Combine

struct WeatherView: View {
    @StateObject private var viewModel: WeatherViewModel
    @State private var city: String = ""
    @State private var isLoading: Bool = false
    
    init(viewModel: WeatherViewModel = WeatherViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            TextField("Enter city", text: $city, onCommit: fetchWeather)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if isLoading {
                ProgressView()
                    .padding()
            } else if let weather = viewModel.weather {
                VStack {
                    Text("City: \(weather.name)")
                    Text("Temperature: \(weather.main.temp, specifier: "%.1f")°F")
                    if let icon = weather.weather.first?.icon {
                        WebImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
                .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onReceive(viewModel.$weather) { _ in
            isLoading = false
        }
        .onReceive(viewModel.$errorMessage) { _ in
            isLoading = false
        }
    }
    
    private func fetchWeather() {
        isLoading = true
        viewModel.fetchWeather(for: city)
    }
}
