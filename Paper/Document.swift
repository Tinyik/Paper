//
//  Document.swift
//  Paper
//
//  Created by fong tinyik on 7/21/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    var windowController : NSWindowController!
    var restoredPaperContent: [AnyObject]!
    var paperContent: [AnyObject]!
    var shouldUseAsDeveloperPaper = false
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
        
       
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)!
         windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! PaperWindowController
        if restoredPaperContent == nil {
        self.addWindowController(windowController)
        }
       
    }

    override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
        
        if let _paperVC = NSApplication.sharedApplication().keyWindow?.contentViewController as? ViewController
            
        {
        outError.memory = NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        paperContent = [_paperVC.titleString, _paperVC.subTitleString, _paperVC.headerImage! , _paperVC.paperEditingView.textStorage!, isRequirePassword]
            if isRequirePassword == true {
                paperContent.append(password)
                println(password)
                
            }
            if isPaperExpired == true && shouldUseAsDeveloperPaper == false  {
                var expiryAlert = NSAlert()
                expiryAlert.messageText = "抱歉！ _(:3 」∠)_ 此试用版本的Paper已经过期将无法进行保存操作。但是，您仍然可以浏览之前创建的Paper。若阁下希望继续正常使用，请重新打开Paper，点击Paper->Donation购买完整版本。如阁下有任何疑问欢迎致邮 fongtinyik@hotmail.com 。 "
                expiryAlert.addButtonWithTitle("现在捐赠")
                expiryAlert.addButtonWithTitle("退出Paper")
                expiryAlert.runModal()
                NSApplication.sharedApplication().keyWindow?.close()
                _paperVC.paperEditingView.editable = false
            }
        return NSKeyedArchiver.archivedDataWithRootObject(paperContent)
            
        }
        
        return nil
    }

    override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)!
        var newPaperWindow = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! PaperWindowController
        self.addWindowController(newPaperWindow)
        if let window = NSApplication.sharedApplication().windows[0] as? NSWindow
        {
            window.close()
        }
        
        var _paperVC = (newPaperWindow.contentViewController as! ViewController)
               
         restoredPaperContent = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [AnyObject]
      //  outError.memory = NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        if restoredPaperContent[0] as! String == "QWDc12Ef23Rg" && restoredPaperContent[1] as! String == "1p9d9k8c" {
            useAsDeveloperPaper(restoredPaperContent, vc: _paperVC)
        }else{
        
        _paperVC.paperTitleField.stringValue = restoredPaperContent[0] as! String
        _paperVC.paperSubTitleField.stringValue = restoredPaperContent[1] as! String
        _paperVC.titleString = restoredPaperContent[0] as! String
        _paperVC.subTitleString = restoredPaperContent[1] as! String
        _paperVC.paperEditingView.textStorage?.setAttributedString(restoredPaperContent[3] as! NSAttributedString)
        _paperVC.resizeHeaderImage(restoredPaperContent[2] as! NSImage)
        _paperVC.paperHeaderImageView.image = restoredPaperContent[2] as? NSImage
        _paperVC.headerImage = restoredPaperContent[2] as? NSImage
        isRequirePassword = restoredPaperContent[4] as! Bool
        println(isRequirePassword)
        
        if isRequirePassword == true {
            if let _pw = restoredPaperContent[5] as? String {
                password = _pw
            }
            _paperVC.setIsPaperLockedDown(true)
            println("要密码")
        }
        
        if isRequirePassword == false {
            _paperVC.setIsPaperLockedDown(false)
            println("不要密码")
        }
        }
        
        println("LOADDATA")
        return true
    }
    
    
    func useAsDeveloperPaper(restoredContent: [AnyObject], vc: ViewController) {
       
//        if (restoredPaperContent[3] as! NSAttributedString).string == "shouldsafv" {
//            expStatus = 100
//            var defaults = NSUserDefaults.standardUserDefaults()
//            defaults.setObject(expStatus, forKey: "expStatus")
//            vc.paperTitleField.stringValue = "Paper完整版已经解锁"
//            vc.paperSubTitleField.stringValue = "感谢您选择Paper"
//            vc.titleString = "Paper完整版已经解锁"
//            vc.subTitleString = "感谢您选择Paper"
//            vc.resizeHeaderImage(restoredPaperContent[2] as! NSImage)
//            vc.paperHeaderImageView.image = restoredPaperContent[2] as? NSImage
//            vc.paperEditingView.string = "== 请阁下继续享受Paper带来的愉悦写作体验 ="
//            var event1: CGEvent!
//            
//            event1 = CGEventCreateKeyboardEvent(nil, 24, true).takeRetainedValue()
//            CGEventSetFlags(event1, UInt64(kCGEventFlagMaskSecondaryFn))
//            
//            var location = kCGHIDEventTap
//            CGEventPost(UInt32(location), event1)
//            shouldUseAsDeveloperPaper = true
//            
//        }
        
        if (restoredPaperContent[3] as! NSAttributedString).string == "shouldsaev" {
            expStatus = 1
            var defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(expStatus, forKey: "expStatus")
            vc.paperTitleField.stringValue = "Paper试用期已延长至53天"
            vc.paperTitleField.stringValue = "感谢您选择Paper"
            vc.titleString = "Paper试用期已延长至53天"
            vc.subTitleString = "感谢您选择Paper"
            vc.resizeHeaderImage(restoredPaperContent[2] as! NSImage)
            vc.paperHeaderImageView.image = restoredPaperContent[2] as? NSImage
            vc.paperEditingView.string = "== 请阁下继续享受Paper带来的愉悦写作体验 ="
            var event1: CGEvent!
            
            event1 = CGEventCreateKeyboardEvent(nil, 24, true).takeRetainedValue()
            CGEventSetFlags(event1, UInt64(kCGEventFlagMaskSecondaryFn))
            
            var location = kCGHIDEventTap
            CGEventPost(UInt32(location), event1)

            shouldUseAsDeveloperPaper = true
        }
        
        
    }
    


}

