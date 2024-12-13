//
//  AboutView.swift
//  weather
//
//  Created by Qianyu Chen on 2024/12/9.
//

import Foundation

class LocationService: ObservableObject {
    @Published var searchResults: [Location] = []
    @Published var isLoading = false
    @Published var error: String?
    
    func searchLocations(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        
        let urlString = "\(APIConfig.baseURL)/search.json?key=\(APIConfig.weatherAPIKey)&q=\(query)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = error.localizedDescription
                    return
                }
                
                guard let data = data else { 
                    self?.error = "Network request failed"
                    return 
                }
                
                do {
                    let locations = try JSONDecoder().decode([Location].self, from: data)
                    self?.searchResults = locations
                    self?.error = nil
                } catch {
                    self?.error = "Failed to decode data"
                }
            }
        }.resume()
    }
} 
