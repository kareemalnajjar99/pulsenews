//
//  FetchTopHeadlinesUseCaseTests.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

@testable import PulseNews
import Testing

struct FetchTopHeadlinesUseCaseTests {

    @Test func execute_whenRepositoryReturnsArticles_returnsArticles() async throws {
        let mockRepo = MockNewsRepository()
        mockRepo.stubHeadlines = [.preview]
        let useCase = FetchTopHeadlinesUseCase(repository: mockRepo)

        let result = try await useCase.execute(category: .general, page: 1)

        #expect(result.count == 1)
        #expect(result[0].id == Article.preview.id)
    }

    @Test func execute_whenRepositoryThrows_throwsError() async {
        let mockRepo = MockNewsRepository()
        mockRepo.stubError = DomainError.noConnectivity
        let useCase = FetchTopHeadlinesUseCase(repository: mockRepo)

        await #expect(throws: DomainError.noConnectivity) {
            try await useCase.execute(category: .general, page: 1)
        }
    }

    @Test func execute_whenPageIsZero_throwsInvalidQuery() async {
        let mockRepo = MockNewsRepository()
        let useCase = FetchTopHeadlinesUseCase(repository: mockRepo)

        await #expect(throws: DomainError.invalidQuery) {
            try await useCase.execute(category: .general, page: 0)
        }
    }

    @Test func execute_whenPageIsNegative_throwsInvalidQuery() async {
        let mockRepo = MockNewsRepository()
        let useCase = FetchTopHeadlinesUseCase(repository: mockRepo)

        await #expect(throws: DomainError.invalidQuery) {
            try await useCase.execute(category: .general, page: -1)
        }
    }

    @Test func execute_whenCategoryChanges_returnsDifferentArticles() async throws {
        let mockRepo = MockNewsRepository()
        mockRepo.stubHeadlines = [Article.preview]
        let useCase = FetchTopHeadlinesUseCase(repository: mockRepo)

        let general = try await useCase.execute(category: .general, page: 1)
        let tech = try await useCase.execute(category: .technology, page: 1)

        #expect(general.count == tech.count)
    }
}
