//
//  PaperTextView.swift
//  Paper
//
//  Created by fong tinyik on 7/20/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

class PaperTextView: NSTextView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override var textContainerOrigin: NSPoint {
        
        get{
            let origin = super.textContainerOrigin
            if heightRatio != nil {
            return NSMakePoint(origin.x, origin.y+500*kHR*heightRatio)
            }else {
                return NSMakePoint(origin.x, origin.y + 500*kHR)
            }
        }
        set{
            self.textContainerOrigin = newValue
        }
    }
    

    
}
