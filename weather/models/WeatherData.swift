import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: CurrentWeather
    let forecast: Forecast
    
    struct Location: Codable {
        let name: String
        let region: String
        let country: String
        let lat: Double
        let lon: Double
        let tz_id: String
        let localtime: String
    }
    
    struct CurrentWeather: Codable {
        let temp_c: Double
        let temp_f: Double
        let is_day: Int
        let condition: WeatherCondition
        let wind_mph: Double
        let humidity: Double
        let uv: Double
        
        struct WeatherCondition: Codable {
            let text: String
            let icon: String
        }
    }
    
    struct Forecast: Codable {
        let forecastday: [ForecastDay]
        
        struct ForecastDay: Codable {
            let date: String
            let day: DayWeather?
            let hour: [HourWeather]
            
            struct DayWeather: Codable {
            }
            
            struct HourWeather: Codable{
                let time: String
                let temp_c: Double
                let temp_f: Double
                let is_day: Int
                let condition: WeatherCondition
                
                struct WeatherCondition: Codable {
                    let text: String
                }
        
            }
        }
    }
} 
