//
//  ViewController.swift
//  Paper
//
//  Created by fong tinyik on 6/24/15.
//  Copyright (c) 2015 fong tinyik. All rights reserved.
//

import Cocoa

enum PaperFontType {
    
    case H1
    case H2
    case H3
    case H4
    case H5
    
}

var isPaperLockedDown = false
var password = ""
var isRequirePassword = false
var isPaperExpired = false
//FIXME: 保存时检查Paper是否锁定
//FIXME: 快捷键检查Paper是否锁定
class ViewController: NSViewController, NSTextViewDelegate, PaperSettingsViewDelegate, NSTextFieldDelegate {
    
    @IBOutlet var paperEditingView: PaperTextView!
    @IBOutlet weak var showSettingsButton: NSButton!
    @IBOutlet weak var scroller: NSScrollView!
    @IBOutlet weak var showBookmarkButton: NSButton!
    
    var contentComponents : [PaperContentComponent]!
    var titleString = ""
    var subTitleString = ""
    var headerImage = NSImage(named: "w6")
    var pickHeaderButton: NSButton!
    var paperHeaderImageView: NSImageView!
    var settingButtonContainer = NSView()
    var trackingArea: NSTrackingArea!
    var _window: NSWindow!
    var paperTitleField: NSTextField!
    var paperSubTitleField: NSTextField!
    var tempTitleString: String!
    var tempSubTitleString: String!
    var printInfo: NSPrintInfo!
    var sharedInfo: NSPrintInfo!
    var printOp: NSPrintOperation!
    var printInfoDict: [NSObject:AnyObject]!
    var sharedDict: [NSObject:AnyObject]!
    var panel: NSSavePanel!
    var bookmarkButtonContainer: NSView!
    var headerImageMask: NSImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
       
