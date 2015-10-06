//
//  PaperContentComponent.swift
//  Paper
//
//  Created by fong tinyik on 7/20/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

class PaperContentComponent: NSObject {
    
    var fontType: PaperFontType!
    var text: String!
    
    init(style: PaperFontType, ForText _text: String) {
        fontType = style
        text = _text
    }

}
