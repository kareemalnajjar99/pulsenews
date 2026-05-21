//
//  NewsDIContainer.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

final class NewsDIContainer {

    private let apiClient: APIClientProtocol
    private let coreDataStack: CoreDataStack

    private lazy var repository: NewsRepositoryProtocol = NewsRepository(
        apiClient: apiClient,
        coreDataStack: coreDataStack
    )

    init(apiClient: APIClientProtocol, coreDataStack: CoreDataStack) {
        self.apiClient = apiClient
        self.coreDataStack = coreDataStack
    }

    func makeFetchTopHeadlinesUseCase() -> FetchTopHeadlinesUseCaseProtocol {
        FetchTopHeadlinesUseCase(repository: repository)
    }

    func makeSearchArticlesUseCase() -> SearchArticlesUseCaseProtocol {
        SearchArticlesUseCase(repository: repository)
    }
}
