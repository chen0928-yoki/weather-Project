//
//  AboutView.swift
//  weather
//
//  Created by Qianyu Chen on 2024/12/9.
//

import SwiftUI
import SwiftData
struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var locationService = LocationService()
    @State private var searchText = ""
    @State private var showError = false
    
    let popularCities: [(name: String, country: String, lat: Double, lon: Double)] = [
        ("London", "United Kingdom", 51.52, -0.11),
        ("Paris", "France", 48.87, 2.33),
        ("Ottawa","Canada",45.42,-75.7),
        ("Tokyo", "Japan", 35.69, 139.69),
    ]
    
    private let recommendedCities: [(name: String, country: String, lat: Double, lon: Double)] = [
        ("London", "United Kingdom", 51.52, -0.11),
        ("Paris", "France", 48.87, 2.33),
        ("Dubai","United Arab Emirates",25.25,55.28),
        ("New York", "United States of America", 40.71, -74.01),
        ("Tokyo", "Japan", 35.69, 139.69),
        ("Sydney", "Australia", -33.88, 151.22),
        ("Beijing", "China", 39.93, 116.39),
        ("Singapore", "Singapore", 1.29, 103.86),
        ("Ottawa","Canada",45.42,-75.7)
    ]
    
    private var displayCities: [Location] {
        if searchText.isEmpty {
            return recommendedCities.map { city in
                Location(
                    id: UUID().hashValue,
                    name: city.name,
                    region: "",
                    country: city.country,
                    lat: city.lat,
                    lon: city.lon,
                    url: ""
                )
            }
        }
        return locationService.searchResults
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color("backgroundStart"),
                    Color("backgroundEnd")
                ],
                startPoint: .top,
                endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                CustomNavigationBar(title: "Search for City")
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color("textSecondary"))
                        .font(.system(size: 20))
                        .padding(.leading, 8)
                    
                    TextField("Search for a city...", text: $searchText)
                        .foregroundColor(Color("textPrimary"))
                        .padding(.leading, 8)
                        .onChange(of: searchText) { _, newValue in
                            locationService.searchLocations(query: newValue)
                        }
                }
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal, 24)
                .padding(.top, 32)

                Text("Popular Citys")
                    .foregroundColor(Color("textPrimary"))
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                
                HStack {
                    ForEach(popularCities, id: \.name) { city in
                        Button(action: {
                            let location = Location(
                                id: UUID().hashValue,
                                name: city.name,
                                region: "",
                                country: city.country,
                                lat: city.lat,
                                lon: city.lon,
                                url: ""
                            )
                            addCity(location)
                            dismiss()
                        }) {
                            Text(city.name)
                                .foregroundColor(Color("textPrimary"))
                                .font(.system(size: 15))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color("textSecondary").opacity(0.2))
                                .cornerRadius(15)
                        }
                        
                        if city.name != popularCities.last?.name {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        if !searchText.isEmpty && locationService.isLoading {
                            ProgressView()
                                .padding()
                        } else if !searchText.isEmpty && locationService.error != nil {
                            Text(locationService.error ?? "Failed to search cities. Please try again.")
                                .foregroundColor(Color("textPrimary"))
                                .padding()
                        } else {
                            ForEach(displayCities) { location in
                                CitySearchItem(
                                    cityName: location.name,
                                    subtitle: location.country,
                                    lat: location.lat,
                                    lon: location.lon
                                ) {
                                    addCity(location)
                                    dismiss()
                                }
                            }
                        }
                    }
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(locationService.error ?? "Network request failed")
        }
        .onChange(of: locationService.error) { _, error in
            showError = error != nil
        }
    }
    
    private func addCity(_ location: Location) {
        let descriptor = FetchDescriptor<City>(
            predicate: #Predicate<City> { city in
                city.name == location.name && city.country == location.country
            }
        )
        
        if let existingCities = try? modelContext.fetch(descriptor), !existingCities.isEmpty {
            return
        }
        
        let allCitiesDescriptor = FetchDescriptor<City>()
        let allCities = (try? modelContext.fetch(allCitiesDescriptor)) ?? []
        let maxSortOrder = allCities.map { $0.sortOrder }.max() ?? -1
        
        let city = City(name: location.name, country: location.country, lat: location.lat, lon: location.lon)
        city.sortOrder = maxSortOrder + 1
        
        modelContext.insert(city)
        try? modelContext.save()
    }
}


struct CitySearchItem: View {
    let cityName: String
    let subtitle: String
    let lat: Double
    let lon: Double
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(cityName)
                    .foregroundColor(Color("textPrimary"))
                    .font(.system(size: 18))
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .foregroundColor(Color("textSecondary"))
                        .font(.system(size: 14))
                }
            }
            
            Spacer()
            
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .foregroundColor(Color("textPrimary"))
                    .font(.system(size: 24, weight: .semibold))
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        
        Divider()
            .background(Color("textSecondary"))
            .padding(.horizontal, 24)
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

