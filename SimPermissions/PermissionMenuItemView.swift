//
//  PermissionMenuItemView.swift
//  SimPermissions
//
//  Copyright (c) 2016 Nick Entin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import AppKit

class PermissionMenuItemView : NSView {
    let allowButton: NSButton
    let revokeButton: NSButton
    let deleteButton: NSButton
    
    init(permission: PermissionModel) {
        allowButton = NSButton(frame: NSRect(x: 0, y: 5, width: 106, height: 30))
        revokeButton = NSButton(frame: NSRect(x: 107, y: 5, width: 106, height: 30))
        deleteButton = NSButton(frame: NSRect(x: 215, y: 5, width: 106, height: 30))
        
        super.init(frame: NSRect(x: 0, y: 0, width: 320, height: 80))
        
        let appIcon = NSImageView(frame: NSRect(x: 10, y: 42, width: 35, height: 35))
        if let metadata = permission.appMetadata,
            let image = NSImage(contentsOfFile: metadata.iconPath) {
            appIcon.image = image
        } else if let defaultImage = NSImage(named: "MissingAppIcon") {
            appIcon.image = defaultImage
        }
        appIcon.wantsLayer = true
        appIcon.layer?.cornerRadius = 9.0
        addSubview(appIcon)
        
        let appLabel = Label(frame: NSRect(x: 50, y: 55, width: 180, height: 20))
        if let metadata = permission.appMetadata {
            let titleString: NSMutableAttributedString = NSMutableAttributedString(string: "\(metadata.displayName)  ")
            titleString.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFontOfSize(12.0), range: NSMakeRange(0, titleString.length))
            
            let versionString: NSMutableAttributedString = NSMutableAttributedString(string: "\(metadata.version)")
            versionString.addAttribute(NSForegroundColorAttributeName, value: NSColor.grayColor(), range: NSMakeRange(0, versionString.length))
            titleString.appendAttributedString(versionString)
            
            appLabel.attributedStringValue = titleString
        } else {
            appLabel.stringValue = permission.appIdentifier
        }
        addSubview(appLabel)
        
        let appIdLabel = Label(frame: NSRect(x: 50, y: 40, width: 260, height: 15))
        appIdLabel.stringValue = permission.appIdentifier
        appIdLabel.font = NSFont(name: (appIdLabel.font?.fontName)!, size: 10.0)
        appIdLabel.textColor = NSColor.darkGrayColor()
        addSubview(appIdLabel)
        
        let serviceLabel = Label(frame: NSRect(x: 230, y: 55, width: 80, height: 20))
        serviceLabel.stringValue = serviceDisplayName[permission.permissionType] ?? "Unknown"
        serviceLabel.alignment = NSTextAlignment.Right
        addSubview(serviceLabel)
        
        allowButton.title = "GRANT"
        allowButton.bordered = false
        addSubview(allowButton)
        
        revokeButton.title = "REVOKE"
        revokeButton.bordered = false
        addSubview(revokeButton)
        
        deleteButton.title = "CLEAR"
        deleteButton.bordered = false
        addSubview(deleteButton)
        
        let buttonsTopBorder = NSView(frame: NSRect(x: 0, y: 35, width: 320, height: 1))
        buttonsTopBorder.wantsLayer = true
        buttonsTopBorder.layer?.backgroundColor = NSColor.grayColor().CGColor
        addSubview(buttonsTopBorder)
        
        let buttonsVerticalBorder1 = NSView(frame: NSRect(x: 106, y: 5, width: 1, height: 30))
        buttonsVerticalBorder1.wantsLayer = true
        buttonsVerticalBorder1.layer?.backgroundColor = NSColor.grayColor().CGColor
        addSubview(buttonsVerticalBorder1)
        
        let buttonsVerticalBorder2 = NSView(frame: NSRect(x: 214, y: 5, width: 1, height: 30))
        buttonsVerticalBorder2.wantsLayer = true
        buttonsVerticalBorder2.layer?.backgroundColor = NSColor.grayColor().CGColor
        addSubview(buttonsVerticalBorder2)
        
        let buttonsBottomBorder = NSView(frame: NSRect(x: 0, y: 5, width: 320, height: 1))
        buttonsBottomBorder.wantsLayer = true
        buttonsBottomBorder.layer?.backgroundColor = NSColor.grayColor().CGColor
        addSubview(buttonsBottomBorder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let serviceDisplayName: [String : String] = [
        "kTCCServiceAddressBook": "Contacts",
        "kTCCServiceCalendar": "Calendar",
        "kTCCServiceReminders": "Reminders",
        "kTCCServicePhotos": "Photos",
        "kTCCServiceCamera": "Camera",
        "kTCCServiceMediaLibrary": "Media Library",
    ]
}
