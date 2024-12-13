import SwiftData

@Model
class Settings {
    var weatherRefreshInterval: Int
    
    init(weatherRefreshInterval: Int = 600) {
        self.weatherRefreshInterval = weatherRefreshInterval
    }
} 