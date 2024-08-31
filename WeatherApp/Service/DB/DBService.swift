//
//  DBService.swift
//  WeatherApp
//
//  Created by anas amer on 30/08/2024.
//

import Foundation

protocol LocalStorageServiceProtocol {
    func save<T: Codable>(data: T, forKey key: String) -> Bool 
    func load<T: Codable>(forKey key: String, as type: T.Type) -> T?
}
class LocalStorageService:LocalStorageServiceProtocol{
    
    static let shared = LocalStorageService()
    private init(){
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    private let fileManager = FileManager.default
    private let documentsDirectory: URL
    
    func save<T: Codable>(data: T, forKey key: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent("\(key).json")
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            try jsonData.write(to: fileURL)
            print("Data saved successfully at \(fileURL)")
            return true
        } catch {
            print("Error saving data: \(error.localizedDescription)")
            return false
        }
    }
    
    func load<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        let fileURL = documentsDirectory.appendingPathComponent("\(key).json")
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            print("No data found at \(fileURL)")
            return nil
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedData
        } catch {
            print("Error loading data: \(error.localizedDescription)")
            return nil
        }
    }
}
