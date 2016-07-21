//
//  Label.swift
//  SimPermissions
//
//  Created by Nick Entin on 7/25/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
//

import AppKit

class Label : NSTextField {
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.bezeled = false
        self.drawsBackground = false
        self.editable = false
        self.selectable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
