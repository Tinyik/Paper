//
//  DocumentController.swift
//  Paper
//
//  Created by fong tinyik on 7/22/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

class DocumentController: NSDocumentController {
    
    override func openDocument(sender: AnyObject?) {
        super.openDocument(sender)
        println("OPENDOC")
    }
}
