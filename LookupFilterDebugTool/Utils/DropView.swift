//
//  DropView.swift
//  LookupFilterDebugTool
//
//  Created by Jone Wang on 19/9/2019.
//  Copyright © 2019 LookupFilterDebugTool. All rights reserved.
//

import AppKit
import Cocoa

class DropView: NSView {
    var filePath: String?
    let expectedExt = ["png"] // file extensions allowed for Drag&Drop (example: "jpg","png","docx", etc..)

    typealias OpenImage = (NSImage) -> Void
    var fileDraggedBlock: OpenImage?

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor

        registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if self.checkExtension(sender) == true {
            self.layer?.backgroundColor = NSColor.secondaryLabelColor.cgColor
            return .copy
        } else {
            return NSDragOperation()
        }
    }

    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board[0] as? String
        else { return false }

        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
    }

    override func draggingEnded(_ sender: NSDraggingInfo) {
        self.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
        else { return false }
        
        self.filePath = path
        Swift.print("FilePath: \(path)")
        
        if let openImageBlock = fileDraggedBlock {
            let image = NSImage(contentsOfFile: path)
            if let image = image {
                openImageBlock(image)
            }
        }

        return true
    }
}
