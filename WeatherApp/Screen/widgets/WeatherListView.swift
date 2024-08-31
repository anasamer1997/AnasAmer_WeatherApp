//
//  WeatherListView.swift
//  WeatherApp
//
//  Created by anas amer on 31/08/2024.
//

import Foundation
import SwiftUI

struct WeatherListView: View {
    @ObservedObject var vm:HomeViewModel
    var body: some View {
        LazyVStack {
            ForEach(vm.weatherTime.indices, id: \.self) { index in
                WeatherRowItem(
                    time: vm.weatherTime[index],
                    temperature2M: "\(vm.weatherTemp[index])",
                    icon: vm.getCodeIcon(vm.weatherCode[index]),
                    unit: vm.toFahrenheit
                )
                
            }
        }
    }
}
