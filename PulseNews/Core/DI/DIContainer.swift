//
//  DIContainer.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

final class DIContainer {

    static let shared = DIContainer()

    let news: NewsDIContainer
    let bookmark: BookmarkDIContainer

    private init() {
        let apiClient = APIClient()
        let coreDataStack = CoreDataStack.shared
        self.news = NewsDIContainer(apiClient: apiClient, coreDataStack: coreDataStack)
        self.bookmark = BookmarkDIContainer(coreDataStack: coreDataStack)
    }
}
