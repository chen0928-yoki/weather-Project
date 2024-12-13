import Foundation

struct WeatherUtils {
    static func weatherIcon(for weather: String, isDay: Int) -> String {
        let lowercased = weather.lowercased()
        
        if isDay == 1 {
            switch lowercased {
            case _ where lowercased.contains("sunny"):
                return "sun.max.fill"
                
            case _ where lowercased.contains("partly cloudy"):
                return "cloud.sun.fill"
            case _ where lowercased.contains("cloudy") || lowercased.contains("overcast"):
                return "cloud.fill"
                
            case _ where lowercased.contains("mist"):
                return "cloud.fog.fill"
            case _ where lowercased.contains("freezing fog"):
                return "cloud.fog.fill"
            case _ where lowercased.contains("fog"):
                return "sun.haze.fill"
                
            case _ where lowercased.contains("patchy freezing drizzle possible"):
                return "cloud.drizzle.fill"
            case _ where lowercased.contains("patchy light drizzle"):
                return "cloud.drizzle.fill"
            case _ where lowercased.contains("light drizzle"):
                return "cloud.drizzle.fill"
            case _ where lowercased.contains("freezing drizzle"):
                return "cloud.drizzle.fill"
            case _ where lowercased.contains("heavy freezing drizzle"):
                return "cloud.drizzle.fill"
            case _ where lowercased.contains("drizzle"):
                return "cloud.drizzle.fill"
                
            case _ where lowercased.contains("light rain shower"):
                return "cloud.sun.rain.fill"
            case _ where lowercased.contains("patchy rain possible"):
                return "cloud.sun.rain.fill"
            case _ where lowercased.contains("patchy light rain"):
                return "cloud.sun.rain.fill"
            case _ where lowercased.contains("light rain"):
                return "cloud.sun.rain.fill"
            case _ where lowercased.contains("moderate rain at times"):
                return "cloud.rain.fill"
            case _ where lowercased.contains("moderate rain"):
                return "cloud.rain.fill"
            case _ where lowercased.contains("heavy rain at times"):
                return "cloud.heavyrain.fill"
            case _ where lowercased.contains("heavy rain"):
                return "cloud.heavyrain.fill"
            case _ where lowercased.contains("moderate or heavy rain shower"):
                return "cloud.heavyrain.fill"
            case _ where lowercased.contains("torrential"):
                return "cloud.heavyrain.fill"
            case _ where lowercased.contains("light freezing rain"):
                return "cloud.rain.fill"
            case _ where lowercased.contains("moderate or heavy freezing rain"):
                return "cloud.heavyrain.fill"
                
            case _ where lowercased.contains("patchy snow possible"):
                return "cloud.sun.snow.fill"
            case _ where lowercased.contains("light snow shower"):
                return "cloud.sun.snow.fill"
            case _ where lowercased.contains("patchy light snow"):
                return "cloud.sun.snow.fill"
            case _ where lowercased.contains("light snow"):
                return "cloud.sun.snow.fill"
            case _ where lowercased.contains("patchy moderate snow"):
                return "cloud.snow.fill"
            case _ where lowercased.contains("moderate snow"):
                return "cloud.snow.fill"
            case _ where lowercased.contains("patchy heavy snow"):
                return "cloud.snow.fill"
            case _ where lowercased.contains("heavy snow"):
                return "cloud.snow.fill"
            case _ where lowercased.contains("moderate or heavy snow shower"):
                return "cloud.snow.fill"
            case _ where lowercased.contains("blowing snow"):
                return "wind.snow"
            case _ where lowercased.contains("blizzard"):
                return "snowflake"
                
            case _ where lowercased.contains("patchy sleet possible"):
                return "cloud.sleet.fill"
            case _ where lowercased.contains("light sleet"):
                return "cloud.sleet.fill"
            case _ where lowercased.contains("moderate or heavy sleet"):
                return "cloud.sleet.fill"
            case _ where lowercased.contains("light sleet showers"):
                return "cloud.sleet.fill"
            case _ where lowercased.contains("moderate or heavy sleet showers"):
                return "cloud.sleet.fill"
                
            case _ where lowercased.contains("ice pellets"):
                return "cloud.hail.fill"
            case _ where lowercased.contains("light showers of ice pellets"):
                return "cloud.hail.fill"
            case _ where lowercased.contains("moderate or heavy showers of ice pellets"):
                return "cloud.hail.fill"
                
            case _ where lowercased.contains("thundery outbreaks possible"):
                return "cloud.bolt.fill"
            case _ where lowercased.contains("patchy light rain with thunder"):
                return "cloud.bolt.rain.fill"
            case _ where lowercased.contains("moderate or heavy rain with thunder"):
                return "cloud.bolt.rain.fill"
            case _ where lowercased.contains("patchy light snow with thunder"):
                return "cloud.bolt.snow.fill"
            case _ where lowercased.contains("moderate or heavy snow with thunder"):
                return "cloud.bolt.snow.fill"
                
            default:
                return "cloud.fill"
            }
        } else {
            switch lowercased {
            case _ where lowercased.contains("clear"):
                return "moon.fill"
                
            case _ where lowercased.contains("partly cloudy"):
                return "cloud.moon.fill"
            case _ where lowercased.contains("cloudy") || lowercased.contains("overcast"):
                return "cloud.fill"
                
            case _ where lowercased.contains("mist"):
                return "cloud.fog.fill"
            case _ where lowercased.contains("freezing fog"):
                return "cloud.fog.fill"
            case _ where lowercased.contains("fog"):
                return "moon.haze.fill"
                
            case _ where lowercased.contains("patchy freezing drizzle possible"):
                return "cloud.drizzle.fill"
            case _ where lowercased.contains("patchy light drizzle"):
                return "cloud.drizzle.fill"
            case _ where lowercased.contains("light drizzle"):
                return "cloud.drizzle.fill"
            case _ where lowercased.contains("freezing drizzle"):
                return "cloud.drizzle.fill"
            case _ where lowercased.contains("heavy freezing drizzle"):
                return "cloud.drizzle.fill"
            case _ where lowercased.contains("drizzle"):
                return "cloud.drizzle.fill"
                
            case _ where lowercased.contains("light rain shower"):
                return "cloud.moon.rain.fill"
            case _ where lowercased.contains("patchy rain possible"):
                return "cloud.moon.rain.fill"
            case _ where lowercased.contains("patchy light rain"):
                return "cloud.moon.rain.fill"
            case _ where lowercased.contains("light rain"):
                return "cloud.moon.rain.fill"
            case _ where lowercased.contains("moderate rain at times"):
                return "cloud.rain.fill"
            case _ where lowercased.contains("moderate rain"):
                return "cloud.rain.fill"
            case _ where lowercased.contains("heavy rain at times"):
                return "cloud.heavyrain.fill"
            case _ where lowercased.contains("heavy rain"):
                return "cloud.heavyrain.fill"
            case _ where lowercased.contains("moderate or heavy rain shower"):
                return "cloud.heavyrain.fill"
            case _ where lowercased.contains("torrential"):
                return "cloud.heavyrain.fill"
            case _ where lowercased.contains("light freezing rain"):
                return "cloud.rain.fill"
            case _ where lowercased.contains("moderate or heavy freezing rain"):
                return "cloud.heavyrain.fill"
                
            case _ where lowercased.contains("patchy snow possible"):
                return "cloud.moon.snow.fill"
            case _ where lowercased.contains("light snow shower"):
                return "cloud.moon.snow.fill"
            case _ where lowercased.contains("patchy light snow"):
                return "cloud.moon.snow.fill"
            case _ where lowercased.contains("light snow"):
                return "cloud.moon.snow.fill"
            case _ where lowercased.contains("patchy moderate snow"):
                return "cloud.snow.fill"
            case _ where lowercased.contains("moderate snow"):
                return "cloud.snow.fill"
            case _ where lowercased.contains("patchy heavy snow"):
                return "cloud.snow.fill"
            case _ where lowercased.contains("heavy snow"):
                return "cloud.snow.fill"
            case _ where lowercased.contains("moderate or heavy snow shower"):
                return "cloud.snow.fill"
            case _ where lowercased.contains("blowing snow"):
                return "wind.snow"
            case _ where lowercased.contains("blizzard"):
                return "snowflake"
                
            case _ where lowercased.contains("patchy sleet possible"):
                return "cloud.sleet.fill"
            case _ where lowercased.contains("light sleet"):
                return "cloud.sleet.fill"
            case _ where lowercased.contains("moderate or heavy sleet"):
                return "cloud.sleet.fill"
            case _ where lowercased.contains("light sleet showers"):
                return "cloud.sleet.fill"
            case _ where lowercased.contains("moderate or heavy sleet showers"):
                return "cloud.sleet.fill"
                
            case _ where lowercased.contains("ice pellets"):
                return "cloud.hail.fill"
            case _ where lowercased.contains("light showers of ice pellets"):
                return "cloud.hail.fill"
            case _ where lowercased.contains("moderate or heavy showers of ice pellets"):
                return "cloud.hail.fill"
                
            case _ where lowercased.contains("thundery outbreaks possible"):
                return "cloud.bolt.fill"
            case _ where lowercased.contains("patchy light rain with thunder"):
                return "cloud.bolt.rain.fill"
            case _ where lowercased.contains("moderate or heavy rain with thunder"):
                return "cloud.bolt.rain.fill"
            case _ where lowercased.contains("patchy light snow with thunder"):
                return "cloud.bolt.snow.fill"
            case _ where lowercased.contains("moderate or heavy snow with thunder"):
                return "cloud.bolt.snow.fill"
                
            default:
                return "cloud.fill"
            }
        }
    }
} 