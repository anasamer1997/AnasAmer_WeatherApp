//
//  DBService.swift
//  WeatherApp
//
//  Created by anas amer on 30/08/2024.
//

import Foundation
import CoreData


protocol CoreDataStorageServiceProtocol {
    func saveWeatherFromLocalStorage(_ weather: Hourly)
    func loadWeatherInLocalStorage() -> Hourly?
}

protocol LocalStorageServiceProtocol {
    func save<T: Codable>(data: T, forKey key: String) -> Bool
    func load<T: Codable>(forKey key: String, as type: T.Type) -> T?
}

class CoreDataStorageService: CoreDataStorageServiceProtocol {
    
    static let shared = CoreDataStorageService()
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HourlyCoreData") // Replace with your Core Data model name
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    
    func saveWeatherFromLocalStorage(_ weather: Hourly) {
        let request: NSFetchRequest<HourlyEntity> = HourlyEntity.fetchRequest()
        do {
            let results = try context.fetch(request)
            let hourlyEntity = results.first ?? HourlyEntity(context: context)
            
            hourlyEntity.time = weather.time as NSObject
            hourlyEntity.temperature2M = weather.temperature2M as NSObject
            hourlyEntity.weatherCode = weather.weatherCode as NSObject
            
            try context.save()
            print("Weather data saved successfully")
        } catch {
            print("Error saving weather data: \(error.localizedDescription)")
        }
    }
    
    func loadWeatherInLocalStorage() -> Hourly? {
        let request: NSFetchRequest<HourlyEntity> = HourlyEntity.fetchRequest()
        do {
            guard let result = try context.fetch(request).first else {
                print("No weather data found in local storage")
                return nil
            }
            let weatherTime = result.time as! [String]
            let weatherTemp = result.temperature2M as! [Double]
            let weatherCode = result.weatherCode as! [Int]
            
            let hourlyModel = Hourly(time: weatherTime, temperature2M: weatherTemp, weatherCode: weatherCode)
            return hourlyModel
        } catch {
            print("Error loading weather data: \(error.localizedDescription)")
            return nil
        }
    }
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
