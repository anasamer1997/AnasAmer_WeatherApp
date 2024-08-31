//
//  LoadingView.swift
//  WeatherApp
//
//  Created by anas amer on 31/08/2024.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            Color.white
                .opacity(0.3)
                .ignoresSafeArea()
            
            ProgressView("Loading...")
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                )
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
    }
}
