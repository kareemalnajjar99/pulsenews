//
//  AppLogger.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//


import OSLog

enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.pulsenews"

    static let network  = Logger(subsystem: subsystem, category: "Network")
    static let cache    = Logger(subsystem: subsystem, category: "Cache")
    static let data     = Logger(subsystem: subsystem, category: "Data")
    static let ui       = Logger(subsystem: subsystem, category: "UI")
}
