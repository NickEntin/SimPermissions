//
//  PermissionHeaderMenuItem.swift
//  SimPermissions
//
//  Created by Nick Entin on 7/29/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
//

import AppKit

class PermissionHeaderMenuItem : NSMenuItem {
    let simulatorManager: SimulatorManager
    let refresh: () -> ()
    
    init(simulatorManager: SimulatorManager, refresh: ()->()) {
        self.simulatorManager = simulatorManager
        self.refresh = refresh
        
        super.init(title: "", action: nil, keyEquivalent: "")
        
        if let simulator = simulatorManager.activeSimulator {
            let headerView = PermissionHeaderMenuItemView(simulator: simulator)
            headerView.backButton.target = self
            headerView.backButton.action = #selector(back)
            view = headerView
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func back() {
        simulatorManager.activeSimulator = nil
        refresh()
    }
}
