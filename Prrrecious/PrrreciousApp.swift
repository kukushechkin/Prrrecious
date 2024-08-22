//
//  PrrreciousApp.swift
//  Prrrecious
//
//  Created by Vladimir Kukushkin on 11.8.2024.
//

import SwiftData
import SwiftUI

@main
struct PrrreciousApp: App {

    @AppStorage("showMenubar") private var showMenubar = false

    init() {
        try? loadBookmarks()
    }

    private func loadBookmarks() throws {
        var isStale = false
        for (_, url) in UserDefaults.standard.dictionaryRepresentation()
            .filter({ $0.key.hasPrefix("bookmark_") })
            .compactMapValues({ try? URL(resolvingBookmarkData: $0 as! Data, options: .withSecurityScope, bookmarkDataIsStale: &isStale) })
        {
            _ = url.startAccessingSecurityScopedResource()
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
                .modelContainer(sharedModelContainer)
        }
        MenuBarExtra("Prrrecious", systemImage: "diamond.circle", isInserted: $showMenubar) {
            MenubarContentView()
                .modelContainer(sharedModelContainer)
        }
        .menuBarExtraStyle(.window)
    }
}
