//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Manpreet Kaur on 8/16/24.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let icon: String
}
