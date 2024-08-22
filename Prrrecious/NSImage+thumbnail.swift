//
//  NSImage+thumbnail.swift
//  here
//
// Copied from https://github.com/insidegui/WWDC/blob/master/WWDC/NSImage%2BThumbnail.swift
// and fixed the aspect ratio issue
//

import Cocoa
import Foundation

extension NSImage {
    static func thumbnailImage(with url: URL, maxWidth: CGFloat) -> NSImage? {
        guard let inputImage = NSImage(contentsOf: url) else { return nil }
        let aspectRatio = inputImage.size.width / inputImage.size.height
        let thumbSize = NSSize(width: maxWidth, height: maxWidth / aspectRatio)
        let outputImage = NSImage(size: thumbSize)
        outputImage.lockFocus()
        inputImage.draw(in: NSRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height), from: .zero, operation: .sourceOver, fraction: 1)
        outputImage.unlockFocus()
        return outputImage
    }
}
