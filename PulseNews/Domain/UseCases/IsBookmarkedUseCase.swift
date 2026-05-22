//
//  IsBookmarkedUseCase.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import Foundation

protocol IsBookmarkedUseCaseProtocol: Sendable {
    func execute(article: Article) async throws -> Bool
}

final class IsBookmarkedUseCase: IsBookmarkedUseCaseProtocol {
    private let repository: BookmarkRepositoryProtocol

    init(repository: BookmarkRepositoryProtocol) {
        self.repository = repository
    }

    func execute(article: Article) async throws -> Bool {
        try await repository.isBookmarked(article)
    }
}
