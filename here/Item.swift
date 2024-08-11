//
//  Item.swift
//  here
//
//  Created by Vladimir Kukushkin on 11.8.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
