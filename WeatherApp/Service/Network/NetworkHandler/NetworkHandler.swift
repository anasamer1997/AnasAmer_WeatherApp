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
    private let localStorageService: LocalStorageServiceProtocol
    
    private init() {
        self.networkService = NetworkService.shared
        self.localStorageService = LocalStorageService.shared
    }
    
    func fetchAndStoreData<T: Codable>(urlString: String, responseType: T.Type, storageKey: String?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        // Fetch data from network
        networkService.getJson(urlString: urlString, responseType: responseType) { result in
            switch result {
            case .success(let data):
                // Save data locally
                if storageKey != nil {
                    let saveSuccess = self.localStorageService.save(data: data, forKey: storageKey!)
                    if saveSuccess {
                        completion(.success(data))
                    } else {
                        completion(.failure(.serverError("Failed to save data locally.")))
                    }
                }
            case .failure(let error):
                // If network call fails, try to load data from local storage
                completion(.failure(.serverError("Network request failed with error: \(error)")))
            }
        }
    }
}
