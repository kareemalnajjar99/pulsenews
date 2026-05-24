//
//  MockNewsRepository.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

@testable import PulseNews
import Foundation

final class MockNewsRepository: @unchecked Sendable, NewsRepositoryProtocol {

    var stubHeadlines: [Article] = []
    var stubSearchResults: [Article] = []
    var stubError: Error?

    func fetchTopHeadlines(category: NewsCategory, page: Int) async throws -> [Article] {
        if let error = stubError {
            throw error
        }
        return stubHeadlines
    }

    func searchArticles(query: String, page: Int) async throws -> [Article] {
        if let error = stubError {
            throw error
        }
        return stubSearchResults
    }
}
