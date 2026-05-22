//
//  ArticleDetailView.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import SwiftUI

struct ArticleDetailView: View {

    @StateObject private var viewModel: ArticleDetailViewModel
    @Environment(\.openURL) private var openURL

    init(viewModel: ArticleDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageURL = viewModel.article.imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(16/9, contentMode: .fill)
                        default:
                            Rectangle()
                                .fill(.quaternary)
                                .frame(height: 220)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipped()
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.article.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack {
                        Text(viewModel.article.byline)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(viewModel.article.publishedAgo)
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                    }

                    Divider()

                    if let description = viewModel.article.description {
                        Text(description)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }

                    if let content = viewModel.article.content {
                        Text(content)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    Button {
                        openURL(viewModel.article.url)
                    } label: {
                        Label(String(localized: "Read Full Article"), systemImage: "safari")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await viewModel.toggleBookmark() }
                } label: {
                    Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                        .symbolEffect(.bounce, value: viewModel.isBookmarked)
                }
            }
        }
        .alert(
            String(localized: "Error"),
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button(String(localized: "OK"), role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .task { await viewModel.load() }
    }
}

#Preview {
    NavigationStack {
        ArticleDetailView(
            viewModel: ArticleDetailViewModel(
                article: .preview,
                bookmarkArticleUseCase: PreviewBookmarkArticleUseCase(),
                isBookmarkedUseCase: PreviewBookmarkStateUseCase()
            )
        )
    }
}

private final class PreviewBookmarkArticleUseCase: BookmarkArticleUseCaseProtocol {
    func execute(article: Article, isBookmarked: Bool) async throws {}
}

private final class PreviewBookmarkStateUseCase: IsBookmarkedUseCaseProtocol {
    func execute(article: Article) async throws -> Bool { return true }
}
