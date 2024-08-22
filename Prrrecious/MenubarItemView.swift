//
//  ItemView.swift
//  Prrrecious
//
//  Created by Vladimir Kukushkin on 18.8.2024.
//

import SwiftUI

struct MenubarItemView: View {
    @ObservedObject var item: Item

    var body: some View {
        if let url = item.url {
            if let tn = item.thumbnail {
                Image(nsImage: tn)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(.rect(cornerRadius: 5))
                    .onDrag {
                        item.dragCounter += 1
                        return NSItemProvider(contentsOf: url) ?? NSItemProvider()
                    }
            } else {
                Label(title: { Text("\(url.lastPathComponent)") }, icon: { Image(systemName: "doc") })
                .onDrag {
                    item.dragCounter += 1
                    return NSItemProvider(contentsOf: url) ?? NSItemProvider()
                }
            }
        } else {
            Label("No file selected", systemImage: "doc")
        }
    }
}

//#Preview {
//    ItemView()
//}
