//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Manpreet Kaur on 8/16/24.
//

import Foundation
import Combine

protocol NetworkManaging {
    func request(_ url: String, parameters: [String: String]) -> AnyPublisher<Data, Error>
}

final class NetworkService: NetworkManaging {
    
    func request(_ url: String, parameters: [String: String]) -> AnyPublisher<Data, Error> {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let urlRequest = URLRequest(url: components.url!)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
