//
//  DonationVC.swift
//  Paper
//
//  Created by fong tinyik on 7/24/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

class DonationVC: NSViewController {

    @IBOutlet weak var codeField: NSTextField!
    
    var activationCodes: [AnyObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        let codeDataSource = NSString(contentsOfURL: NSURL(string: "http://www.nminteract.org/Codes.txt")!, encoding: NSUTF8StringEncoding, error: nil)
        if codeDataSource != nil{
         activationCodes = codeDataSource!.componentsSeparatedByString(",")
        }
        if expStatus == 100 {
            codeField.placeholderString = "Paper已激活"
            codeField.editable = false
        }
    }
    
    @IBAction func openHomepage(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://www.fongtinyik.tumblr.com")!)
    }
    
    @IBAction func activatePaperFullVer(sender: NSButton) {
        var isFound = false
        if activationCodes != nil {
            for code in activationCodes {
                if let _code = code as? String {
                    if _code == codeField.stringValue {
                        isFound = true
                        expStatus = 100
                        var defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(expStatus, forKey: "expStatus")
                        var activationAlert = NSAlert()
                        activationAlert.messageText = "感谢支持Paper! Paper完整版已成功激活!"
                        activationAlert.addButtonWithTitle("OK")
                        activationAlert.runModal()
                        codeField.stringValue = ""
                        codeField.placeholderString = "Paper已激活"
                        codeField.editable = false
                    }
                }
            }
            
            if isFound == false {
                codeField.stringValue = ""
                var activationAlert = NSAlert()
                activationAlert.messageText = "抱歉，激活码不正确!"
                activationAlert.addButtonWithTitle("OK")
                activationAlert.runModal()
                
            }
        }else {
            codeField.stringValue = ""
            var activationAlert = NSAlert()
            activationAlert.messageText = "请检查您的网络连接后重新打开此页面。"
            activationAlert.addButtonWithTitle("OK")
            activationAlert.runModal()
            
        }
        
    }
}
