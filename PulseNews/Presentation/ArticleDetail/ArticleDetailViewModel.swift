//
//  ArticleDetailViewModel 2.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 22/05/2026.
//


import Foundation

@MainActor
final class ArticleDetailViewModel: ObservableObject {
    
    @Published var isBookmarked = false
    @Published var errorMessage: String?
    
    let article: Article
    
    private let bookmarkArticleUseCase: BookmarkArticleUseCaseProtocol
    private let isBookmarkedUseCase: IsBookmarkedUseCaseProtocol
    
    init(
        article: Article,
        bookmarkArticleUseCase: BookmarkArticleUseCaseProtocol,
        isBookmarkedUseCase: IsBookmarkedUseCaseProtocol
    ) {
        self.article = article
        self.bookmarkArticleUseCase = bookmarkArticleUseCase
        self.isBookmarkedUseCase = isBookmarkedUseCase
    }
    
    func load() async {
        await loadBookmarkState()
    }
    
    func toggleBookmark() async {
        let newState = !isBookmarked
        isBookmarked = newState
        
        do {
            try await bookmarkArticleUseCase.execute(
                article: article,
                isBookmarked: newState
            )
            
        } catch let error as DomainError {
            isBookmarked = !newState
            errorMessage = error.userMessage
            
        } catch {
            isBookmarked = !newState
            errorMessage = DomainError.unknown.userMessage
        }
    }
    
    private func loadBookmarkState() async {
        do {
            isBookmarked = try await isBookmarkedUseCase.execute(
                article: article
            )
        } catch {
            isBookmarked = false
        }
    }
}
