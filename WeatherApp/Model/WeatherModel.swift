//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by anas amer on 26/08/2024.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    var hourly: Hourly
}

// MARK: - Hourly
struct Hourly: Codable {
    var time: [String]
    var temperature2M: [Double]
    let weatherCode:[Int]
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case weatherCode = "weather_code"
    }
}
extension Hourly{
     func formatDate() -> [String] {
        let dateFormat = DateFormatter()
        
        // Format the dates
        let formattedDates = time.map { dateString in
            dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm"
            if let date = dateFormat.date(from: dateString) {
                dateFormat.dateFormat = "d MMMM yyyy"
                return dateFormat.string(from: date)
            } else {
                return "Invalid date: \(dateString)"
            }
        }
        return formattedDates
    }
    
    
}
