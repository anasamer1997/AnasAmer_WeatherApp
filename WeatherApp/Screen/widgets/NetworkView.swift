//
//  NetworkView.swift
//  WeatherApp
//
//  Created by anas amer on 31/08/2024.
//

import Foundation
import SwiftUI

struct NetworkView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "wifi.slash")
                .font(.title3)
                .foregroundStyle( .red)
            
            Text( "Disconnected")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.red)
        }
        .frame(height: 50)
    }
}
