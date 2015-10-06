//
//  ContentsPopOverController.swift
//  Paper
//
//  Created by fong tinyik on 7/19/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

var bookmarkMaskImage = NSImage()
class ContentsPopOverController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
 var contentComponents : [PaperContentComponent]!
    
    @IBOutlet weak var contentsView: NSTableView!
    
    @IBOutlet weak var bookmarkMask: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        contentsView.backgroundColor = .clearColor()
        contentsView.headerView = nil
        contentsView.selectionHighlightStyle = .None
        bookmarkMask.image = bookmarkMaskImage
    }
    
    func respondToBookmarkViewBackgroundSettings(newMaskImage: NSImage) {
        bookmarkMask.image = newMaskImage
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        switch contentComponents[row].fontType! {
        case PaperFontType.H1 : cellView.textField?.stringValue =  contentComponents[row].text
                                cellView.textField?.font = NSFont(name: "WenQuanYi Micro Hei", size: 18)
        case PaperFontType.H2 : cellView.textField?.stringValue = "         " + contentComponents[row].text
                                cellView.textField?.font = NSFont(name: "WenQuanYi Micro Hei", size: 15)
        default : break
            
        }
        
        return cellView
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let _content = contentComponents {
            return _content.count
        }else {
            return 0
        }
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }

    
    func tableViewSelectionDidChange(notification: NSNotification) {
         var _paperEV = (NSApplication.sharedApplication().keyWindow?.contentViewController as?ViewController)?.paperEditingView
//        var _range = NSMakeRange(0, Int(strlen(paperVC!.paperEditingView.string!)))
//        paperVC!.paperEditingView.scrollRangeToVisible((paperVC!.paperEditingView.string! as NSString).rangeOfString(contentComponents[contentsView.selectedRow].text!))
        
        var attributedContent = _paperEV!.attributedString()
        
        attributedContent.enumerateAttribute(NSFontAttributeName, inRange: NSMakeRange(0, attributedContent.length), options: nil) { (font, _range, d) -> Void in
            
            if (font as! NSFont).fontName == "WenQuanYiMicroHei" && (font as! NSFont).pointSize == 35 {
                var str = attributedContent.attributedSubstringFromRange(_range).string
                
                if self.contentComponents[self.contentsView.selectedRow].text! == str {
                    _paperEV?.scrollRangeToVisible(_range)
                    _paperEV?.showFindIndicatorForRange(_range)
                    
                }
                
            }
            
            if (font as! NSFont).fontName == "WenQuanYiMicroHei" && (font as! NSFont).pointSize == 22 {
                
                var str = attributedContent.attributedSubstringFromRange(_range).string
                
                if self.contentComponents[self.contentsView.selectedRow].text! == str {
                    _paperEV?.scrollRangeToVisible(_range)
                    _paperEV?.showFindIndicatorForRange(_range)
                    
                }
                
            }
            
            
            
        }

        
        
           }
    
}
