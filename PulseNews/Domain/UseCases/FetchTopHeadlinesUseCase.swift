//
//  FetchTopHeadlinesUseCase.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

protocol FetchTopHeadlinesUseCaseProtocol: Sendable {
    func execute(category: NewsCategory, page: Int) async throws -> [Article]
}

final class FetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol {
    private let repository: NewsRepositoryProtocol
    
    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(category: NewsCategory, page: Int) async throws -> [Article] {
        guard page > 0 else {
            throw DomainError.invalidQuery
        }
        return try await repository.fetchTopHeadlines(category: category, page: page)
    }
}
