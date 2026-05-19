//
//  NewsAPI.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

enum NewsAPI {
    case topHeadlines(category: NewsCategory, page: Int)
    case search(query: String, page: Int)
}

extension NewsAPI: Endpoint {

    private var pageSize: Int { 20 }

    var path: String {
        switch self {
        case .topHeadlines:
            return "/v2/top-headlines"

        case .search:
            return "/v2/everything"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {

        case .topHeadlines(let category, let page):
            return [
                .init(name: "category", value: category.rawValue),
                .init(name: "country", value: "us"),
                .init(name: "page", value: "\(page)"),
                .init(name: "pageSize", value: "\(pageSize)")
            ]

        case .search(let query, let page):
            return [
                .init(name: "q", value: query),
                .init(name: "sortBy", value: "publishedAt"),
                .init(name: "page", value: "\(page)"),
                .init(name: "pageSize", value: "\(pageSize)")
            ]
        }
    }
}
