//
//  Handler.swift
//  WeatherApp
//
//  Created by anas amer on 30/08/2024.
//

import Foundation

class NetworkHandler {
    
    static let shared = NetworkHandler()
    
    private let networkService: NetworkServiceProtocol
//    private let localStorageService: LocalStorageServiceProtocol
    private let coreDataStorageService: CoreDataStorageService
    
    private init() {
        self.networkService = NetworkService.shared
//        self.localStorageService = LocalStorageService.shared
        self.coreDataStorageService = CoreDataStorageService.shared
    }
    
    func fetchAndStoreData(urlString: String, completion: @escaping (Result<Weather, NetworkError>) -> Void) {
        
        // Fetch data from network
        networkService.getJson(urlString: urlString) { result in
            switch result {
            case .success(let data):
                self.coreDataStorageService.saveWeatherFromLocalStorage(data.hourly)
                completion(.success(data))
            case .failure(let error):
                // If network call fails, try to load data from local storage
                completion(.failure(.serverError("Network request failed with error: \(error)")))
            }
        }
    }
}
