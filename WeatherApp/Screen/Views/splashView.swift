//
//  splashView.swift
//  WeatherApp
//
//  Created by anas amer on 30/08/2024.
//

import SwiftUI

struct splashView: View {
    @EnvironmentObject private var networkMonitor :NetworkMonitor
    @State private var isActive:Bool = false
    var body: some View {
        ZStack{
            if self.isActive{
                HomeView()
            }else{
                Image("playstore")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: .infinity)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isActive.toggle()
            }
        }
    }
}

#Preview {
    splashView ()
}
