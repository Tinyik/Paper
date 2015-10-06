//
//  PaperSettingsViewController.swift
//  Paper
//
//  Created by fong tinyik on 7/19/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa
protocol PaperSettingsViewDelegate {
      func respondToPaperSettings(newFont: NSFont)
      func respondToPaperBackgroundSettings(newBackgroundColor: NSColor)
    
}



class PaperSettingsViewController: NSViewController {
    
    var delegate: PaperSettingsViewDelegate!
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    //FIXME: 解锁状态下才能设置密码， 中途设置密码
    @IBAction func setSelectedTextAsH1Attribute(sender: NSButton) {
        self.delegate.respondToPaperSettings(NSFont(name: "WenQuanYi Micro Hei", size: 35)!)
        self.dismissViewController(self)
    }
    
    @IBAction func setSelectedTextAsH2Attribute(sender: NSButton) {
        self.delegate.respondToPaperSettings(NSFont(name: "WenQuanYi Micro Hei", size: 22)!)
        self.dismissViewController(self)
    }
    
    @IBAction func setSelectedTextAsH3Attribute(sender: NSButton) {
        self.delegate.respondToPaperSettings(NSFont(name: "FZLanTingKanHei-R-GBK", size: 20)!)
        self.dismissViewController(self)
    }
    
    @IBAction func setSelectedTextAsH4Attribute(sender: NSButton) {
        self.delegate.respondToPaperSettings(NSFont(name: "Microsoft Yi Baiti", size: 21)!)
    }
    
    @IBAction func setSelectedTextAsH5Attribute(sender: NSButton) {
        self.delegate.respondToPaperSettings(NSFont(name: "FZJingLeiS-R-GB", size: 20)!)
        self.dismissViewController(self)
    }
    @IBAction func setSelectedTextAsH6Attribute(sender: NSButton) {
        self.delegate.respondToPaperSettings(NSFont(name: "FZYouXian-Z09S", size: 20)!)
        self.dismissViewController(self)
    }

    @IBAction func setPaperBackground(sender: NSButton) {
        if sender.tag == 0 {
            self.delegate.respondToPaperBackgroundSettings(NSColor(CGColor: CGColorCreateGenericRGB(244/255, 243/255, 242/255, 1))!)
            bookmarkMaskImage = NSImage()
        }
        
        
        if sender.tag == 1 {
            self.delegate.respondToPaperBackgroundSettings(NSColor(CGColor: CGColorCreateGenericRGB(255/255, 251/255, 240/255, 1))!)
            bookmarkMaskImage = NSImage(named: "BookmarkMask2")!
            
        }
        
        if sender.tag == 2 {
            self.delegate.respondToPaperBackgroundSettings(NSColor(CGColor: CGColorCreateGenericRGB(30/255, 32/255, 40/255, 1))!)
            bookmarkMaskImage = NSImage(named: "BookmarkMask")!
        }
        
        
        
    }
}
