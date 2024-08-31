//
//  Error+Extension.swift
//  WeatherApp
//
//  Created by anas amer on 30/08/2024.
//

import Foundation

enum NetworkError:Error{
    case invalidURL
    case serverError(_ errorString:String)
    case badRequest
    case decodingError(_ error:String)
    case invalidResponse
    case unknownStatusCode(Int)
}
extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
            case .badRequest:
            return "Bad Request (400): Unable to perform the request."
            case .serverError(let errorMessage):
                return errorMessage
            case .decodingError:
                return"Unable to decode successfully."
            case .invalidResponse:
                return "Invalid response."
            case .unknownStatusCode(let statusCode):
                return "Unknown error with status code: \(statusCode)."
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
