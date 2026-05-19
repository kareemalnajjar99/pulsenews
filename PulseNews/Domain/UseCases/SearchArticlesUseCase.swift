//
//  SearchArticlesUseCase.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

protocol SearchArticlesUseCaseProtocol: Sendable {
    func execute(query: String, page: Int) async throws -> [Article]
}

final class SearchArticlesUseCase: SearchArticlesUseCaseProtocol {
    private let repository: NewsRepositoryProtocol
    
    private let minimumQueryLength = 3
    
    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String, page: Int) async throws -> [Article] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmed.count >= minimumQueryLength else {
            throw DomainError.invalidQuery
        }

        guard page > 0 else {
            throw DomainError.invalidQuery
        }

        return try await repository.searchArticles(query: trimmed, page: page)
    }
}
