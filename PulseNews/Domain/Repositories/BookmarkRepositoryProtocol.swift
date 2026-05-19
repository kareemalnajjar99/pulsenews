//
//  BookmarkRepositoryProtocol.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

protocol BookmarkRepositoryProtocol: Sendable {
    func bookmark(_ article: Article) async throws
    func removeBookmark(_ article: Article) async throws
    func fetchBookmarks() async throws -> [Article]
    func isBookmarked(_ article: Article) async throws -> Bool
}
