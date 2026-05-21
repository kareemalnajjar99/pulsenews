//
//  SearchViewModel.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import Foundation

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var query = ""
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let searchArticles: SearchArticlesUseCaseProtocol
    private var currentPage = 1
    private var canLoadMore = true
    private var searchTask: Task<Void, Never>?

    init(searchArticles: SearchArticlesUseCaseProtocol) {
        self.searchArticles = searchArticles
    }

    func onQueryChanged() {
        searchTask?.cancel()
        guard query.count >= 3 else {
            articles = []
            errorMessage = nil
            return
        }
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled else { return }
            await search(reset: true)
        }
    }

    func onArticleAppeared(_ article: Article) async {
        guard let last = articles.last, last.id == article.id, canLoadMore, !isLoading else { return }
        await search(reset: false)
    }

    private func search(reset: Bool) async {
        guard !isLoading else { return }

        if reset {
            currentPage = 1
            canLoadMore = true
        }

        isLoading = true
        errorMessage = nil

        do {
            let results = try await searchArticles.execute(query: query, page: currentPage)

            if reset {
                articles = results
            } else {
                articles.append(contentsOf: results)
            }

            canLoadMore = !results.isEmpty
            currentPage += 1
        } catch let error as DomainError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = DomainError.unknown.userMessage
        }

        isLoading = false
    }
}
