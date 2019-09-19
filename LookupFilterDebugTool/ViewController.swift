//
//  ViewController.swift
//  LookupFilterDebugTool
//
//  Created by Jone Wang on 19/9/2019.
//  Copyright © 2019 LookupFilterDebugTool. All rights reserved.
//

import Cocoa
import GPUImage

class ViewController: NSViewController {
    @IBOutlet var lookupDropView: DropView!
    @IBOutlet var lookupImageView: NSImageView!
    @IBOutlet var handleDropView: DropView!

    override func viewDidLoad() {
        super.viewDidLoad()

        lookupDropView.fileDraggedBlock = { image in
            self.lookupImageView.image = image
        }

        handleDropView.fileDraggedBlock = { image in
            guard let lookupImage = self.self.lookupImageView.image else {
                return
            }

            let lookupFilter = LookupFilter()
            lookupFilter.lookupImage = PictureInput(image: lookupImage)

            let filteredImage = image.filterWithOperation(lookupFilter)

            // Save to Download folder
            let desktopURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
            let destinationURL = desktopURL.appendingPathComponent("filter-\(Date().timeIntervalSince1970).png")
            _ = filteredImage.pngWrite(to: destinationURL, options: Data.WritingOptions.atomicWrite)
        }
    }
}
