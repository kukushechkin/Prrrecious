//
//  OpenFile.swift
//  here
//
//  Created by Vladimir Kukushkin on 18.8.2024.
//

import SwiftData
import Foundation
import SwiftUI

func askUserForFiles() -> [URL] {
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
