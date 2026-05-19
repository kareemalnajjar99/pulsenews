//
//  APIConfig.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

enum APIConfig {
    static let timeout: TimeInterval = 30
    static let baseURL: String =  "https://newsapi.org"

    static var apiKey: String {
        guard let key = Bundle.main.object(
            forInfoDictionaryKey: "NEWS_API_KEY"
        ) as? String else {
            fatalError("NEWS_API_KEY not found")
        }

        return key
    }
}
