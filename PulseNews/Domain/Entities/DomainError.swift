//
//  DomainError.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

enum DomainError: Error, Equatable, Sendable {
    /// No internet connection available.
    case noConnectivity

    /// The request timed out.
    case timeout

    /// The server returned an unexpected status code.
    case serverError(statusCode: Int)

    /// The response could not be decoded into the expected model.
    case decodingFailed

    /// A Core Data read or write operation failed.
    case persistenceFailed(reason: String)

    /// The search query was empty or too short.
    case invalidQuery

    /// An unexpected error occurred.
    case unknown

    /// Localised descriptions
    var userMessage: String {
        switch self {
        case .noConnectivity:
            return String(localized: "No internet connection. Showing cached content.")
        case .timeout:
            return String(localized: "The request timed out. Please try again.")
        case .serverError(let code):
            return String(localized: "Server error (\(code)). Please try again later.")
        case .decodingFailed:
            return String(localized: "Something went wrong loading the content.")
        case .persistenceFailed:
            return String(localized: "Could not save your data. Please try again.")
        case .invalidQuery:
            return String(localized: "Please enter at least 3 characters to search.")
        case .unknown:
            return String(localized: "An unexpected error occurred. Please try again.")
        }
    }
}
