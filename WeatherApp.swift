//
//  WeatherApp.swift
//  Weather
//
//  Created by Amber Xiao on 4/4/24.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject var weatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView(currLocation: Location.mock[0])
                .environmentObject(weatherViewModel)
        }
    }
}
