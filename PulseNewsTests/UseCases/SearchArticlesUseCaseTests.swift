//
//  SearchArticlesUseCaseTests.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 29/05/2026.
//

@testable import PulseNews
import Testing

struct SearchArticlesUseCaseTests {

    @Test func execute_whenQueryIsValid_returnsArticles() async throws {
        let mockRepo = MockNewsRepository()
        mockRepo.stubSearchResults = [.preview]
        let useCase = SearchArticlesUseCase(repository: mockRepo)

        let result = try await useCase.execute(query: "Apple", page: 1)

        #expect(result.count == 1)
        #expect(result[0].id == Article.preview.id)
    }

    @Test func execute_whenQueryHasWhitespace_trimsQuery() async throws {
        let mockRepo = MockNewsRepository()
        mockRepo.stubSearchResults = [.preview]
        let useCase = SearchArticlesUseCase(repository: mockRepo)

        let result = try await useCase.execute(query: "  Apple  ", page: 1)

        #expect(result.count == 1)
    }

    @Test func execute_whenQueryIsTooShort_throwsInvalidQuery() async {
        let mockRepo = MockNewsRepository()
        let useCase = SearchArticlesUseCase(repository: mockRepo)

        await #expect(throws: DomainError.invalidQuery) {
            try await useCase.execute(query: "ab", page: 1)
        }
    }

    @Test func execute_whenQueryIsEmpty_throwsInvalidQuery() async {
        let mockRepo = MockNewsRepository()
        let useCase = SearchArticlesUseCase(repository: mockRepo)

        await #expect(throws: DomainError.invalidQuery) {
            try await useCase.execute(query: "", page: 1)
        }
    }

    @Test func execute_whenQueryIsOnlyWhitespace_throwsInvalidQuery() async {
        let mockRepo = MockNewsRepository()
        let useCase = SearchArticlesUseCase(repository: mockRepo)

        await #expect(throws: DomainError.invalidQuery) {
            try await useCase.execute(query: "   ", page: 1)
        }
    }

    @Test func execute_whenPageIsZero_throwsInvalidQuery() async {
        let mockRepo = MockNewsRepository()
        let useCase = SearchArticlesUseCase(repository: mockRepo)

        await #expect(throws: DomainError.invalidQuery) {
            try await useCase.execute(query: "Apple", page: 0)
        }
    }

    @Test func execute_whenPageIsNegative_throwsInvalidQuery() async {
        let mockRepo = MockNewsRepository()
        let useCase = SearchArticlesUseCase(repository: mockRepo)

        await #expect(throws: DomainError.invalidQuery) {
            try await useCase.execute(query: "Apple", page: -1)
        }
    }

    @Test func execute_whenRepositoryThrows_throwsError() async {
        let mockRepo = MockNewsRepository()
        mockRepo.stubError = DomainError.noConnectivity
        let useCase = SearchArticlesUseCase(repository: mockRepo)

        await #expect(throws: DomainError.noConnectivity) {
            try await useCase.execute(query: "Apple", page: 1)
        }
    }
}
