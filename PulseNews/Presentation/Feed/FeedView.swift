//
//  FeedView.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import SwiftUI

struct FeedView: View {

    @State private var viewModel: FeedViewModel
    @Namespace private var namespace

    init(viewModel: FeedViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    SkeletonLoadingView()
                } else if let error = viewModel.errorMessage, viewModel.articles.isEmpty {
                    ErrorStateView(message: error) {
                        Task { await viewModel.onRefresh() }
                    }
                } else {
                    articleList
                }
            }
            .navigationTitle(String(localized: "Top Headlines"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    categoryMenu
                }
            }
        }
        .task { await viewModel.onAppear() }
    }

    private var articleList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.articles) { article in
                    NavigationLink {
                        ArticleDetailView(
                            viewModel: ArticleDetailViewModel(
                                article: article,
                                bookmarkArticleUseCase: DIContainer.shared.bookmark.makeBookmarkArticleUseCase(),
                                isBookmarkedUseCase: DIContainer.shared.bookmark.makeIsBookmarkedUseCase()
                            )
                        )
                    } label: {
                        ArticleCardView(article: article)
                            .onAppear {
                                Task { await viewModel.onArticleAppeared(article) }
                            }
                    }
                    .buttonStyle(.plain)
                }

                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .refreshable { await viewModel.onRefresh() }
    }

    private var categoryMenu: some View {
        Menu {
            ForEach(NewsCategory.allCases) { category in
                Button {
                    viewModel.selectedCategory = category
                    Task { await viewModel.onCategoryChanged() }
                } label: {
                    Label(category.displayName, systemImage: category.symbolName)
                }
            }
        } label: {
            Image(systemName: viewModel.selectedCategory.symbolName)
        }
    }
}

#Preview {
    FeedView(
        viewModel: FeedViewModel(
            fetchHeadlines: PreviewFetchTopHeadlinesUseCase()
        )
    )
}

private final class PreviewFetchTopHeadlinesUseCase: FetchTopHeadlinesUseCaseProtocol {
    func execute(category: NewsCategory, page: Int) async throws -> [Article] {
        Article.previews
    }
}
