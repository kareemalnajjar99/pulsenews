//
//  BookmarkArticleUseCase.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

protocol BookmarkArticleUseCaseProtocol: Sendable {
    func execute(article: Article, isBookmarked: Bool) async throws
}

final class BookmarkArticleUseCase: BookmarkArticleUseCaseProtocol {
    private let repository: BookmarkRepositoryProtocol
    
    init(repository: BookmarkRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(article: Article, isBookmarked: Bool) async throws {
        if isBookmarked {
            try await repository.bookmark(article)
        } else {
            try await repository.removeBookmark(article)
        }
    }
}
