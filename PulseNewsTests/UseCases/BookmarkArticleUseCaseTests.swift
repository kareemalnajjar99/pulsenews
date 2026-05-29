//
//  BookmarkArticleUseCaseTests.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 22/05/2026.
//

@testable import PulseNews
import Testing

struct BookmarkArticleUseCaseTests {

    @Test func execute_whenBookmarking_callsBookmarkOnRepository() async throws {
        let mockRepo = MockBookmarkRepository()
        let useCase = BookmarkArticleUseCase(repository: mockRepo)

        try await useCase.execute(article: .preview, isBookmarked: true)

        #expect(mockRepo.bookmarkCallCount == 1)
        #expect(mockRepo.removeBookmarkCallCount == 0)
        #expect(mockRepo.capturedArticle?.id == Article.preview.id)
    }

    @Test func execute_whenRemoving_callsRemoveOnRepository() async throws {
        let mockRepo = MockBookmarkRepository()
        let useCase = BookmarkArticleUseCase(repository: mockRepo)

        try await useCase.execute(article: .preview, isBookmarked: false)

        #expect(mockRepo.removeBookmarkCallCount == 1)
        #expect(mockRepo.bookmarkCallCount == 0)
        #expect(mockRepo.capturedArticle?.id == Article.preview.id)
    }

    @Test func execute_whenBookmarkThrows_throwsError() async {
        let mockRepo = MockBookmarkRepository()
        mockRepo.stubError = DomainError.persistenceFailed(reason: "test")
        let useCase = BookmarkArticleUseCase(repository: mockRepo)

        await #expect(throws: DomainError.persistenceFailed(reason: "test")) {
            try await useCase.execute(article: .preview, isBookmarked: true)
        }

        #expect(mockRepo.bookmarkCallCount == 0)
    }

    @Test func execute_whenRemoveThrows_throwsError() async {
        let mockRepo = MockBookmarkRepository()
        mockRepo.stubError = DomainError.persistenceFailed(reason: "test")
        let useCase = BookmarkArticleUseCase(repository: mockRepo)

        await #expect(throws: DomainError.persistenceFailed(reason: "test")) {
            try await useCase.execute(article: .preview, isBookmarked: false)
        }

        #expect(mockRepo.removeBookmarkCallCount == 0)
    }
}
