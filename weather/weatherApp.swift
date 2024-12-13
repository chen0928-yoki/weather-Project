//
//  weatherApp.swift
//  weather
//
//  Created by Qianyu Chen on 2024/12/10.
//

import SwiftUI
import SwiftData

@main
struct weatherApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            City.self,
            Settings.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                CityListView()
                    .navigationViewStyle(StackNavigationViewStyle())
                                .tint(.white)
                                .onAppear {
                                    let appearance = UINavigationBarAppearance()
                                    appearance.configureWithTransparentBackground()
                                    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                                    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                                    
                                    UINavigationBar.appearance().standardAppearance = appearance
                                    UINavigationBar.appearance().compactAppearance = appearance
                                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                                    
                                    UINavigationBar.appearance().tintColor = .white
                                }

            }
            
        }
        .modelContainer(sharedModelContainer)
    }
}
