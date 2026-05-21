//
//  PulseNewsApp.swift
//  PulseNews
//
//  Created by Kareem Alnajjar on 19/05/2026.
//

import SwiftUI

@main
struct PulseNewsApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.diContainer, DIContainer.shared)
        }
    }
}

private struct DIContainerKey: EnvironmentKey {
    static let defaultValue = DIContainer.shared
}

extension EnvironmentValues {
    var diContainer: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
