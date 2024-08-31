//
//  WeatherCodeIcon.swift
//  WeatherApp
//
//  Created by anas amer on 31/08/2024.
//
import Foundation

// MARK: - WeatherCodeIconValue
struct WeatherCodeIcon:Codable {
    let day, night: Day
}

// MARK: - Day
struct Day:Codable {
    let description: String
    let image: String
}
