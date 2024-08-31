//
//  WeatherRowItem.swift
//  WeatherApp
//
//  Created by anas amer on 27/08/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct WeatherRowItem: View {
    let time,temperature2M,icon:String
    let unit:Int
    var body: some View {
        HStack {
            VStack(alignment:.leading){
                Text("Time: \(time)")
                Text("Temperature: \(temperature2M)\(unit == 0 ? "°C": "°F" )")
                
            }
            .frame(maxWidth: .infinity,alignment:.leading)
            Spacer()
            HStack{
                if !icon.isEmpty {
                    WebImage(url: URL(string: icon)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60,height: 100)
                    } placeholder: {
                           ProgressView()
                    }
                }
            }
        }.padding(.horizontal)
    }
}

#Preview {
    WeatherRowItem(time: "29-3-3021", temperature2M: "32f", icon: "http://openweathermap.org/img/wn/01n@2x.png", unit: 0)
}
