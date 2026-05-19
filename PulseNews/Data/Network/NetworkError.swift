//
//  NetworkError.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

enum NetworkError: Error, Equatable, Sendable {
    case noConnectivity
    case timeout
    case httpError(statusCode: Int)
    case decodingFailed(reason: String)
    case invalidURL
    case underlying(Error)

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.noConnectivity, .noConnectivity):               return true
        case (.timeout, .timeout):                             return true
        case (.httpError(let a), .httpError(let b)):           return a == b
        case (.decodingFailed(let a), .decodingFailed(let b)): return a == b
        case (.invalidURL, .invalidURL):                       return true
        default:                                               return false
        }
    }

    var asDomainError: DomainError {
        switch self {
        case .noConnectivity:       return .noConnectivity
        case .timeout:              return .timeout
        case .httpError(let code):  return .serverError(statusCode: code)
        case .decodingFailed:       return .decodingFailed
        case .invalidURL:           return .unknown
        case .underlying:           return .unknown
        }
    }
}
