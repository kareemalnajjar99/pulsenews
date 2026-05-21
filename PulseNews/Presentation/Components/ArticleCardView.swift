//
//  ArticleCardView.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import SwiftUI

struct ArticleCardView: View {

    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageURL = article.imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                    case .failure:
                        imagePlaceholder
                    case .empty:
                        imagePlaceholder
                            .overlay(ProgressView())
                    @unknown default:
                        imagePlaceholder
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .clipped()
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                HStack {
                    Text(article.byline)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(article.publishedAgo)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.top, 4)
            }
            .padding(14)
        }
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }

    private var imagePlaceholder: some View {
        Rectangle()
            .fill(.quaternary)
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .overlay {
                Image(systemName: "newspaper")
                    .font(.largeTitle)
                    .foregroundStyle(.tertiary)
            }
    }
}

#Preview {
    ArticleCardView(article: .preview)
        .padding()
}
