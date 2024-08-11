//
//  Item.swift
//  here
//
//  Created by Vladimir Kukushkin on 11.8.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Item: ObservableObject {
    var timestamp: Date
    var url: URL?
    var dragCounter: Int

    init(timestamp: Date, url: URL? = nil, dragCounter: Int = 0) {
        self.timestamp = timestamp
        self.url = url
        self.dragCounter = dragCounter
    }
}
