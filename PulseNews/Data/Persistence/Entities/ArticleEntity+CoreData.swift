//
//  ArticleEntity+CoreData.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import CoreData

extension ArticleEntity {
    
    func populate(from article: Article) {
        self.id = article.id
        self.title = article.title
        self.articleDescription = article.description
        self.content = article.content
        self.author = article.author
        self.sourceName = article.sourceName
        self.url = article.url.absoluteString
        self.imageURL = article.imageURL?.absoluteString
        self.publishedAt = article.publishedAt
        self.category = article.category.rawValue
        self.bookmarkedAt = Date()
    }
    
    func toDomain() -> Article? {
        guard
            let id = id,
            let title = title,
            let urlString = url,
            let url = URL(string: urlString),
            let categoryRaw = category,
            let category = NewsCategory(rawValue: categoryRaw),
            let publishedAt = publishedAt
        else {
            return nil
        }
        
        return Article(
            id: id,
            title: title,
            description: articleDescription,
            content: content,
            author: author,
            sourceName: sourceName ?? "",
            url: url,
            imageURL: imageURL.flatMap(URL.init(string:)),
            publishedAt: publishedAt,
            category: category
        )
    }
}
