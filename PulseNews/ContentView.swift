//
//  ContentView.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.diContainer) private var container

    var body: some View {
        TabView {
            Tab(String(localized: "Feed"), systemImage: "newspaper") {
                FeedView(
                    viewModel: FeedViewModel(
                        fetchHeadlines: container.news.makeFetchTopHeadlinesUseCase()
                    )
                )
            }

            Tab(String(localized: "Search"), systemImage: "magnifyingglass") {
                SearchView(
                    viewModel: SearchViewModel(
                        searchArticles: container.news.makeSearchArticlesUseCase()
                    )
                )
            }

            Tab(String(localized: "Bookmarks"), systemImage: "bookmark") {
                BookmarksView(
                    viewModel: BookmarksViewModel(
                        getBookmarks: container.bookmark.makeGetBookmarksUseCase(),
                        bookmarkArticle: container.bookmark.makeBookmarkArticleUseCase()
                    )
                )
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.diContainer, DIContainer.shared)
}
