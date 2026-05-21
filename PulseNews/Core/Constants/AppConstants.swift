//
//  AppConstants.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import Foundation

enum AppConstants {
    enum Cache {
        static let articleCacheLimit = 100
        static let imageCacheMemoryLimit = 50 * 1024 * 1024 // 50 MB
    }

    enum Pagination {
        static let pageSize = 20
    }
}
