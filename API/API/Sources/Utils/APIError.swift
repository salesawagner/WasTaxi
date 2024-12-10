//
//  APIError.swift
//  API
//
//  Created by Wagner Sales
//

import Foundation

public enum APIError: Error {
    case badUrl
    case unknown(error: Error, statusCode: Int)
    case invalidParam
    case invalidResponse
    case error(error: ErrorResponse)
}
