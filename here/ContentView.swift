//
//  ContentView.swift
//  here
//
//  Created by Vladimir Kukushkin on 11.8.2024.
//

import SwiftUI
import SwiftData

private func openFilePicker() -> URL? {
    let dialog = NSOpenPanel()

    dialog.title = "Choose a directory"
    dialog.showsResizeIndicator = true
    dialog.showsHiddenFiles = false
    dialog.canChooseDirectories = false
    dialog.canCreateDirectories = false
    dialog.allowsMultipleSelection = false
    dialog.canChooseFiles = true

    if dialog.runModal() == NSApplication.ModalResponse.OK {
        return dialog.url
    } else {
        // User clicked on "Cancel"
        return nil
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
                            .padding()
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
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack {
                            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                            ItemView(item: item)
                            Button(action: {
                                if let newLocation = openFilePicker() {
                                    item.url = newLocation
                                }
                            }, label: { Text("Choose location...") })

                        }
                    } label: {
                        ItemView(item: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 600, ideal: 600)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
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
