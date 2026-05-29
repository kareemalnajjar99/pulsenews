//
//  MockBookmarkRepository.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 22/05/2026.
//

@testable import PulseNews
import Foundation

final class MockBookmarkRepository: @unchecked Sendable, BookmarkRepositoryProtocol {

    var bookmarkCallCount = 0
    var removeBookmarkCallCount = 0
    var capturedArticle: Article?
    var stubError: Error?

    func bookmark(_ article: Article) async throws {
        if let error = stubError {
            throw error
        }
        bookmarkCallCount += 1
        capturedArticle = article
    }

    func removeBookmark(_ article: Article) async throws {
        if let error = stubError {
            throw error
        }
        removeBookmarkCallCount += 1
        capturedArticle = article
    }

    func fetchBookmarks() async throws -> [Article] { [] }

    func isBookmarked(_ article: Article) async throws -> Bool { false }
}
