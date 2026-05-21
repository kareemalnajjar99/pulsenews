//
//  BookmarksView.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//


import SwiftUI

struct BookmarksView: View {

    @StateObject private var viewModel: BookmarksViewModel

    init(viewModel: BookmarksViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    SkeletonLoadingView()
                } else if let error = viewModel.errorMessage {
                    ErrorStateView(message: error) {
                        Task { await viewModel.onAppear() }
                    }
                } else if viewModel.articles.isEmpty {
                    emptyState
                } else {
                    bookmarksList
                }
            }
            .navigationTitle(String(localized: "Bookmarks"))
        }
        .task { await viewModel.onAppear() }
    }

    private var bookmarksList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.articles) { article in
                    NavigationLink {
                        ArticleDetailView(
                            viewModel: ArticleDetailViewModel(
                                article: article,
                                bookmarkArticle: DIContainer.shared.bookmark.makeBookmarkArticleUseCase()
                            )
                        )
                    } label: {
                        ArticleCardView(article: article)
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task { await viewModel.removeBookmark(article) }
                        } label: {
                            Label(String(localized: "Remove"), systemImage: "bookmark.slash")
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label(String(localized: "No Bookmarks"), systemImage: "bookmark")
        } description: {
            Text(String(localized: "Articles you bookmark will appear here."))
        }
    }
}

#Preview {
    BookmarksView(
        viewModel: BookmarksViewModel(
            getBookmarks: PreviewGetBookmarksUseCase(),
            bookmarkArticle: PreviewBookmarkArticleUseCase()
        )
    )
}

private final class PreviewGetBookmarksUseCase: GetBookmarksUseCaseProtocol {
    func execute() async throws -> [Article] { Article.previews }
}

private final class PreviewBookmarkArticleUseCase: BookmarkArticleUseCaseProtocol {
    func execute(article: Article, isBookmarked: Bool) async throws {}
}