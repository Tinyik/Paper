//
//  PasswordViewController.swift
//  Paper
//
//  Created by fong tinyik on 7/22/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

class PasswordViewController: NSViewController {
    
    @IBOutlet weak var oldPwField: NSTextField!
    @IBOutlet weak var validationField: NSTextField!
    @IBOutlet weak var newPwField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        println(password)
        // Do view setup here.
    }
    
    
    
    
    @IBAction func setPassword(sender: NSButton) {
        
        if oldPwField.stringValue == password {
            if newPwField.stringValue == validationField.stringValue {
                if newPwField.stringValue != "" {
                    isRequirePassword = true
                    password = newPwField.stringValue
                    var alert = NSAlert()
                    alert.messageText = "密码设置成功"
                    alert.addButtonWithTitle("OK")
                    alert.runModal()
                }
            }
        }else{
            var alert = NSAlert()
            alert.messageText = "旧密码输入有误"
            alert.addButtonWithTitle("OK")
            alert.runModal()
        }
    }
    
}

