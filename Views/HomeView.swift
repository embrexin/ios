import SwiftUI

struct HomeView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel

    @State var selectedLocation: Location? = nil
    @State var selectedSearch: Location? = nil
    @State var currLocation: Location
    @State var city: String = ""
    @State var state: String = ""
    @State var navigate: Bool = false
    
    var body: some View {
        NavigationSplitView {
            VStack {
                List {
                    Section("Saved Locations") {
                        ForEach(weatherViewModel.savedLocations) { location in
                            NavigationLink(destination: WeatherView(weather: WeatherInfo.mock, location: location)) {
                                Text(location.display_name)
                            }
                        }
                        .listRowBackground(Rectangle()
                                            .background(Color.clear)
                                            .foregroundColor(.cyan)
                                            .opacity(0.3))
                    }
                    Section("Saved Search Results") {
                        ForEach(Array(weatherViewModel.savedSearchResults.keys), id: \.self) {
                            key in
                            if let weatherInfo = weatherViewModel.savedSearchResults[key], let location = weatherViewModel.savedLocations.first(where: {$0.id == key}) {
                                NavigationLink(destination: SavedSearchView(weather: weatherInfo, location: location)) {
                                    Text(location.display_name)
                                }
                            }
                        }
                        .listRowBackground(Rectangle()
                                            .background(Color.clear)
                                            .foregroundColor(.mint)
                                            .opacity(0.3))
                    }
                    Section("Search") {
                        VStack {
                            TextField("Type the city name...", text: $city)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            TextField("Type the state name...", text: $state)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            Button(action: {
                                if !city.isEmpty && !state.isEmpty {
                                    Task {
                                        await fetchLocation()
                                        navigate = true
                                    }
                                }
                            }, label: {
                                Text("Get Location")
                                    .foregroundStyle(.cyan.gradient)
                            })
                            .navigationDestination(isPresented: $navigate) {
                                WeatherView(weather: WeatherInfo.mock, location: currLocation)
                            }
                            .disabled(city.isEmpty || state.isEmpty)
                            .padding()
                        }
                        .multilineTextAlignment(.center)
                        .padding()
                    }
                }
            }
            .navigationTitle("Home")
        } detail: {
            Text("Enter a location or choose a result")
        }
    }
    
    func fetchLocation() async {
        do {
            await weatherViewModel.getLocation(cityName: city, stateName: state)
            city = ""
            state = ""
            if let newLocation = weatherViewModel.currLocation {
                currLocation = newLocation
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(currLocation: Location.mock[0])
            .environmentObject(WeatherViewModel())
    }
}
