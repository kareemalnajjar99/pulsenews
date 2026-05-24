//
//  SearchView.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//


import SwiftUI

struct SearchView: View {

    @State private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    SkeletonLoadingView()
                } else if let error = viewModel.errorMessage {
                    ErrorStateView(message: error) {
                        viewModel.onQueryChanged()
                    }
                } else if viewModel.articles.isEmpty && viewModel.query.count >= 3 {
                    ContentUnavailableView.search(text: viewModel.query)
                } else if viewModel.query.count < 3 {
                    emptyPrompt
                } else {
                    resultsList
                }
            }
            .navigationTitle(String(localized: "Search"))
            .searchable(text: $viewModel.query, prompt: String(localized: "Search articles..."))
            .onChange(of: viewModel.query) { viewModel.onQueryChanged() }
        }
    }

    private var resultsList: some View {
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
                    ProgressView().padding()
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }

    private var emptyPrompt: some View {
        ContentUnavailableView {
            Label(String(localized: "Search Articles"), systemImage: "magnifyingglass")
        } description: {
            Text(String(localized: "Type at least 3 characters to search."))
        }
    }
}

#Preview {
    SearchView(
        viewModel: SearchViewModel(
            searchArticles: PreviewSearchArticlesUseCase()
        )
    )
}

private final class PreviewSearchArticlesUseCase: SearchArticlesUseCaseProtocol {
    func execute(query: String, page: Int) async throws -> [Article] {
        Article.previews
    }
}
