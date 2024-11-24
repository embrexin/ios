//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Amber Xiao on 4/4/24.
//

import Foundation
import CoreLocation
import CoreMotion
import MapKit
import SwiftUI
import CoreData

class WeatherViewModel: ObservableObject {
    @Published var currLocation: Location?
    @Published var currWeather: WeatherInfo?
    @Published var savedLocations : [Location] = []
    @Published var savedSearchResults: [String: WeatherInfo] = [:]
    
    init() {
        loadSavedLocations()
        loadSavedSearches()
    }
    
    func getLocation(cityName: String, stateName: String) async {
        do {
            let newLocation = try await LocationManager.instance.getLocation(city: cityName, state: stateName)
            currLocation = newLocation[0]
        } catch let error {
            print(error)
        }
    }
    
    func getWeather(longitude: String, latitude: String) async {
        do {
            let newWeather = try await LocationManager.instance.getWeather(longitude: Double(longitude)!, latitude: Double(latitude)!)
            currWeather = newWeather
        } catch let error {
            print(error)
        }
    }
    
    func saveLocation(_ location: Location) {
        if !savedLocations.contains(where: {$0.id == location.id}) {
            savedLocations.append(location)
            saveLocations()
        }
    }
    
    func unsaveLocation(_ location: Location) {
        savedLocations.removeAll(where: {$0.id == location.id})
        saveLocations()
    }
    
    func saveSearchResult(_ weatherInfo: WeatherInfo, forLocation location: Location) {
        savedSearchResults[location.id] = weatherInfo
        saveSearchResults()
    }
    
    func unsaveSearchResult(_ location: Location) {
        savedSearchResults.removeValue(forKey: location.id)
        saveSearchResults()
    }
    
    func isLocationSaved(_ location: Location) -> Bool {
        return savedLocations.contains(where: {$0.id == location.id})
    }

    func isSearchSaved(_ search: String) -> Bool {
        if savedSearchResults[search] != nil {
            return true
        }
        return false
    }
    
    private func loadSavedLocations() {
        if let savedLocationsData = UserDefaults.standard.data(forKey: "savedLocations"),
           let loadedLocations = try? JSONDecoder().decode([Location].self, from: savedLocationsData) {
            self.savedLocations = loadedLocations
        }
    }
    
    private func loadSavedSearches() {
        if let savedResultsData = UserDefaults.standard.data(forKey: "savedSearchResults"), let loadedSearches = try? JSONDecoder().decode([String: WeatherInfo].self, from: savedResultsData) {
            self.savedSearchResults = loadedSearches
        }
    }
    
    private func saveLocations() {
        if let encoded = try? JSONEncoder().encode(savedLocations) {
            UserDefaults.standard.set(encoded, forKey: "savedLocations")
        }
    }
    
    private func saveSearchResults() {
        if let encoded = try? JSONEncoder().encode(savedSearchResults) {
            UserDefaults.standard.set(encoded, forKey: "savedSearchResults")
        }
    }
}
