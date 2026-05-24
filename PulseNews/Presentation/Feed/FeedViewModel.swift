//
//  FeedViewModel.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import Observation

@Observable
@MainActor
final class FeedViewModel {

    var articles: [Article] = []
    var isLoading = false
    var errorMessage: String?
    var selectedCategory: NewsCategory = .general

    private let fetchHeadlines: FetchTopHeadlinesUseCaseProtocol
    private var currentPage = 1
    private var canLoadMore = true

    init(fetchHeadlines: FetchTopHeadlinesUseCaseProtocol) {
        self.fetchHeadlines = fetchHeadlines
    }

    func onAppear() async {
        await loadArticles(reset: true)
    }

    func onCategoryChanged() async {
        await loadArticles(reset: true)
    }

    func onArticleAppeared(_ article: Article) async {
        guard let last = articles.last, last.id == article.id, canLoadMore, !isLoading else { return }
        await loadArticles(reset: false)
    }

    func onRefresh() async {
        await loadArticles(reset: true)
    }

    private func loadArticles(reset: Bool) async {
        guard !isLoading else { return }

        if reset {
            currentPage = 1
            canLoadMore = true
        }

        isLoading = true
        errorMessage = nil

        do {
            let fetched = try await fetchHeadlines.execute(category: selectedCategory, page: currentPage)

            if reset {
                articles = fetched
            } else {
                articles.append(contentsOf: fetched)
            }

            canLoadMore = !fetched.isEmpty
            currentPage += 1
        } catch let error as DomainError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = DomainError.unknown.userMessage
        }

        isLoading = false
    }
}
