//
//  AboutView.swift
//  weather
//
//  Created by Qianyu Chen on 2024/12/9.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [Settings]
    @State private var showingRefreshIntervalAlert = false
    
    private let intervals: [Int] = [
        60,   // 1 minute 
        300,  // 5 minutes
        600,  // 10 minutes
        900,  // 15 minutes
        1800, // 30 minutes
        3600  // 1 hour
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color("backgroundStart"),
                    Color("backgroundEnd")
                ],
                startPoint: .top,
                endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                CustomNavigationBar(title: "Settings")
                
                VStack(spacing: 0) {
                    Button(action: {
                        showingRefreshIntervalAlert = true
                    }) {
                        HStack {
                            Text("Refresh interval")
                                .foregroundColor(Color("textPrimary"))
                            Spacer()
                            Text(formatInterval(settings.first?.weatherRefreshInterval ?? 600))
                                .foregroundColor(Color("textSecondary"))
                        }
                        .padding(.vertical, 16)
                    }
                    
                    Divider()
                        .background(Color("textSecondary"))
                    
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Text("About")
                                .foregroundColor(Color("textPrimary"))
                            Spacer()
                        }
                        .padding(.vertical, 16)
                    }
                    
                    Divider()
                        .background(Color("textSecondary"))
                }
                .padding(.horizontal, 48)
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .confirmationDialog("Select Refresh Interval", 
                          isPresented: $showingRefreshIntervalAlert,
                          titleVisibility: .visible) {
            ForEach(intervals, id: \.self) { interval in
                Button(formatInterval(interval)) {
                    if let settings = settings.first {
                        settings.weatherRefreshInterval = interval
                        try? modelContext.save()
                    }
                }
            }
            
            Button("Cancel", role: .cancel) { }
        }
        .onAppear {
            if settings.isEmpty {
                let newSettings = Settings()
                modelContext.insert(newSettings)
                try? modelContext.save()
            }
        }
    }
    
    private func formatInterval(_ interval: Int) -> String {
        let minutes = interval / 60
        return "\(minutes) minutes"
    }
}

#Preview {
    SettingsView()
}

