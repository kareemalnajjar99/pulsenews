//
//  NewsCategory.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

enum NewsCategory: String, CaseIterable, Identifiable, Sendable {
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .general:       return String(localized: "General")
        case .business:      return String(localized: "Business")
        case .entertainment: return String(localized: "Entertainment")
        case .health:        return String(localized: "Health")
        case .science:       return String(localized: "Science")
        case .sports:        return String(localized: "Sports")
        case .technology:    return String(localized: "Technology")
        }
    }
    
    var symbolName: String {
        switch self {
        case .general:       return "newspaper"
        case .business:      return "chart.bar"
        case .entertainment: return "popcorn"
        case .health:        return "heart"
        case .science:       return "flask"
        case .sports:        return "sportscourt"
        case .technology:    return "cpu"
        }
    }
}
