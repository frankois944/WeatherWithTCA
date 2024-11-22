//
//  eatherContent.swift
//  MySampleTCA
//
//  Created by Francois Dabonot on 22/11/2024.
//

import SwiftUI
import Foundation

struct WeatherContent: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var weatherData: WeatherResponse // Assume this is the decoded model
    
    @State private var iconOpacity: Double = 0
    @State private var iconScale: CGFloat = 0.5
    @State private var detailsOffset: [CGFloat] = [50, 50, 50, 50]
    @State private var detailsOpacity: [Double] = [0, 0, 0, 0]
    @State private var gradientShift: Bool = false
    
    var body: some View {
        ZStack {
            // Background Gradient with Bottom Fade for Tab Bar Readability
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: gradientShift ? Color.blue : Color.purple.opacity(0.5), location: 0),
                    .init(color: Color.white.opacity(0.3), location: 0.8),
                    .init(color: Color(.systemBackground), location: 1.0) // Fades into solid background
                ]),
                startPoint: .topLeading,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .animation(Animation.linear(duration: 6).repeatForever(autoreverses: true), value: gradientShift)
            .onAppear {
                gradientShift.toggle()
            }
            
            VStack(spacing: 20) {
                // Location Name
                Text(weatherData.name)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .opacity(iconOpacity)
                    .animation(Animation.easeIn(duration: 1.2), value: iconOpacity)
                
                // Weather Icon and Temperature
                VStack(spacing: 10) {
                    Image(systemName: symbolForWeather(id: weatherData.weather.first?.id ?? 0))
                        .font(.system(size: 80))
                        .foregroundColor(.accentColor)
                        .opacity(iconOpacity)
                        .scaleEffect(iconScale)
                        .animation(Animation.spring(response: 0.8, dampingFraction: 0.6), value: iconScale)
                    
                    Text("\(Int(weatherData.main.temp))°C")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.primary)
                        .opacity(iconOpacity)
                        .animation(Animation.easeIn(duration: 1.2).delay(0.3), value: iconOpacity)
                    
                    Text(weatherData.weather.first?.description.capitalized ?? "Unknown")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .opacity(iconOpacity)
                        .animation(Animation.easeIn(duration: 1.2).delay(0.5), value: iconOpacity)
                }
                Spacer()
                // Weather Details Card with Staggered Animation
                VStack(spacing: 15) {
                    WeatherDetailRow(icon: "thermometer.snowflake", label: "Feels Like", value: "\(Int(weatherData.main.feelsLike))°C")
                        .offset(y: detailsOffset[0])
                        .opacity(detailsOpacity[0])
                        .animation(Animation.easeOut(duration: 0.8).delay(0.3), value: detailsOpacity[0])
                    
                    WeatherDetailRow(icon: "humidity.fill", label: "Humidity", value: "\(weatherData.main.humidity)%")
                        .offset(y: detailsOffset[1])
                        .opacity(detailsOpacity[1])
                        .animation(Animation.easeOut(duration: 0.8).delay(0.5), value: detailsOpacity[1])
                    
                    WeatherDetailRow(icon: "wind", label: "Wind", value: "\(Int(weatherData.wind.speed)) km/h")
                        .offset(y: detailsOffset[2])
                        .opacity(detailsOpacity[2])
                        .animation(Animation.easeOut(duration: 0.8).delay(0.7), value: detailsOpacity[2])
                    
                    WeatherDetailRow(icon: "cloud.fill", label: "Cloudiness", value: "\(weatherData.clouds.all)%")
                        .offset(y: detailsOffset[3])
                        .opacity(detailsOpacity[3])
                        .animation(Animation.easeOut(duration: 0.8).delay(0.9), value: detailsOpacity[3])
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 40)
            .onAppear {
                // Start animations
                iconOpacity = 1
                iconScale = 1
                detailsOffset = [0, 0, 0, 0]
                detailsOpacity = [1, 1, 1, 1]
            }
        }
    }
    
    // Helper to map weather ID to SF Symbol
    func symbolForWeather(id: Int) -> String {
        switch id {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "cloud.fog.fill"
        case 800: return "sun.max.fill"
        case 801...804: return "cloud.fill"
        default: return "questionmark.circle.fill"
        }
    }
}

struct WeatherDetailRow: View {
    var icon: String
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
                .frame(width: 30)
            Text(label)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
                .bold()
                .foregroundColor(.primary)
        }
    }
}
