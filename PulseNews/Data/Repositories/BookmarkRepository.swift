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

            let request: NSFetchRequest<ArticleEntity> =
            ArticleEntity.fetchRequest()

            request.predicate = NSPredicate(
                format: "id == %@",
                article.id
            )

            let results = try context.fetch(request)

            let entity: ArticleEntity

            if let first = results.first {

                entity = first

                // Cleanup old duplicate rows
                for duplicate in results.dropFirst() {
                    context.delete(duplicate)
                }

            } else {

                entity = ArticleEntity(context: context)
            }

            entity.populate(from: article)
            entity.isBookmarked = true
            entity.bookmarkedAt = Date()

            try context.save()

            AppLogger.data.info(
                "Bookmarked article: \(article.id)"
            )
        }
    }

    func removeBookmark(_ article: Article) async throws {

        let context = coreDataStack.newBackgroundContext()

        try await context.perform {

            let request: NSFetchRequest<ArticleEntity> =
            ArticleEntity.fetchRequest()

            request.predicate = NSPredicate(
                format: "id == %@",
                article.id
            )

            request.fetchLimit = 1

            guard let entity = try context.fetch(request).first else {
                return
            }

            entity.isBookmarked = false

            try context.save()

            AppLogger.data.info(
                "Removed bookmark: \(article.id)"
            )
        }
    }

    func fetchBookmarks() async throws -> [Article] {

        let context = coreDataStack.viewContext

        return try await context.perform {

            let request: NSFetchRequest<ArticleEntity> =
            ArticleEntity.fetchRequest()

            request.predicate = NSPredicate(
                format: "isBookmarked == YES"
            )

            request.sortDescriptors = [
                NSSortDescriptor(
                    key: "bookmarkedAt",
                    ascending: false
                )
            ]

            let entities = try context.fetch(request)

            AppLogger.data.info(
                "Fetched \(entities.count) bookmarks"
            )

            return entities.compactMap { $0.toDomain() }
        }
    }

    func isBookmarked(_ article: Article) async throws -> Bool {

        let context = coreDataStack.viewContext

        return try await context.perform {

            context.refreshAllObjects()

            let request: NSFetchRequest<ArticleEntity> =
            ArticleEntity.fetchRequest()

            request.predicate = NSPredicate(
                format: "id == %@ AND isBookmarked == YES",
                article.id
            )

            request.fetchLimit = 1

            let result = try context.fetch(request)

            return !result.isEmpty
        }
    }
}
