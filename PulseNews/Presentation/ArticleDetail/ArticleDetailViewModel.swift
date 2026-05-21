//
//  ArticleDetailViewModel.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import Foundation

@MainActor
final class ArticleDetailViewModel: ObservableObject {

    @Published var isBookmarked = false
    @Published var errorMessage: String?

    let article: Article

    private let bookmarkArticle: BookmarkArticleUseCaseProtocol

    init(article: Article, bookmarkArticle: BookmarkArticleUseCaseProtocol) {
        self.article = article
        self.bookmarkArticle = bookmarkArticle
    }

    func onAppear(isBookmarked: Bool) {
        self.isBookmarked = isBookmarked
    }

    func toggleBookmark() async {
        let newState = !isBookmarked
        isBookmarked = newState

        do {
            try await bookmarkArticle.execute(article: article, isBookmarked: newState)
        } catch let error as DomainError {
            isBookmarked = !newState
            errorMessage = error.userMessage
        } catch {
            isBookmarked = !newState
            errorMessage = DomainError.unknown.userMessage
        }
    }
}
