//
//  ItemView.swift
//  Prrrecious
//
//  Created by Vladimir Kukushkin on 18.8.2024.
//

import SwiftUI

struct ItemView: View {
    @ObservedObject var item: Item
    var showCounter: Bool = true

    var body: some View {
        if let url = item.url {
            HStack {
                if let tn = item.thumbnail {
                    Image(nsImage: tn)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(.rect(cornerRadius: 25))
                        .onDrag {
                            item.dragCounter += 1
                            return NSItemProvider(contentsOf: url) ?? NSItemProvider()
                        }
                } else {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .failure:
                            Label(title: { Text("\(url.lastPathComponent)") }, icon: { Image(systemName: "doc") })
                        case let .success(image):
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
                }
                if showCounter {
                    Text("\(item.dragCounter)")
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
