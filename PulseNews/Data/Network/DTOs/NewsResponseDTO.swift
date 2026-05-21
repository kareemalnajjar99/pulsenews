//
//  NewsResponseDTO.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import Foundation

struct NewsResponseDTO: Decodable, Sendable {
    let status: String
    let totalResults: Int?
    let articles: [ArticleDTO]?
}