        scroller.contentView.postsBoundsChangedNotifications = true
        var center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "scrollerBoundDidChange", name: NSViewBoundsDidChangeNotification, object: scroller.contentView)
        
        showSettingsButton.removeFromSuperview()
        showBookmarkButton.removeFromSuperview()
        settingButtonContainer.frame = NSMakeRect(30, 830, showSettingsButton.frame.width, showSettingsButton.frame.height)
        
         bookmarkButtonContainer = NSView(frame: NSMakeRect(1350, 0, showBookmarkButton.frame.width, showBookmarkButton.frame.height))
        //   settingButtonContainer.wantsLayer = true
        // settingButtonContainer.layer?.backgroundColor = CGColorCreateGenericRGB(0, 0, 0, 1)
        
        scroller.addSubview(settingButtonContainer)
        scroller.addSubview(bookmarkButtonContainer)
        settingButtonContainer.addSubview(showSettingsButton)
        bookmarkButtonContainer.addSubview(showBookmarkButton)
        
        // showSettingsButton.frame = NSMakeRect(0, 0, 30, 30)
        
        var ssbImage = NSImage(named: "PaperSettingUnhighlighted")
        ssbImage?.size.width = 33
        ssbImage?.size.height = 33
        
        showSettingsButton.image = ssbImage
        
        var sbmImage = NSImage(named: "BookmarkUnhighlighted")
        sbmImage?.size.width = 29
        sbmImage?.size.height = 155
        
        showBookmarkButton.image = sbmImage
        
        resizeHeaderImage(headerImage!)
        
        paperHeaderImageView = NSImageView(frame: NSMakeRect(0, 0, 1450*kWR, 1000*kHR))
        paperHeaderImageView.imageScaling = NSImageScaling.ImageScaleNone
        paperHeaderImageView.image = headerImage
        headerImageMask = NSImageView(frame: NSMakeRect(0, 0, 1450*kWR, 1000*kHR))
        var maskImage = NSImage(named: "HeaderMask.png")
        resizeHeaderImage(maskImage!)
        headerImageMask.image = maskImage
        headerImageMask.imageScaling = .ImageScaleNone
        let pickerImage = NSImage(named: "PickHeaderUnhighlighted")
        pickerImage?.size.width = 73
        pickerImage?.size.height = 73
        pickHeaderButton = NSButton(frame: NSMakeRect(980*kWR, 300*kHR, pickerImage!.size.width, pickerImage!.size.height))
        pickHeaderButton.setButtonType(NSButtonType.MomentaryChangeButton)
        pickHeaderButton.bordered = false
        pickHeaderButton.image = pickerImage
        trackingArea = NSTrackingArea(rect: pickHeaderButton.bounds, options: NSTrackingAreaOptions.MouseEnteredAndExited | NSTrackingAreaOptions.ActiveAlways, owner: self, userInfo: nil)
        
        var settingTrackingArea = NSTrackingArea(rect: showSettingsButton.bounds, options: NSTrackingAreaOptions.MouseEnteredAndExited | NSTrackingAreaOptions.ActiveAlways, owner: self, userInfo: nil)
        
        var bookmarkTrackingArea = NSTrackingArea(rect: bookmarkButtonContainer.bounds, options: NSTrackingAreaOptions.MouseEnteredAndExited | NSTrackingAreaOptions.ActiveAlways, owner: self, userInfo: nil)
        
        println(self.showBookmarkButton.frame)
        bookmarkButtonContainer.addTrackingArea(bookmarkTrackingArea)
        showSettingsButton.addTrackingArea(settingTrackingArea)
        headerImageMask.addSubview(pickHeaderButton)
        pickHeaderButton.addTrackingArea(trackingArea)
        pickHeaderButton.action = "selectHeaderImage"
        paperHeaderImageView.addSubview(headerImageMask)
        
        
        //MARK: FONT GOES HERE
        paperEditingView.font = NSFont(name: "FZLanTingKanHei-R-GBK", size: 20)
        
        paperEditingView.delegate = self
        paperEditingView.addSubview(paperHeaderImageView)
         paperTitleField = NSTextField(frame: NSMakeRect(200*kWR, 350*kHR, 1000, 80))
         paperSubTitleField = NSTextField(frame: NSMakeRect(200*kWR, 250*kHR, 1000, 70))
        paperTitleField.font = NSFont(name: "WenQuanYi Micro Hei", size: 50)
        paperSubTitleField.font = NSFont(name: "FZLanTingKanHei-R-GBK", size: 30)
        paperTitleField.textColor = NSColor.whiteColor()
        paperTitleField.backgroundColor = NSColor.clearColor()
        paperSubTitleField.target = self
        paperSubTitleField.action = "validatePassword"
        paperSubTitleField.textColor = NSColor.whiteColor()
        paperSubTitleField.backgroundColor = NSColor.clearColor()
        paperSubTitleField.delegate = self
        paperTitleField.delegate = self
        paperTitleField.stringValue = "点击此处添加标题"
        paperSubTitleField.stringValue = "副标题 -> 右侧按钮添加封面"
        paperSubTitleField.bordered = false
        paperTitleField.bordered = false
        paperTitleField.focusRingType = .None
        paperSubTitleField.focusRingType = .None
        paperEditingView.moveToEndOfDocument(nil)
        
        
        headerImageMask.addSubview(paperTitleField)
        headerImageMask.addSubview(paperSubTitleField)
        
        
        //    let clickRec = NSClickGestureRecognizer(target: self, action: "handleMarginalClick:")
        //
        //    self.view.addGestureRecognizer(clickRec)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20
        paperEditingView.defaultParagraphStyle = style
        if isPaperExpired == true {
            var expiryAlert = NSAlert()
            expiryAlert.messageText = "抱歉！ _(:3 」∠)_ 此试用版本的Paper已经过期。若阁下希望继续使用，请点击Paper->Donation购买完整版本。出于对用户数据的保护，从现在起您仍然可以浏览曾经创建的Paper,但无法编辑或保存更改。若您决定不再使用Paper，请及时保存至其它文字处理工具。如阁下有任何疑问欢迎致邮 fongtinyik@hotmail.com 。 "
            expiryAlert.addButtonWithTitle("现在捐赠")
            expiryAlert.addButtonWithTitle("OK")
            expiryAlert.runModal()

            paperEditingView.editable = false
        }

        
    }
    
    
    
    func respondToPaperSettings(newFont: NSFont) {
        paperEditingView.textStorage?.addAttributes([NSFontAttributeName: newFont], range: paperEditingView.selectedRange())
    //    var highlightView = NSView(frame: rectForActiveRange())
//        highlightView.wantsLayer = true
//        highlightView.layer?.backgroundColor = CGColorCreateGenericRGB(0, 0, 0, 0.2)
//        paperEditingView.addSubview(highlightView)
        println("RESPOND")
        if newFont == NSFont(name: "Microsoft Yi Baiti", size: 21) {
            var quoteBlock = NSImage(named: "Quotes")
            quoteBlock?.size.height = 27
            quoteBlock?.size.width = 3
            var quoteAttachmentCell = NSTextAttachmentCell(imageCell: quoteBlock)
            var quoteAttachment = NSTextAttachment()
            quoteAttachment.attachmentCell = quoteAttachmentCell
            var attributedString = NSAttributedString(attachment: quoteAttachment)
            var lineRange = (paperEditingView.string! as NSString).lineRangeForRange(paperEditingView.selectedRange())
            paperEditingView.insertText("\n\n", replacementRange: NSMakeRange(paperEditingView.selectedRange().location, 0))
            paperEditingView.insertText("\n\n", replacementRange: NSMakeRange(paperEditingView.selectedRange().location + paperEditingView.selectedRange().length , 0))
            paperEditingView.textStorage?.insertAttributedString(attributedString, atIndex: paperEditingView.selectedRange().location) //此句去掉可以
            paperEditingView.textStorage?.insertAttributedString(attributedString, atIndex: paperEditingView.selectedRange().location + paperEditingView.selectedRange().length)
            paperEditingView.insertText("      ", replacementRange: NSMakeRange(paperEditingView.selectedRange().location, 0))
            paperEditingView.insertText(" ", replacementRange: NSMakeRange(paperEditingView.selectedRange().location + paperEditingView.selectedRange().length, 0))
            paperEditingView.showFindIndicatorForRange(paperEditingView.selectedRange())
            
            
        }
    }
    
    func respondToPaperBackgroundSettings(newBackgroundColor: NSColor) {
        paperEditingView.backgroundColor = newBackgroundColor
        if newBackgroundColor == NSColor(CGColor: CGColorCreateGenericRGB(30/255, 32/255, 40/255, 1)) {
            paperEditingView.textColor = NSColor(CGColor: CGColorCreateGenericRGB(1, 1, 1, 0.7))
        }else{
            paperEditingView.textColor = NSColor(CGColor: CGColorCreateGenericRGB(0, 0, 0, 1))
        }
    }
    
    
    func textView(textView: NSTextView, shouldChangeTextInRange affectedCharRange: NSRange, replacementString: String) -> Bool {
        if isPaperExpired == true {
            paperEditingView.editable = false
            return false
        }
        if replacementString == " " && affectedCharRange.location == (paperEditingView.string! as NSString).lineRangeForRange(paperEditingView.selectedRange()).location {
            println("SPACE")
            return false
        }
        
        return true
    }
    
    
    func lookUpTitles() {
        var attributedContent = paperEditingView.attributedString()
        contentComponents = []
        attributedContent.enumerateAttribute(NSFontAttributeName, inRange: NSMakeRange(0, attributedContent.length), options: nil) { (font, _range, d) -> Void in
            
            if (font as! NSFont).fontName == "WenQuanYiMicroHei" && (font as! NSFont).pointSize == 35 {
                var unicodeString = attributedContent.attributedSubstringFromRange(_range).string
                //                let data = NSData(bytes: unicodeString, length: Int(strlen(unicodeString)))
                //                var titleH1 = NSString(data: data, encoding: NSUTF8StringEncoding)
                var component = PaperContentComponent(style: .H1, ForText: unicodeString)
                self.contentComponents.append(component)
            }
            
            if (font as! NSFont).fontName == "WenQuanYiMicroHei" && (font as! NSFont).pointSize == 22 {
                var unicodeString = attributedContent.attributedSubstringFromRange(_range).string
                var component = PaperContentComponent(style: .H2 , ForText: unicodeString)
                self.contentComponents.append(component)
                
            }
            
            
            
        }
        
        
    }
    
    func resizeHeaderImage(image: NSImage) {
        
        var widthRatio = 1450*kWR/image.size.width
        var heightRatio = 1000*kHR/image.size.height
        if widthRatio > heightRatio {
            image.size.width = 1450*kWR
            image.size.height *= widthRatio
            
        }else {
            image.size.height = 1000*kHR
            
            image.size.width *= heightRatio
           
        }
        
    }
    
    func selectHeaderImage() {
        
        var headerImagePicker = NSOpenPanel()
        var fileType = ["png", "jpg", "jpeg"]
        headerImagePicker.allowedFileTypes = fileType
        headerImagePicker.allowsMultipleSelection = false
        headerImagePicker.title = "选择封面图像"
        var clickedButton = headerImagePicker.runModal()
        if clickedButton == NSModalResponseOK {
            headerImage = NSImage(contentsOfURL: headerImagePicker.URL!)
            
        }else {
            headerImage = NSImage(named: "w6")
            
        }
        
        resizeHeaderImage(headerImage!)
        
        paperHeaderImageView.image = headerImage
        
    }

    func saveAsPDF() {
        panel = NSSavePanel()
        panel.allowedFileTypes = ["pdf"]
        var currentBg = paperEditingView.backgroundColor
        if panel.runModal() == NSModalResponseOK {
            paperEditingView.backgroundColor = .whiteColor()
            sharedInfo = NSPrintInfo.sharedPrintInfo()
            sharedDict = sharedInfo.dictionary() as [NSObject : AnyObject]
            printInfoDict = sharedDict
            printInfoDict.updateValue(NSPrintSaveJob, forKey: NSPrintJobDisposition)
            printInfoDict.updateValue(panel.URL!.path!, forKey: NSPrintJobSavingURL)
            printInfo = NSPrintInfo(dictionary: printInfoDict )
            
            printInfo.horizontalPagination = NSPrintingPaginationMode.FitPagination
            printInfo.verticalPagination = .AutoPagination
            printInfo.verticallyCentered = false
            printOp = NSPrintOperation(view: paperEditingView, printInfo: printInfo)
            printOp.showsProgressPanel = true
            printOp.runOperation()
            
        }
        paperEditingView.backgroundColor = currentBg
        
    }

    func rectForActiveRange()-> NSRect {
        
        let LM = paperEditingView.layoutManager
        let range = LM!.glyphRangeForCharacterRange(paperEditingView.selectedRange(), actualCharacterRange: nil)
        var rect = LM?.boundingRectForGlyphRange(range, inTextContainer: paperEditingView.textContainer!)
        rect = NSOffsetRect(rect!, paperEditingView.textContainerOrigin.x, paperEditingView.textContainerOrigin.y)
       
        return rect!
        
        
    }
    
    func setIsPaperLockedDown(flag: Bool) {
        if flag == true && isPaperLockedDown == false {
            scroller.contentView.scrollToPoint(NSZeroPoint)
            paperTitleField.editable = false
            pickHeaderButton.enabled = false
            showSettingsButton.enabled = false
            showBookmarkButton.enabled = false
            tempTitleString = paperTitleField.stringValue
            tempSubTitleString = paperSubTitleField.stringValue
            paperSubTitleField.stringValue = "请在此输入密码来解锁Paper"
            paperTitleField.stringValue = "此份Paper已被锁定"
            isPaperLockedDown = true
        }
        
        if flag == false && isPaperLockedDown == true{
            
            isPaperLockedDown = false
            paperTitleField.editable = true
            pickHeaderButton.enabled = true
            showSettingsButton.enabled = true
            showBookmarkButton.enabled = true
            paperSubTitleField.stringValue = tempSubTitleString
            paperTitleField.stringValue = tempTitleString
        }
    }
    
    func validatePassword() {
        
        if isPaperLockedDown == true {
            //Validation code goes here
            
          
            
            if paperSubTitleField.stringValue == password {
                setIsPaperLockedDown(false)
            }
            
            else {
                paperTitleField.stringValue == "密码不正确"
               
            }
            
        }
        
        
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        
        let pickerImage = NSImage(named: "PickHeader")
        pickerImage?.size.width = 73
        pickerImage?.size.height = 73
        
        pickHeaderButton.image = NSImage(named: "PickHeader")
        var ssbImage = NSImage(named: "PaperSetting")
        ssbImage?.size.width = 33
        ssbImage?.size.height = 33
        showSettingsButton.image = ssbImage
        
        var sbmImage = NSImage(named: "Bookmark")
        sbmImage?.size.width  = 29
        sbmImage?.size.height = 155
        
        showBookmarkButton.image = sbmImage
        
        self._window.standardWindowButton(NSWindowButton.CloseButton)?.superview?.animator().alphaValue = 0
    }
    
    override func mouseExited(theEvent: NSEvent) {
        
        var highlightedImage = NSImage(named: "PickHeaderUnhighlighted")
        highlightedImage?.size.width = 73
        highlightedImage?.size.height = 73
        pickHeaderButton.image = highlightedImage
        var ssbImage = NSImage(named: "PaperSettingUnhighlighted")
        ssbImage?.size.width = 33
        ssbImage?.size.height = 33
        showSettingsButton.image = ssbImage
        var sbmImage = NSImage(named: "BookmarkUnhighlighted")
        sbmImage?.size.width  = 29
        sbmImage?.size.height = 155
        
        showBookmarkButton.image = sbmImage
        
        self._window.standardWindowButton(NSWindowButton.CloseButton)?.superview?.animator().alphaValue = 1
    }
    
   
    
    func textView(view: NSTextView, menu: NSMenu, forEvent event: NSEvent, atIndex charIndex: Int) -> NSMenu? {
        var menu = NSMenu(title: "使用Command+数字来设置字体")
        var tip = NSMenuItem(title: "请使用Command+数字来应用字体", action: "placeHolder", keyEquivalent: "")
        menu.insertItem(tip, atIndex: 0)
        
        return menu
    }
    
    
    func placeHolder()-> Void {
        // Do Nothing
        
        
    }
    func scrollerBoundDidChange() {
        if isPaperLockedDown == true {
        self.scroller.contentView.scrollToPoint(NSZeroPoint)
        }
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        if isPaperLockedDown == false {
             self._window.documentEdited = true
             
            if obj.object as! NSTextField == paperTitleField {
                titleString = paperTitleField.stringValue
            
            }
            
            if obj.object as! NSTextField == paperSubTitleField {
                subTitleString = paperSubTitleField.stringValue
            }
        }
    }
    
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPaperSettings" {
            if let settingVc = segue.destinationController as? PaperSettingsViewController {
                settingVc.delegate = self
                
                
            }
            
        }
        
        if segue.identifier == "showContents" {
            lookUpTitles()
            if let contentsVC = segue.destinationController as? ContentsPopOverController {
                contentsVC.contentComponents = self.contentComponents
            }
        }    }
    
   
  
  
    
}

