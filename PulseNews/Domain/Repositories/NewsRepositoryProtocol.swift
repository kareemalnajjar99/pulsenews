//
//  NewsRepositoryProtocol.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

protocol NewsRepositoryProtocol: Sendable {
    func fetchTopHeadlines(category: NewsCategory, page: Int) async throws -> [Article]
    func searchArticles(query: String, page: Int) async throws -> [Article]
}
