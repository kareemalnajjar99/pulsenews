//
//  BookmarkDIContainer.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

final class BookmarkDIContainer {

    private let coreDataStack: CoreDataStack

    private lazy var repository: BookmarkRepositoryProtocol = BookmarkRepository(
        coreDataStack: coreDataStack
    )

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func makeBookmarkArticleUseCase() -> BookmarkArticleUseCaseProtocol {
        BookmarkArticleUseCase(repository: repository)
    }

    func makeGetBookmarksUseCase() -> GetBookmarksUseCaseProtocol {
        GetBookmarksUseCase(repository: repository)
    }
}
