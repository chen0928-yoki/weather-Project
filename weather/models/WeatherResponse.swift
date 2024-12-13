struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    
    struct Location: Codable {
        let name: String
        let localtime: String
        let tz_id: String
    }
    
    struct Current: Codable {
        let temp_c: Double
        let is_day: Int
        let condition: Condition
        
        struct Condition: Codable {
            let text: String
            let icon: String
            let code: Int
        }
    }
} 

