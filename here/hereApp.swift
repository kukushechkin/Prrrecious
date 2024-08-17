//
//  hereApp.swift
//  here
//
//  Created by Vladimir Kukushkin on 11.8.2024.
//

import SwiftUI
import SwiftData

@main
struct hereApp: App {

    init() {
        // Load all bookmarks from UserDefaults
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            if key.hasPrefix("bookmark_"), let data = value as? Data {
                print("Key: \(key)")
                var isStale = false
                if let url = try? URL(resolvingBookmarkData: data, options: .withSecurityScope, bookmarkDataIsStale: &isStale) {
                    let started = url.startAccessingSecurityScopedResource()
                    print("Accessing \(url): \(started), is stale: \(isStale)")
                }
            }
        }
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

