//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by anas amer on 26/08/2024.
//

import SwiftUI

@main
struct WeatherApp: App {
    @State private var networkMonitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            splashView()
                .environmentObject(networkMonitor)
        }
    }
}
