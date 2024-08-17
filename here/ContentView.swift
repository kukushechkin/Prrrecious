//
//  ContentView.swift
//  here
//
//  Created by Vladimir Kukushkin on 11.8.2024.
//

import SwiftUI
import SwiftData

private func askUserForFiles() -> [URL] {
    let dialog = NSOpenPanel()

    dialog.title = "Choose some files"
    dialog.showsResizeIndicator = true
    dialog.showsHiddenFiles = true
    dialog.canChooseDirectories = false
    dialog.canCreateDirectories = false
    dialog.allowsMultipleSelection = true
    dialog.canChooseFiles = true

    if dialog.runModal() == NSApplication.ModalResponse.OK {
        return dialog.urls
    } else {
        // User clicked on "Cancel"
        return []
    }
}

struct ItemView: View {
    @ObservedObject var item: Item

    var body: some View {
        if let url = item.url {
            HStack {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .failure:
                        Label(title: { Text("\(url.lastPathComponent)") }, icon: { Image(systemName: "doc") })
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 128, height: 128)
                            .clipShape(.rect(cornerRadius: 25))
                    default:
                        ProgressView()
                    }
                }
                .onDrag {
                    item.dragCounter += 1
                    return NSItemProvider(contentsOf: url) ?? NSItemProvider()
                }
                Text("\(item.dragCounter)")
            }
        } else {
            Label("No file selected", systemImage: "doc")
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 128))]) {
            ForEach(items) { item in
                VStack {
                    ItemView(item: item)
                }
            }
            .onDelete(perform: deleteItems)
        }
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
        }
    }

    private func addItems() {
        withAnimation {
            for location in askUserForFiles() {
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
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
