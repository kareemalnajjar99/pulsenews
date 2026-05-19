//
//  Article.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

struct Article: Identifiable, Equatable, Hashable, Sendable {
    let id: String
    let title: String
    let description: String?
    let content: String?
    let author: String?
    let sourceName: String
    let url: URL
    let imageURL: URL?
    let publishedAt: Date
    let category: NewsCategory
    
    var byline: String {
        author ?? sourceName
    }
    
    var hasImage: Bool {
        imageURL != nil
    }
    
    var publishedAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: publishedAt, relativeTo: .now)
    }
}

// MARK: - Article + Preview

#if DEBUG
extension Article {
    
    /// A sample article for use in SwiftUI previews and unit tests.
    static let preview = Article(
        id: "preview-001",
        title: "Apple Unveils iOS 26 with Liquid Glass Design",
        description: "At WWDC 2025, Apple introduced a sweeping visual redesign across all platforms using a new material called Liquid Glass.",
        content: "The new design language unifies iOS, iPadOS, macOS, watchOS, and tvOS under a single translucent aesthetic...",
        author: "John Appleseed",
        sourceName: "TechCrunch",
        url: URL(string: "https://techcrunch.com/ios-26")!,
        imageURL: URL(string: "https://picsum.photos/seed/article1/800/450")!,
        publishedAt: Date(),
        category: .technology
    )
    
    /// A collection of sample articles for list previews.
    static let previews: [Article] = [
        preview,
        Article(
            id: "preview-002",
            title: "Swift 6.2 Brings Strict Concurrency Improvements",
            description: "The latest Swift release makes data-race safety easier with new default actor isolation settings.",
            content: nil,
            author: nil,
            sourceName: "Swift.org",
            url: URL(string: "https://swift.org/blog/swift-6-2")!,
            imageURL: URL(string: "https://picsum.photos/seed/article2/800/450")!,
            publishedAt: Date().addingTimeInterval(-3600),
            category: .technology
        ),
        Article(
            id: "preview-003",
            title: "Global Markets React to Fed Rate Decision",
            description: "Stocks edged higher after the Federal Reserve held interest rates steady for the third consecutive meeting.",
            content: nil,
            author: "Jane Smith",
            sourceName: "Reuters",
            url: URL(string: "https://reuters.com/markets/fed-rate")!,
            imageURL: nil,
            publishedAt: Date().addingTimeInterval(-7200),
            category: .business
        )
    ]
}
#endif
