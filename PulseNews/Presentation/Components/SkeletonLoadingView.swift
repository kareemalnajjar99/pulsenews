//
//  SkeletonLoadingView.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import SwiftUI

struct SkeletonLoadingView: View {

    @State private var shimmerOffset: CGFloat = -1

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<5, id: \.self) { _ in
                    skeletonCard
                }
            }
            .padding(.horizontal)
        }
        .disabled(true)
        .onAppear {
            withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                shimmerOffset = 1
            }
        }
    }

    private var skeletonCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(.quaternary)
                .frame(maxWidth: .infinity)
                .frame(height: 200)

            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(.quaternary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
                    .clipShape(.capsule)

                Rectangle()
                    .fill(.quaternary)
                    .frame(width: 200)
                    .frame(height: 16)
                    .clipShape(.capsule)

                Rectangle()
                    .fill(.quaternary)
                    .frame(width: 100)
                    .frame(height: 12)
                    .clipShape(.capsule)
            }
            .padding(14)
        }
        .clipShape(.rect(cornerRadius: 16))
        .overlay {
            shimmerOverlay
        }
        .clipShape(.rect(cornerRadius: 16))
    }

    private var shimmerOverlay: some View {
        GeometryReader { geo in
            LinearGradient(
                colors: [.clear, .white.opacity(0.15), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geo.size.width * 0.4)
            .offset(x: geo.size.width * shimmerOffset)
        }
    }
}

#Preview {
    SkeletonLoadingView()
}
