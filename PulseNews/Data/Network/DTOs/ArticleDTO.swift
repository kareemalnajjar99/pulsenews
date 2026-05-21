//
//  ArticleDTO.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

struct ArticleDTO: Decodable, Sendable {
    let title: String?
    let description: String?
    let content: String?
    let author: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let source: SourceDTO?

    struct SourceDTO: Decodable, Sendable {
        let name: String?
    }

    func toDomain(category: NewsCategory) -> Article? {
        guard
            let title,
            !title.isEmpty,
            title != "[Removed]",
            let urlString = url,
            let url = URL(string: urlString)
        else { return nil }

        let imageURL = urlToImage.flatMap { URL(string: $0) }
        let publishedDate = publishedAt.flatMap { ISO8601DateFormatter().date(from: $0) } ?? .now

        return Article(
            id: urlString,
            title: title,
            description: description,
            content: content,
            author: author,
            sourceName: source?.name ?? "",
            url: url,
            imageURL: imageURL,
            publishedAt: publishedDate,
            category: category
        )
    }
}
