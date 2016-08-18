//
//  SimulatorMenuItemView.swift
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

class SimulatorMenuItemView : NSView {
    let activeIcon: NSView
    let simulatorLabel: Label
    let systemLabel: Label
    let udidLabel: Label
    
    init(simulator: SimulatorModel) {
        activeIcon = NSView(frame: CGRect(x: 10, y: 12.5, width: 15, height: 15))
        activeIcon.wantsLayer = true
        activeIcon.layer?.cornerRadius = 10
        if simulator.booted {
            activeIcon.layer?.backgroundColor = NSColor.greenColor().CGColor
        } else {
            activeIcon.layer?.backgroundColor = NSColor.grayColor().CGColor
        }
        
        simulatorLabel = Label(frame: CGRect(x: 35, y: 15, width: 100, height: 20))
        simulatorLabel.stringValue = simulator.name
        
        systemLabel = Label(frame: CGRect(x: 170, y: 15, width: 80, height: 20))
        systemLabel.alignment = NSTextAlignment.Right
        systemLabel.stringValue = simulator.system
        
        udidLabel = Label(frame: CGRect(x: 35, y: 5, width: 220, height: 10))
        udidLabel.stringValue = simulator.udid
        udidLabel.font = NSFont.systemFontOfSize(9)
        
        super.init(frame: CGRect(x: 0, y: 0, width: 260, height: 40))
        
        addSubview(activeIcon)
        addSubview(simulatorLabel)
        addSubview(systemLabel)
        addSubview(udidLabel)
        
        addTrackingArea(NSTrackingArea(rect: self.bounds, options: [ NSTrackingAreaOptions.MouseEnteredAndExited, NSTrackingAreaOptions.ActiveAlways ], owner: self, userInfo: nil))
        
        wantsLayer = true
        applyDefaultViewStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDefaultViewStyle() {
        layer?.backgroundColor = NSColor.clearColor().CGColor
        simulatorLabel.textColor = NSColor.blackColor()
        systemLabel.textColor = NSColor.blackColor()
        udidLabel.textColor = NSColor.grayColor()
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        layer?.backgroundColor = NSColor(red: 46.0 / 255.0, green: 136.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0).CGColor
        simulatorLabel.textColor = NSColor.whiteColor()
        systemLabel.textColor = NSColor.whiteColor()
        udidLabel.textColor = NSColor.whiteColor()
    }
    
    override func mouseExited(theEvent: NSEvent) {
        applyDefaultViewStyle()
    }
}
