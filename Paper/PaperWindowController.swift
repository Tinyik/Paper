//
//  PaperWindowController.swift
//  Paper
//
//  Created by fong tinyik on 7/19/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa
var widthRatio: CGFloat!
var heightRatio: CGFloat!
var shouldCloseWindow = true
var isReversionPresenting = false
class PaperWindowController: NSWindowController, NSWindowDelegate {
    
    var contentComponents : [PaperContentComponent]!
    
    @IBOutlet weak var _window: NSWindow!
    override func windowDidLoad() {
        super.windowDidLoad()
  
        
        (self.contentViewController as! ViewController)._window = self.window
     self.window?.delegate = self
        self.window!.setFrame(NSMakeRect(100, 0, 1200, 800), display: true, animate: true)
   
        
        for (index, window) in enumerate(NSApplication.sharedApplication().windows) {
            if window as? NSWindow == NSApplication.sharedApplication().keyWindow {
                if index > 0 {
                    
                    (NSApplication.sharedApplication().windows[index] as! NSWindow).documentEdited = true
                    
                    
                      if (NSApplication.sharedApplication().windows[index] as! NSWindow).documentEdited == true && shouldCloseWindow == true  && isReversionPresenting == false  {
                        println("CMDW")
                                        var event1: CGEvent!
                    
                                        event1 = CGEventCreateKeyboardEvent(nil, 13, true).takeRetainedValue()
                                        CGEventSetFlags(event1, UInt64(kCGEventFlagMaskCommand))
                    
                                        var location = kCGHIDEventTap
                                        CGEventPost(UInt32(location), event1)
                        shouldCloseWindow = false
                       
                        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "setShouldCloseWindow", userInfo: nil, repeats: false)
                       

                        
                    }
                    

                    
                }
            }
        }
        
    }
    @IBAction func showContentsPopOver(sender: NSToolbarItem) {
        performSegueWithIdentifier("showContents", sender: nil)
            }
    
    func window(window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplicationPresentationOptions) -> NSApplicationPresentationOptions {
        return NSApplicationPresentationOptions.FullScreen | NSApplicationPresentationOptions.AutoHideToolbar | NSApplicationPresentationOptions.AutoHideMenuBar | .HideDock
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showContents" {
            contentComponents = (self.window?.contentViewController as! ViewController).contentComponents
            if let contentsVC = segue.destinationController as? ContentsPopOverController {
                contentsVC.contentComponents = contentComponents
            }
        }
    }
    
 
    
    func windowDidResize(notification: NSNotification) {
        
         widthRatio = self.contentViewController!.view.frame.width / NSScreen.mainScreen()!.frame.width
         heightRatio = self.contentViewController!.view.frame.height / NSScreen.mainScreen()!.frame.height
        var paperVC = self.contentViewController as! ViewController
        paperVC.paperEditingView.textContainerInset = NSMakeSize(270*kWR*widthRatio, 600*kHR*heightRatio)
        paperVC.paperHeaderImageView.frame = NSMakeRect(0, 0, 1450*kWR*widthRatio, 1000*kHR*heightRatio)
       // paperVC.headerImageMask.frame = paperVC.paperHeaderImageView.frame
        paperVC.settingButtonContainer.frame = NSMakeRect(30, paperVC.view.frame.height-60, paperVC.showSettingsButton.frame.width, paperVC.showSettingsButton.frame.height)
        paperVC.bookmarkButtonContainer.frame = NSMakeRect(paperVC.view.frame.width-40, 0, paperVC.bookmarkButtonContainer.frame.width, paperVC.bookmarkButtonContainer.frame.height)
        
    }
    
    func setShouldCloseWindow() {
        shouldCloseWindow = true
        println("SHOULDCW")
        println(shouldCloseWindow)
    }
    
    
    
  

}
