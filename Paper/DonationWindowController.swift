//
//  DonationWindowController.swift
//  Paper
//
//  Created by fong tinyik on 7/24/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

class DonationWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    self.window?.styleMask = window!.styleMask & ~NSResizableWindowMask
    self.window?.center()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
