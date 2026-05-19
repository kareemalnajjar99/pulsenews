//
//  GetBookmarksUseCase.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

protocol GetBookmarksUseCaseProtocol: Sendable {
    func execute() async throws -> [Article]
}

final class GetBookmarksUseCase: GetBookmarksUseCaseProtocol {
    private let repository: BookmarkRepositoryProtocol

    init(repository: BookmarkRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Article] {
        try await repository.fetchBookmarks()
    }
}
