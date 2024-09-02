//
//  APIService.swift
//  WeatherApp
//
//  Created by anas amer on 26/08/2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func getJson(urlString: String, completion: @escaping (Result<Weather, NetworkError>) -> Void)
}

class NetworkService: NetworkServiceProtocol{
    static let shared = NetworkService()
    private init(){}
    func getJson(urlString:String,completion:@escaping(Result<Weather,NetworkError>) -> Void){
        guard let url = URL(string: urlString) else{
            completion(.failure(.invalidURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest){ data, response, serverError in
            guard serverError == nil else{
                completion(.failure(.serverError(serverError!.localizedDescription)))
                return
            }
            
            guard let data = data else{
                completion(.failure(.serverError("Error: Data use corrupt")))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            do{
                let decodedData = try JSONDecoder().decode(Weather.self, from: data)
                completion(.success(decodedData))
            }catch{
                completion(.failure(.serverError("Error: \(error.localizedDescription)")))
            }
        }.resume()
    }
}
