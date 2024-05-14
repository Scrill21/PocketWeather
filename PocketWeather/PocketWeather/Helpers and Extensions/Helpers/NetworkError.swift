//
//  NetworkError.swift
//  PocketWeather
//
//  Created by anthony byrd on 5/13/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case invalidResponseStatus
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid url request."
        case .invalidResponseStatus:
            return "Invalid server response"
        case .thrownError(let error):
            print(error.localizedDescription)
            return "Unable to complete your request. Please check your internet connection"
        case .noData:
            return "The data received from the server was invalid. Please try again."
        case .unableToDecode:
            return "The server responded with bad data."
        }
    }
}
