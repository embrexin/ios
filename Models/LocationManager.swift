//
//  LocationManager.swift
//  Weather
//
//  Created by Amber Xiao on 4/6/24.
//

import Foundation

enum NetworkError: String, Error {
    case networkError
    case invalidURL
}

class LocationManager {
    static let instance = LocationManager()
    
    let baseLocationUrl = "https://nominatim.openstreetmap.org/search?city="
    let baseWeatherUrl = "https://api.open-meteo.com/v1/forecast?latitude="
    
    func getLocation(city: String, state: String) async throws -> [Location] {
        let cityComponents = city.components(separatedBy: " ")
        let newCity = cityComponents.joined(separator: "+")
        let stateComponents = state.components(separatedBy: " ")
        let newState = stateComponents.joined(separator: "+")
        
        guard let url = URL(string: "\(baseLocationUrl)\(newCity)&state=\(newState)&featureType=city&addressdetails=1&format=json") else {
               throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200, httpResponse.statusCode < 299 else {
            throw NetworkError.networkError
        }
        
        return try JSONDecoder().decode([Location].self, from: data)
    }
    
    func getWeather(longitude: Double, latitude: Double) async throws -> WeatherInfo {
        guard let url = URL(string: "\(baseWeatherUrl)\(latitude)&longitude=\(longitude)&hourly=temperature_2m,precipitation_probability,precipitation&temperature_unit=fahrenheit&forecast_days=1") else {
               throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200, httpResponse.statusCode < 299 else {
            throw NetworkError.networkError
        }
        
        return try JSONDecoder().decode(WeatherInfo.self, from: data)
    }
}
