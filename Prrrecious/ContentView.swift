//
//  ContentView.swift
//  Prrrecious
//
//  Created by Vladimir Kukushkin on 11.8.2024.
//

import SwiftData
import SwiftUI


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @AppStorage("showCounters") private var showCounters = false

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 128))]) {
                ForEach(items) { item in
                    VStack {
                        ItemView(item: item, showCounter: showCounters)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .padding()
            .toolbar {
                #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                #endif
                ToolbarItem {
                    Button(action: addItems) {
                        Label("Add Items", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: toggleShowCounters) {
                        Label("Toggle Counters", systemImage: showCounters ? "eye.slash" : "eye")
                    }
                }
            }
        }
    }

    private func addItems() {
        withAnimation {
            for location in askUserForFiles() {
                let startedUsing = location.startAccessingSecurityScopedResource()
                let bookmarkData = try? location.bookmarkData(options: .securityScopeAllowOnlyReadAccess, includingResourceValuesForKeys: nil, relativeTo: nil)
                print("Bookmark data for \(location): \(String(describing: bookmarkData)), started using: \(startedUsing)")
                if let bookmarkData = bookmarkData {
                    UserDefaults.standard.set(bookmarkData, forKey: "bookmark_\(location.path)")
                }

                let newItem = Item(timestamp: Date(), url: location)
                modelContext.insert(newItem)
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }

    private func toggleShowCounters() {
        withAnimation {
            showCounters.toggle()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
