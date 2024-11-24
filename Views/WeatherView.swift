//
//  WeatherView.swift
//  Weather
//
//  Created by Amber Xiao on 4/6/24.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @State var weather: WeatherInfo

    let location: Location
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .teal]), startPoint: .top, endPoint: .bottom)
                .opacity(0.4)
            VStack(alignment: .center) {
                Text("\(location.address.city), \(location.address.state)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.mint)
                Text(String(format: "%.2f", weather.data.temperature[weather.hour]) + "°F")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(.cyan)
                Text("Precipitation\n" + String(format: "%.2f", weather.data.precipitation[weather.hour]) + "\"")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .lineSpacing(15.0)
                    .multilineTextAlignment(.center)
                Text("Precipitation Probability\n" + "\(weather.data.precipitation_probability[weather.hour])%")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .lineSpacing(15.0)
                    .multilineTextAlignment(.center)
            }
            .onAppear {
                Task {
                    await weatherViewModel.getWeather(longitude: location.lon, latitude: location.lat)
                    if let newWeather = weatherViewModel.currWeather {
                        weather = newWeather
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding()
            .navigationTitle("Weather")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if weatherViewModel.isLocationSaved(location) {
                        Button("Unfavorite", systemImage: "star.fill") {
                            weatherViewModel.unsaveLocation(location)
                        }
                    } else {
                        Button("Favorite", systemImage: "star") {
                            weatherViewModel.saveLocation(location)
                        }
                    }
                    if weatherViewModel.isSearchSaved(location.id) {
                        Button("Unfavorite", systemImage: "magnifyingglass.circle.fill") {
                            weatherViewModel.unsaveSearchResult(location)
                        }
                    } else {
                        Button("Favorite", systemImage: "magnifyingglass.circle") {
                            weatherViewModel.saveSearchResult(weather, forLocation: location)
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: WeatherInfo.mock, location: Location.mock[0])
            .environmentObject(WeatherViewModel())
    }
}

