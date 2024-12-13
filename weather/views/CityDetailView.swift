import SwiftUI
import MapKit
import SwiftData

struct CityDetailView: View {
    let cityName: String
    let lat: Double
    let lon: Double
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var weatherService = WeatherService.shared
    @State private var isCelsius = true
    @State private var targetScrollTime: String? = nil
    @Query private var cities: [City]
    
    @State private var localWeatherData: WeatherData?
    
    @State private var isLoading = true
    
    private var isCityAdded: Bool {
        guard let country = localWeatherData?.location.country else { return false }
        return cities.contains { $0.name == cityName && $0.country == country }
    }
    
    private func color(for temperature: Double) -> Color {
        let normalized = (temperature + 30) / 70 // Normalize temperature to 0.0 - 1.0 for the range -30 to 40
        return Color(hue: (1.0 - normalized) * 2/3, saturation: 0.8, brightness: 0.9)
    }
    
    private func getBackgroundGradient(temperature: Double) -> LinearGradient {
        let mainColor = color(for: temperature)
        return LinearGradient(
            colors: [
                mainColor.opacity(0.4),  
                mainColor  
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private func getInitialScrollIndex(hours: [String], currentTime: String) -> String? {
        return hours.first { hourTime in
            hourTime > currentTime
        }
    }
    
    var body: some View {
        ZStack {
                Map(position: .constant(.region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: lat,
                        longitude: lon
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.1,
                        longitudeDelta: 0.1
                    )
                ))))
                .mapStyle(.standard(elevation: .flat))
                .disabled(true)
                .allowsHitTesting(false)
                .edgesIgnoringSafeArea(.all)

            getBackgroundGradient(temperature: localWeatherData?.current.temp_c ?? 0)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("textPrimary"))
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.3))
                            )
                    }
                    
                    Spacer()
                    
                    if !isCityAdded {
                        Button(action: {
                            if let country = localWeatherData?.location.country {
                                let newCity = City(name: cityName, country: country,lat: lat,lon: lon)
                                modelContext.insert(newCity)
                                dismiss()
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("textPrimary"))
                                .padding()
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.3))
                                )
                        }
                    }
                }
                .padding(.horizontal)
                
                              
                Spacer()
                
                VStack(spacing: 20) {
                    Spacer()
                    VStack(alignment: .center,spacing: 0) {
                        Text(cityName)
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(Color("textPrimary"))
                        
                        Button(action: {
                            isCelsius.toggle()
                        }) {
                            HStack(alignment: .top) {
                                Text("\(isCelsius ? String(format: "%.1f", localWeatherData?.current.temp_c ?? 0.0) : String(format: "%.1f", localWeatherData?.current.temp_f ?? 0.0))")
                                    .font(.system(size: 110, weight: .bold))
                                Text("°\(isCelsius ? "C" : "F")")
                                    .font(.system(size: 34, weight: .bold))
                                    .padding(.top, 8)
                            }
                        }
                        .foregroundColor(Color("textPrimary"))
                        
                        Text(localWeatherData?.forecast.forecastday.first?.date ?? "")
                            .font(.system(size: 18))
                            .foregroundColor(Color("textSecondary"))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        HStack(alignment: .center) {
                            WeatherIndexView(icon: "sun.max.fill", title: "UV Index", value:  String(format: "%.1f",localWeatherData?.current.uv ?? 0))
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 1)
                            WeatherIndexView(icon: "wind", title: "Wind", value: String(format: "%.1f", localWeatherData?.current.wind_mph ?? 0) + " mph")
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 1)
                            WeatherIndexView(icon: "humidity", title: "Humidity", value:  String(format: "%.0f",localWeatherData?.current.humidity ?? 0) + "%" )
                        }
                        .frame(height: 60)
                        .padding(.vertical, 30)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color("textPrimary"), lineWidth: 32)
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(color(for: localWeatherData?.current.temp_c ?? 0))
                            }
                        )

                        HStack(spacing: 0) {
                            VStack(spacing: 8) {
                                Text("Now")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color("textPrimary"))
                                Image(systemName: WeatherUtils.weatherIcon(for: localWeatherData?.current.condition.text ?? "", isDay: localWeatherData?.current.is_day ?? 1))
                                    .font(.system(size: 24))
                                    .foregroundColor(Color("textPrimary"))
                                Text((isCelsius ? String(format: "%.0f",localWeatherData?.current.temp_c ?? 0) :
                                        String(format: "%.0f",localWeatherData?.current.temp_f ?? 0)) + "°")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("textPrimary"))
                            }
                            .foregroundColor(.white)
                            .frame(width: 60)

                            Rectangle()
                                .fill(Color("textSecondary"))
                                .frame(width: 1, height: 40)
                            
                          ScrollView(.horizontal, showsIndicators: false) {
                              ScrollViewReader { proxy in
                                  HStack(spacing: 20) {
                                      if let hours = localWeatherData?.forecast.forecastday.first?.hour {
                                          ForEach(hours, id: \.time) { hour in
                                              VStack(spacing: 8) {
                                                  Text(hour.time.suffix(5))
                                                      .font(.system(size: 16))
                                                      .foregroundColor(Color("textPrimary"))
                                                  Image(systemName: WeatherUtils.weatherIcon(for: hour.condition.text, isDay: hour.is_day))
                                                      .font(.system(size: 24))
                                                      .foregroundColor(Color("textPrimary"))
                                                  Text(String(format: "%.0f", (isCelsius ? hour.temp_c : hour.temp_f)) + "°")
                                                      .font(.system(size: 20, weight: .bold))
                                                      .foregroundColor(Color("textPrimary"))
                                              }
                                              .foregroundColor(.white)
                                              .id(hour.time)
                                          }
                                      }
                                  }
                                  .onChange(of: targetScrollTime) { oldValue, newValue in
                                      if let time = newValue {
                                          withAnimation {
                                              proxy.scrollTo(time, anchor: .leading)
                                          }
                                      }
                                  }
                              }
                          }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 8)
                            .frame(maxWidth: .infinity)
                            .background(
                                ZStack {
                            
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color("textPrimary"), lineWidth: 32)
                          
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(color(for: localWeatherData?.current.temp_c  ?? 0))
                                }
                            )
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            isLoading = true
            await weatherService.fetchWeatherForecast(lat:lat,lon:lon)
            localWeatherData = weatherService.weatherData
            isLoading = false
            
            if let hours = localWeatherData?.forecast.forecastday.first?.hour,
              let currentTime = localWeatherData?.location.localtime {
                targetScrollTime = getInitialScrollIndex(hours: hours.map { $0.time }, currentTime: currentTime)
            }
        }
      
    }
}


// 天气指标视图
struct WeatherIndexView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {  
            HStack(spacing: 4) {  
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .bold()
                Text(title)
                    .font(.system(size: 14))
                    .bold()
            }
            Text(value)  
                .font(.system(size: 20, weight: .bold))
        }
        .foregroundColor(Color("textPrimary"))
        .frame(maxWidth: .infinity)
    }
}



#Preview {
    return CityDetailView(cityName: "Dubai", lat: 25.276987, lon: 55.296230)
            .modelContainer(for: City.self)
}
