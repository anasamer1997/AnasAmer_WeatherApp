//
//  FileHelper.swift
//  WeatherApp
//
//  Created by anas amer on 31/08/2024.
//

import Foundation

class JsonLoader{
    static let shared = JsonLoader()
    private init(){}
    
    func loadJson<T:Codable>(filename fileName: String,_ type:T.Type) -> T? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
