//
//  WelcomeViewController.swift
//  Paper
//
//  Created by fong tinyik on 7/21/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

class WelcomeViewController: NSViewController {
    var welcomeImage: NSImageView!
    var paperLogo: NSImageView!
    var point: NSImageView!
    var open_image: NSImage!
    var new_image: NSImage!
    var openBtn: NSButton!
    var newBtn: NSButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        kWR = NSScreen.mainScreen()!.frame.width/1450
        kHR = NSScreen.mainScreen()!.frame.height/900
        println(kWR)
        println(kHR)
        paperLogo = NSImageView(frame: NSMakeRect(530, 450, 216*0.6, 210*0.6))
        point = NSImageView(frame: NSMakeRect(520, 200, 216, 210))
        point.image = NSImage(named: "point")
        paperLogo.image = NSImage(named: "PaperLogo")
         welcomeImage = NSImageView(frame: NSMakeRect(0, 0, 1450, 1050))
        
        var images = [NSImage(named: "w1"),NSImage(named: "w2"),NSImage(named: "w3"),NSImage(named: "w4"),NSImage(named: "w5"),NSImage(named: "w6"),NSImage(named: "w7"),NSImage(named: "w8")]
     welcomeImage.imageScaling = NSImageScaling.ImageScaleNone
    var i = Int(arc4random_uniform(7))
    resizeWelcomeImage(images[i]!)
     welcomeImage.image = images[i]
    self.view.addSubview(welcomeImage)
         open_image = NSImage(named: "OpenPaper")
        open_image?.size.height = 74
        open_image?.size.width = 235
         new_image = NSImage(named: "NewPaper")
        new_image?.size.height = 74
        new_image?.size.width = 235
        
        var mask = NSImage(named: "HeaderMask")!
        mask.size.height = 10000
        mask.size.width = 10000
        var maskView = NSImageView(frame: NSMakeRect(0, 0, mask.size.width, mask.size.height))
        resizeWelcomeImage(mask)
        maskView.image = mask
        maskView.imageScaling = .ImageScaleNone
        welcomeImage.addSubview(maskView)
         openBtn = NSButton()
        openBtn.frame = NSMakeRect(300, 300, open_image!.size.width, open_image!.size.height)
       // openBtn.frame = NSMakeRect(00, 00, 100, open_image!.size.height)
        openBtn.setButtonType(NSButtonType.MomentaryPushInButton)
        openBtn.bordered = false
        openBtn.image = open_image
        
        newBtn = NSButton()
        newBtn.frame = NSMakeRect(915, 300, new_image!.size.width, new_image!.size.height)
        
        
        newBtn.setButtonType(NSButtonType.MomentaryPushInButton)
        newBtn.bordered = false
        newBtn.image = new_image
        openBtn.action = "openPaper"
        openBtn.target = self
        newBtn.action = "newPaper"
        newBtn.target = self
        maskView.addSubview(openBtn)
        maskView.addSubview(newBtn)
        maskView.addSubview(paperLogo)
        maskView.addSubview(point)
       
        
        
    }
    
    func resizeWelcomeImage(image: NSImage) {
        
        var widthRatio = 1450*kWR/image.size.width
        var heightRatio = 1000/image.size.height
        if widthRatio > heightRatio {
            image.size.width = 1450*kWR
            image.size.height *= widthRatio
            
        }else {
            image.size.height = 1000
            
           
            image.size.width *= heightRatio
           
        }
        
    }
    
    func openPaper(){
        let documentController = NSDocumentController()
        documentController.openDocument(nil)
        NSApplication.sharedApplication().windows[0].close()
        println("sdfd")
    }
    
    func newPaper(){
        let documentController = NSDocumentController()
        documentController.newDocument(nil)
    
        NSApplication.sharedApplication().windows[0].close()
    }

    
}
