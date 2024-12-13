import SwiftData
import Foundation

@Model
class City {
    var name: String
    var country: String
    var lat: Double
    var lon: Double
    var sortOrder: Int
    
    init(name: String, country: String, lat: Double, lon: Double) {
        self.name = name
        self.country = country
        self.lat = lat
        self.lon = lon
        self.sortOrder = 0
    }
}
