//
//  EndPoint.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }

    func makeRequest() -> URLRequest?
}

extension Endpoint {
    var method: HTTPMethod { .get }

    func makeRequest() -> URLRequest? {
        var components = URLComponents(string: APIConfig.baseURL)
        components?.path = path
        components?.queryItems = queryItems + [
            URLQueryItem(name: "apiKey", value: APIConfig.apiKey)
        ]

        guard let url = components?.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30

        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
