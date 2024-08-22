//
//  MenubarContentView.swift
//  Prrrecious
//
//  Created by Vladimir Kukushkin on 18.8.2024.
//

import SwiftData
import SwiftUI

struct MenubarContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(items) { item in
                    MenubarItemView(item: item)
                }
            }
        }
    }
}

#Preview {
    MenubarContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
