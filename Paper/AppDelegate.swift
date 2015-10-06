//
//
//  AppDelegate.swift
//  Paper
//
//  Created by fong tinyik on 6/24/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

var expStatus: Int!
var betaStartDate: NSDate!
var kWR: CGFloat!
var kHR: CGFloat!
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        var domain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(domain!)
        
        kWR = NSScreen.mainScreen()!.frame.width/1450
        kHR = NSScreen.mainScreen()!.frame.height/900
        var defaults = NSUserDefaults.standardUserDefaults()
        
        if let _startDate = defaults.objectForKey("betaStartDate") as? NSDate {
            betaStartDate = _startDate
        }else {
            defaults.setObject(NSDate(), forKey: "betaStartDate")
            betaStartDate = NSDate()
        }
        
        if let _stat = defaults.objectForKey("expStatus") as? Int {
            
            expStatus = _stat
            
        }else {
            expStatus = 0
        
            
        }
        
      
      
        println(expStatus)
        if checkIsBetaExpired() {
            var expiryAlert = NSAlert()
            expiryAlert.messageText = "抱歉！ _(:3 」∠)_ 此试用版本的Paper已经过期。若阁下希望继续使用，请点击Paper->Donation购买完整版本。出于对用户数据的保护，从现在起您仍然可以浏览曾经创建的Paper，但新建的Paper将无法被保存。若您决定不再使用Paper，请及时保存至其它文字处理工具。如阁下有任何疑问欢迎致邮 fongtinyik@hotmail.com 。 "
            expiryAlert.addButtonWithTitle("现在捐赠")
            expiryAlert.addButtonWithTitle("OK")
            expiryAlert.runModal()
            

           
        }
        if let previousDate = defaults.objectForKey("Date") as? NSDate {
            var currentDate = NSDate()
            if previousDate.laterDate(currentDate) == previousDate {
                var expiryAlert = NSAlert()
                expiryAlert.messageText = "抱歉！你的小动作被发现啦 _(:3 」∠)_ 此试用版本的Paper已经过期。请不要用修改系统时间来欺骗我的感情...开发工作非常辛苦，若阁下希望继续使用，请点击Paper->Donation购买完整版本。"
                expiryAlert.addButtonWithTitle("现在捐赠")
                expiryAlert.addButtonWithTitle("OK")
                expiryAlert.runModal()
                isPaperExpired = true
                if let vc = NSApplication.sharedApplication().keyWindow?.contentViewController as? ViewController {
                    vc.paperEditingView.editable = false
                }
                
            }
            if previousDate.laterDate(currentDate) == currentDate {
                defaults.setObject(NSDate(), forKey: "Date")
            }
            
        }else{
            defaults.setObject(NSDate(), forKey: "Date")
        }
        
        NSApplication.sharedApplication().keyWindow?.center()
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func setSelectedTextAttributes(sender: NSMenuItem) {
        if let vc = NSApplication.sharedApplication().keyWindow?.contentViewController as? ViewController {
              if  isPaperLockedDown == false {
        switch sender.tag {
        case 0 :(NSApplication.sharedApplication().keyWindow?.contentViewController as! ViewController).respondToPaperSettings(NSFont(name: "WenQuanYi Micro Hei", size: 35)!)
            
        case 1 :(NSApplication.sharedApplication().keyWindow?.contentViewController as! ViewController).respondToPaperSettings(NSFont(name: "WenQuanYi Micro Hei", size: 22)!)
            
        case 2 :(NSApplication.sharedApplication().keyWindow?.contentViewController as! ViewController).respondToPaperSettings(NSFont(name: "FZLanTingKanHei-R-GBK", size: 20)!)
            
        case 3 :(NSApplication.sharedApplication().keyWindow?.contentViewController as! ViewController).respondToPaperSettings(NSFont(name: "FZYouXian-Z09S", size: 20)!)
            
        case 4 :(NSApplication.sharedApplication().keyWindow?.contentViewController as! ViewController).respondToPaperSettings(NSFont(name: "Microsoft Yi Baiti", size: 21)!)
        case 5 :(NSApplication.sharedApplication().keyWindow?.contentViewController as! ViewController).respondToPaperSettings(NSFont(name: "FZJingLeiS-R-GB", size: 20)!)
            
            
        default: break
            
            
        }
        }
        }
        
        
    }
    
    @IBAction func selectHeaderImage(sender: NSMenuItem) {
        
        if let vc = NSApplication.sharedApplication().keyWindow?.contentViewController as? ViewController {
              if  isPaperLockedDown == false {
             vc.selectHeaderImage()
            }
        }
        
    }

    @IBAction func applyTheme(sender: NSMenuItem) {
        if let vc = NSApplication.sharedApplication().keyWindow?.contentViewController as? ViewController  {
            
            if  isPaperLockedDown == false {
        switch sender.tag {
        case 0: (NSApplication.sharedApplication().keyWindow?.contentViewController as! ViewController).respondToPaperBackgroundSettings(NSColor(CGColor: CGColorCreateGenericRGB(244/255, 243/255, 242/255, 1))!)
            
        case 1: (NSApplication.sharedApplication().keyWindow?.contentViewController as! ViewController).respondToPaperBackgroundSettings(NSColor(CGColor: CGColorCreateGenericRGB(255/255, 251/255, 240/255, 1))!)
            
        case 2: (NSApplication.sharedApplication().keyWindow?.contentViewController as! ViewController).respondToPaperBackgroundSettings(NSColor(CGColor: CGColorCreateGenericRGB(30/255, 32/255, 40/255, 1))!)
            
        default: break
            
        }
        }
        }
        
    }
    
    @IBAction func setIsPaperLockedDown(sender: NSMenuItem) {
        if let vc = NSApplication.sharedApplication().keyWindow?.contentViewController as? ViewController {
          
            
              if  isPaperLockedDown == false && isRequirePassword == true {
        (NSApplication.sharedApplication().keyWindow?.contentViewController as! ViewController).setIsPaperLockedDown(true)
                
            }
            
            if isPaperLockedDown == false && isRequirePassword == false {
                var alert = NSAlert()
                alert.messageText = "请先在菜单 File->Set Password 中打开文档密码"
                alert.addButtonWithTitle("OK")
                alert.runModal()
                
                            }
        }
    }
    
    
    @IBAction func saveAsPDF(sender: NSMenuItem) {
        if let vc = NSApplication.sharedApplication().keyWindow?.contentViewController as? ViewController {
            if isPaperLockedDown == false {
                
                vc.saveAsPDF()
            }
            
            
        }

    }
   
    @IBAction func openHomepage(sender: NSMenuItem?) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://www.fongtinyik.tumblr.com")!)
    }
    
    @IBAction func donateToMe(sender: NSMenuItem) {
        
    }
    
    
    @IBAction func revertToSaveClicked(sender: NSMenuItem) {
        isReversionPresenting = true
        
    }
    
    
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    func checkIsBetaExpired() -> Bool {
        println("check")
        let currentDate = NSDate()
        var betaDayNo: NSTimeInterval!
        if expStatus == 0 {
            betaDayNo = 20
            var alert = NSAlert()
            alert.messageText = "请在使用Paper前阅读Paper使用指南。阁下现在使用的是Paper试用版本。试用时间为20天。若您不希望看到此窗口，请前往 Paper-> Donation 支持高中学生开发者并开始享受Paper完整版。您的支持是Paper更新的动力。 -- Fong Tinyik"
            alert.addButtonWithTitle("现在捐赠")
            alert.addButtonWithTitle("OK")
            alert.addButtonWithTitle("关于我，一位高三学生")
            var index = alert.runModal()
            if index == NSAlertThirdButtonReturn {
                openHomepage(nil)
                
            }else if index == NSAlertFirstButtonReturn {
                var event1: CGEvent!
                
                event1 = CGEventCreateKeyboardEvent(nil, 2, true).takeRetainedValue()
                CGEventSetFlags(event1, UInt64(kCGEventFlagMaskCommand))
                
                var location = kCGHIDEventTap
                CGEventPost(UInt32(location), event1)
            }
            


        }
    
        if expStatus == 1 {
            betaDayNo = 53
            var alert = NSAlert()
            alert.messageText = "请在使用Paper前阅读Paper使用指南。阁下现在使用的是Paper试用版本(Extended)。试用时间为53天。若您不希望看到此窗口，请前往 Paper-> Donation 支持高中学生开发者并开始享受Paper完整版。您的支持是Paper更新的动力。 -- Fong Tinyik"
            alert.addButtonWithTitle("现在捐赠")
            alert.addButtonWithTitle("OK")
            alert.addButtonWithTitle("关于我，一位高三学生")
            var index = alert.runModal()
            if index == NSAlertThirdButtonReturn {
                openHomepage(nil)
                
            }else if index == NSAlertFirstButtonReturn {
                var event1: CGEvent!
                
                event1 = CGEventCreateKeyboardEvent(nil, 2, true).takeRetainedValue()
                CGEventSetFlags(event1, UInt64(kCGEventFlagMaskCommand))
                
                var location = kCGHIDEventTap
                CGEventPost(UInt32(location), event1)
            }

        }
        
        if expStatus == 100 {
           betaDayNo = 100000

        }
        
        var expiryDate = betaStartDate.dateByAddingTimeInterval(betaDayNo*60*60*24)
        if currentDate.laterDate(expiryDate) == currentDate {
            isPaperExpired = true
            return true
        }
        
        isPaperExpired = false
        return false

        
    }
}



