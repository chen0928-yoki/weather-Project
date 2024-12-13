//
//  AboutView.swift
//  weather
//
//  Created by Qianyu Chen on 2024/12/9.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var tapCount = 0
    @State private var currentImage = "me"
    
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
                CustomNavigationBar(title: "About")
                
                VStack(alignment: .center, spacing: 26) {
                    ZStack(alignment: .topTrailing) {
                        Image(currentImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color("textPrimary"), lineWidth: 2)
                            )
                            .onTapGesture {
                                tapCount += 1
                                
                                if tapCount >= 3 {
                                    currentImage = currentImage == "me" ? "justin_bieber" : "me"
                                    tapCount = 0
                                }
                            }
                        
                        Image(systemName: colorScheme == .dark ? "moon.stars" : "sun.max")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.yellow)
                            .offset(x: 0, y: -12)
                    }
                    .padding(.bottom, 10)
                    
                    Text("Weather")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("textPrimary"))
                        .padding(.top, 30)
                    
                    Text("Version 1.0")
                        .font(.subheadline)
                        .foregroundColor(Color("textSecondary"))
                    
                    Text("Created by Qianyu Chen")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .bold()
                        .foregroundColor(Color("textPrimary"))
                    
                    Text("chen0928@algonquinlive.com")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color.accentColor)
                    
                    Spacer()
                }
                .padding(.top,80)
                .padding(.horizontal, 20)
                
                
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    AboutView()
}

