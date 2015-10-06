//
//  WelcomeWindowController.swift
//  Paper
//
//  Created by fong tinyik on 7/22/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

class WelcomeWindowController: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var _window: NSWindow!
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.delegate = self
               // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window!.setFrame(NSMakeRect(125*kWR, 200*kHR, 1100*kWR, 700*kHR), display: true, animate: true)
        self.window?.styleMask = window!.styleMask & ~NSResizableWindowMask
         window?.center()
    }
    
    func windowDidResize(notification: NSNotification) {
        
        widthRatio = self.contentViewController!.view.frame.width / NSScreen.mainScreen()!.frame.width
        heightRatio = self.contentViewController!.view.frame.height / NSScreen.mainScreen()!.frame.height
        var welcomeVC = self.contentViewController as! WelcomeViewController
        
        welcomeVC.welcomeImage.frame = NSMakeRect(0, 0, 1450*kWR*widthRatio, 1050*heightRatio*kHR)
        welcomeVC.openBtn.frame = NSMakeRect(250*kWR*widthRatio, 300*kHR*heightRatio, welcomeVC.open_image!.size.width, welcomeVC.open_image!.size.height)
        welcomeVC.newBtn.frame = NSMakeRect(865*kWR*widthRatio, 300*kHR*heightRatio, welcomeVC.open_image!.size.width, welcomeVC.open_image!.size.height)
        welcomeVC.paperLogo.frame =  NSMakeRect(640*kWR*widthRatio, 550*kHR*heightRatio, 216*0.6, 210*0.6)
        welcomeVC.point.frame = NSMakeRect(720*kWR*widthRatio, 100*kHR*heightRatio, 216*0.2, 210*0.2)
        
        
        
    }

    

}
