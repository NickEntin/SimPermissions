//
//  PermissionHeaderMenuItemView.swift
//  SimPermissions
//
//  Created by Nick Entin on 7/29/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
//

import AppKit

class PermissionHeaderMenuItemView : NSView {
    let backButton: NSButton
    
    init(simulator: SimulatorModel) {
        backButton = NSButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        backButton.title = "< BACK"
        backButton.bordered = false
        
        let simulatorLabel = Label(frame: CGRect(x: 60, y: 14, width: 200, height: 16))
        simulatorLabel.stringValue = "\(simulator.name) (\(simulator.system))"
        simulatorLabel.font = NSFont.systemFontOfSize(16)
        simulatorLabel.textColor = NSColor.grayColor()
        simulatorLabel.alignment = NSCenterTextAlignment
        
        super.init(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        
        addSubview(backButton)
        addSubview(simulatorLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
