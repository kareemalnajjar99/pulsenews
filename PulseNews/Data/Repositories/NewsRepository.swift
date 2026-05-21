//
//  NewsRepository.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import CoreData

final class NewsRepository: NewsRepositoryProtocol {

    private let apiClient: APIClientProtocol
    private let coreDataStack: CoreDataStack

    init(apiClient: APIClientProtocol, coreDataStack: CoreDataStack = .shared) {
        self.apiClient = apiClient
        self.coreDataStack = coreDataStack
    }

    func fetchTopHeadlines(category: NewsCategory, page: Int) async throws -> [Article] {
        do {
            let response: NewsResponseDTO = try await apiClient.request(NewsAPI.topHeadlines(category: category, page: page))
            let articles = response.articles?.compactMap { $0.toDomain(category: category) } ?? []
            cache(articles: articles)
            AppLogger.network.info("Fetched \(articles.count) headlines for category: \(category.rawValue)")
            return articles
        } catch let error as NetworkError {
            AppLogger.network.error("fetchTopHeadlines failed: \(error.asDomainError)")
            if page == 1 {
                return try cachedArticles(for: category)
            }
            throw error.asDomainError
        }
    }

    func searchArticles(query: String, page: Int) async throws -> [Article] {
        do {
            let response: NewsResponseDTO = try await apiClient.request(NewsAPI.search(query: query, page: page))
            let articles = response.articles?.compactMap { $0.toDomain(category: .general) } ?? []
            AppLogger.network.info("Search '\(query)' returned \(articles.count) results")
            return articles
        } catch let error as NetworkError {
            AppLogger.network.error("searchArticles failed: \(error.asDomainError)")
            throw error.asDomainError
        }
    }

    private func cache(articles: [Article]) {
        let context = coreDataStack.newBackgroundContext()
        context.perform {
            articles.forEach { article in
                let entity = ArticleEntity(context: context)
                entity.populate(from: article)
            }
            try? context.save()
        }
    }

    private func cachedArticles(for category: NewsCategory) throws -> [Article] {
        let context = coreDataStack.viewContext
        let request = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        request.fetchLimit = AppConstants.Cache.articleCacheLimit

        do {
            let entities = try context.fetch(request)
            AppLogger.cache.info("Loaded \(entities.count) cached articles for \(category.rawValue)")
            return entities.compactMap { $0.toDomain() }
        } catch {
            AppLogger.cache.error("Cache fetch failed: \(error.localizedDescription)")
            throw DomainError.persistenceFailed(reason: error.localizedDescription)
        }
    }
}
