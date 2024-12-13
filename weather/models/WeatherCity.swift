import Foundation

struct WeatherCity {
    let name: String
    let country: String
    var temperature: String
    var time: String
    var weather: String
    var is_day: Int
    var loadState: WeatherLoadState
    var errorMessage: String?
    var timeZone: TimeZone?
    let lat: Double
    let lon: Double
}

enum WeatherLoadState {
    case loading
    case error
    case loaded
} 
