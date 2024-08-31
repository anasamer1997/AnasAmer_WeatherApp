//
//  double+Ext.swift
//  WeatherApp
//
//  Created by anas amer on 30/08/2024.
//

import Foundation
extension Double {
    func toFahrenheit() -> Double {
        return (self * 9/5) + 32
    }
    
    func toCelsius() -> Double {
        return (self - 32) * 5/9
    }
    func rounded(toDecimalPlaces decimalPlaces: Int) -> Double {
        let factor = pow(10.0, Double(decimalPlaces))
        return (self * factor).rounded() / factor
    }
}
