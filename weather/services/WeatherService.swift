//
//  AboutView.swift
//  weather
//
//  Created by Qianyu Chen on 2024/12/9.
//

import Foundation
import SwiftData



class WeatherService: ObservableObject {
    static let shared = WeatherService()
    private var weatherTimer: Timer?
    private var timeTimer: Timer?
    private var weatherRefreshInterval: Int = 600 
    private let timeRefreshInterval: Int = 60 
    
    @Published private(set) var weatherCities: [WeatherCity] = []
    @Published var weatherData: WeatherData?
    
    func startRefreshing(for cities: [City]) {
        
        weatherCities = cities.map { city in
            WeatherCity(
                name: city.name,
                country: city.country,
                temperature: "--°",
                time: "--:--",
                weather: "Loading",
                is_day: 1,
                loadState: .loading,
                errorMessage: nil,
                timeZone: nil,
                lat: city.lat,
                lon: city.lon
            )
        }
        
  
        stopRefreshing()
        

        updateWeather()
        
    
        weatherTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(weatherRefreshInterval), repeats: true) { [weak self] _ in
            self?.updateWeather()
        }
        
  
        timeTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeRefreshInterval), repeats: true) { [weak self] _ in
            self?.updateLocalTimes()
        }
    }
    
    func stopRefreshing() {
        weatherTimer?.invalidate()
        weatherTimer = nil
        timeTimer?.invalidate()
        timeTimer = nil
    }
    
    private func updateLocalTimes() {
        print("Updating local times...")
        let currentDate = Date()
        
        for (index, city) in weatherCities.enumerated() {
            if city.loadState == .loaded, let timeZone = city.timeZone {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                formatter.timeZone = timeZone
                
                
                let newTime = formatter.string(from: currentDate)
                print("Updating time for \(city.name): \(newTime)")
                weatherCities[index].time = newTime
            }
        }
    }
    
    private func updateWeather() {
        print("Updating weather at: \(Date())")
        for index in weatherCities.indices {
            updateWeatherForCity(at: index)
        }
    }
    
    private func updateWeatherForCity(at index: Int) {
        guard index >= 0 && index < weatherCities.count else { return }
        
        print("Updating weather for city: \(weatherCities[index].name)")
        let cityName = weatherCities[index].name
        
        weatherCities[index].loadState = .loading
        
        Task {
            do {
                let weather = try await fetchWeather(for: cityName)
                
                await MainActor.run {
                    guard index < self.weatherCities.count else { return }
                    
                    self.weatherCities[index].temperature = String(format: "%.1f", weather.current.temp_c)
                    self.weatherCities[index].weather = weather.current.condition.text
                    self.weatherCities[index].is_day = weather.current.is_day
                    self.weatherCities[index].loadState = .loaded
                    self.weatherCities[index].errorMessage = nil
                    
                    if let timeZone = TimeZone(identifier: weather.location.tz_id) {
                        self.weatherCities[index].timeZone = timeZone
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        formatter.timeZone = timeZone
                        self.weatherCities[index].time = formatter.string(from: Date())
                    }
                }
            } catch {
                await MainActor.run {
                    guard index < self.weatherCities.count else { return }
                    self.weatherCities[index].loadState = .error
                    self.weatherCities[index].errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func fetchWeather(for city: String) async throws -> WeatherResponse {
        let urlString = "\(APIConfig.baseURL)/current.json?key=\(APIConfig.weatherAPIKey)&q=\(city)&aqi=no"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return weather
    }
    
    private func formatTime(_ timeString: String) -> String {
        // "2024-12-12 07:30"
        let components = timeString.split(separator: " ")
        if components.count > 1 {
            return String(components[1])
        }
        return timeString
    }
    
    func updateRefreshInterval(_ interval: Int) {
        weatherRefreshInterval = interval
    }
    
    func fetchWeatherForecast(lat: Double,lon:Double) async {
        guard let url = URL(string: "\(APIConfig.baseURL)/forecast.json?key=\(APIConfig.weatherAPIKey)&q=\(lat),\(lon)&days=1&aqi=no&alerts=no") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            await MainActor.run {
                self.weatherData = weatherData
            }
        } catch {
            print("Error fetching weather data: \(error)")
        }
    }
    
    func updateCitiesOrder(_ cities: [City]) {
      
        let orderedWeatherCities = weatherCities.sorted { city1, city2 in
            guard let index1 = cities.firstIndex(where: { $0.name == city1.name && $0.country == city1.country }),
                  let index2 = cities.firstIndex(where: { $0.name == city2.name && $0.country == city2.country }) else {
                return false
            }
            return index1 < index2
        }
        
        DispatchQueue.main.async {
            self.weatherCities = orderedWeatherCities
        }
    }
    
    func updateCitiesOrder(from source: IndexSet, to destination: Int) {
        var newWeatherCities = Array(weatherCities)
        newWeatherCities.move(fromOffsets: source, toOffset: destination)
        self.weatherCities = newWeatherCities
    }
}
