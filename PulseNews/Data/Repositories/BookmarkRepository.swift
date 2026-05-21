//
//  BookmarkRepository.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import CoreData

final class BookmarkRepository: BookmarkRepositoryProtocol {

    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }

    func bookmark(_ article: Article) async throws {
        let context = coreDataStack.newBackgroundContext()
        try await context.perform {
            let entity = ArticleEntity(context: context)
            entity.populate(from: article)
            entity.isBookmarked = true
            do {
                try context.save()
                AppLogger.data.info("Bookmarked article: \(article.id)")
            } catch {
                AppLogger.data.error("Failed to bookmark: \(error.localizedDescription)")
                throw DomainError.persistenceFailed(reason: error.localizedDescription)
            }
        }
    }

    func removeBookmark(_ article: Article) async throws {
        let context = coreDataStack.newBackgroundContext()
        try await context.perform {
            let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@ AND isBookmarked == YES", article.id)
            request.fetchLimit = 1
            do {
                let results = try context.fetch(request)
                results.forEach { context.delete($0) }
                try context.save()
                AppLogger.data.info("Removed bookmark: \(article.id)")
            } catch {
                AppLogger.data.error("Failed to remove bookmark: \(error.localizedDescription)")
                throw DomainError.persistenceFailed(reason: error.localizedDescription)
            }
        }
    }

    func fetchBookmarks() async throws -> [Article] {
        let context = coreDataStack.viewContext
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isBookmarked == YES")
        request.sortDescriptors = [NSSortDescriptor(key: "bookmarkedAt", ascending: false)]

        do {
            let entities = try context.fetch(request)
            AppLogger.data.info("Fetched \(entities.count) bookmarks")
            return entities.compactMap { $0.toDomain() }
        } catch {
            AppLogger.data.error("Failed to fetch bookmarks: \(error.localizedDescription)")
            throw DomainError.persistenceFailed(reason: error.localizedDescription)
        }
    }

    func isBookmarked(_ article: Article) async throws -> Bool {
        let context = coreDataStack.viewContext
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND isBookmarked == YES", article.id)
        request.fetchLimit = 1

        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            throw DomainError.persistenceFailed(reason: error.localizedDescription)
        }
    }
}
