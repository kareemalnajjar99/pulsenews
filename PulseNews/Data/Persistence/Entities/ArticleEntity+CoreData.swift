//
//  ArticleEntity+CoreData.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import CoreData

extension ArticleEntity {

    func populate(from article: Article) {
        id = article.id
        title = article.title
        articleDescription = article.description
        content = article.content
        author = article.author
        sourceName = article.sourceName
        url = article.url.absoluteString
        imageURL = article.imageURL?.absoluteString
        publishedAt = article.publishedAt
        category = article.category.rawValue
        bookmarkedAt = Date()
    }

    func toDomain() -> Article? {
        guard
            let id,
            let title,
            let urlString = url,
            let url = URL(string: urlString),
            let categoryRaw = category,
            let category = NewsCategory(rawValue: categoryRaw),
            let publishedAt
        else { return nil }

        return Article(
            id: id,
            title: title,
            description: articleDescription,
            content: content,
            author: author,
            sourceName: sourceName ?? "",
            url: url,
            imageURL: imageURL.flatMap { URL(string: $0) },
            publishedAt: publishedAt,
            category: category
        )
    }
}

