//
//  AboutView.swift
//  weather
//
//  Created by Qianyu Chen on 2024/12/9.
//

import SwiftUI
import SwiftData


struct CityListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \City.sortOrder) private var cities: [City]
    @Query private var settings: [Settings]
    @StateObject private var weatherService = WeatherService.shared
    @State private var isEditMode = false
    
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
                HStack(spacing: 16) {
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color("textPrimary"))
                            .font(.system(size: 24))
                    }
                    
                    Text("Algonquin Weather")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Color("textPrimary"))
                    
                    Spacer()
                    
                    Button(action: {
                        isEditMode.toggle()
                    }) {
                        Image(systemName: isEditMode ? "checkmark.circle.fill" : "arrow.up.arrow.down.circle.fill")
                            .foregroundColor(Color("textPrimary"))
                            .font(.system(size: 24))
                    }
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color("textPrimary"))
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                if isEditMode {
                    List {
                        ForEach(weatherService.weatherCities, id: \.name) { weatherCity in
                            WeatherCityView(
                                weatherCity: weatherCity,
                                onDelete: {
                                    if let index = cities.firstIndex(where: { $0.name == weatherCity.name && $0.country == weatherCity.country }) {
                                        deleteCity(cities[index])
                                    }
                                }
                            )
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        }
                        .onMove { source, destination in
                            var updatedCities = cities
                            updatedCities.move(fromOffsets: source, toOffset: destination)
                            
                            for (index, city) in updatedCities.enumerated() {
                                city.sortOrder = index
                            }
                            
                            try? modelContext.save()
                            weatherService.startRefreshing(for: updatedCities)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .environment(\.editMode, .constant(.active))
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(weatherService.weatherCities, id: \.name) { weatherCity in
                                WeatherCityView(
                                    weatherCity: weatherCity,
                                    onDelete: {
                                        if let index = cities.firstIndex(where: { $0.name == weatherCity.name && $0.country == weatherCity.country }) {
                                            deleteCity(cities[index])
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 24)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {

            initializeSettingsIfNeeded()

            if weatherService.weatherCities.isEmpty {
                let interval = settings.first?.weatherRefreshInterval ?? 600
                weatherService.updateRefreshInterval(interval)
                weatherService.startRefreshing(for: cities)
            }
        }
        .onDisappear {

            if !cities.isEmpty {
                weatherService.stopRefreshing()
            }
        }
        
        .onChange(of: settings.first?.weatherRefreshInterval) { oldValue, newValue in
            if let interval = newValue {
                weatherService.updateRefreshInterval(interval)
                weatherService.stopRefreshing()
                weatherService.startRefreshing(for: cities)
            }
        }
        
        .onChange(of: cities) { oldValue, newValue in
            weatherService.startRefreshing(for: newValue)
        }
    }
    
    private func deleteCity(_ city: City) {
        modelContext.delete(city)
        try? modelContext.save()

        weatherService.startRefreshing(for: cities)
    }
    
    private func initializeSettingsIfNeeded() {
        if settings.isEmpty {
            let defaultSettings = Settings()
            modelContext.insert(defaultSettings)
            try? modelContext.save()
        }
    }
}

struct WeatherCityView: View {
    let weatherCity: WeatherCity
    let onDelete: () -> Void
    
    var body: some View {
        NavigationLink(destination: CityDetailView(
            cityName: weatherCity.name,
            lat: weatherCity.lat,
            lon: weatherCity.lon
        )) {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 4) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(alignment: .top, spacing: 0) {
                                    Text(weatherCity.temperature)
                                        .font(.system(size: 46, weight: .bold))
                                    Text("°C")
                                        .font(.system(size: 20, weight: .bold))
                                        .padding(.top, 8)
                                }
                                .foregroundColor(Color("textPrimary"))
                                
                                Text(weatherCity.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("textPrimary"))
                                Text(weatherCity.country)
                                    .font(.subheadline)
                                    .foregroundColor(Color("textSecondary"))
                            }
                            
                            Spacer()
                            
                            Group {
                                switch weatherCity.loadState {
                                case .loading:
                                    ProgressView()
                                        .scaleEffect(1.5)
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(Color.accentColor)
                                case .error:
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 60))
                                        .foregroundColor(Color.accentColor)
                                        .frame(width: 80, height: 80)
                                case .loaded:
                                    Image(systemName: weatherIcon(for: weatherCity))
                                        .font(.system(size: 80))
                                        .foregroundColor(Color("textPrimary"))
                                        .frame(height: 80)
                                }
                            }
                            .padding(.trailing, 50)
                        }
                        
                        HStack {
                            Text(weatherCity.time)
                                .font(.subheadline)
                                .foregroundColor(Color("textSecondary"))
                            
                            Spacer()
                            
                            if case .error = weatherCity.loadState, let error = weatherCity.errorMessage {
                                Text(error)
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .padding(.trailing, 50)
                            } else {
                                Text(weatherCity.weather)
                                    .font(.subheadline)
                                    .foregroundColor(Color("textSecondary"))
                                    .padding(.trailing, 60)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(Color("textSecondary"))
                    }
                    .padding(.top, 4)
                    .padding(.trailing, 4)
                }
                
                Divider()
                    .background(Color("textSecondary"))
            }
        }
    }
    
    private func weatherIcon(for weatherCity: WeatherCity) -> String {
        return WeatherUtils.weatherIcon(for: weatherCity.weather, isDay: weatherCity.is_day)
    }
}


#Preview {
    CityListView()
}


