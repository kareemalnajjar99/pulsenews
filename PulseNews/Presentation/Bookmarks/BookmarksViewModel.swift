//
//  BookmarksViewModel.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import Foundation

@MainActor
final class BookmarksViewModel: ObservableObject {

    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let getBookmarks: GetBookmarksUseCaseProtocol
    private let bookmarkArticle: BookmarkArticleUseCaseProtocol

    init(
        getBookmarks: GetBookmarksUseCaseProtocol,
        bookmarkArticle: BookmarkArticleUseCaseProtocol
    ) {
        self.getBookmarks = getBookmarks
        self.bookmarkArticle = bookmarkArticle
    }

    func onAppear() async {
        await fetchBookmarks()
    }

    func removeBookmark(_ article: Article) async {
        do {
            try await bookmarkArticle.execute(article: article, isBookmarked: false)
            articles.removeAll { $0.id == article.id }
        } catch let error as DomainError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = DomainError.unknown.userMessage
        }
    }

    private func fetchBookmarks() async {
        isLoading = true
        errorMessage = nil

        do {
            articles = try await getBookmarks.execute()
        } catch let error as DomainError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = DomainError.unknown.userMessage
        }

        isLoading = false
    }
}
