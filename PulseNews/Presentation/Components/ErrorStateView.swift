//
//  ErrorStateView.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 21/05/2026.
//

import SwiftUI

struct ErrorStateView: View {

    let message: String
    let onRetry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(String(localized: "Something went wrong"), systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button(String(localized: "Try Again"), action: onRetry)
                .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ErrorStateView(message: "No internet connection.") {}
}
