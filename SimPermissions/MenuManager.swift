//
//  MenuManager.swift
//  SimPermissions
//
//  Created by Nick Entin on 7/25/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
//

import AppKit

class MenuManager : NSObject {
    let simulatorManager: SimulatorManager
    let appManager: AppManager
    let permissionManager: PermissionManager
    
    let menu: NSMenu
    
    init(simulatorManager: SimulatorManager, appManager: AppManager, permissionManager: PermissionManager, fileMonitor: FileMonitor, menu: NSMenu) {
        self.simulatorManager = simulatorManager
        self.appManager = appManager
        self.permissionManager = permissionManager
        self.menu = menu
        
        super.init()
        
        fileMonitor.refresh = refreshMenu
    }
    
    func setupMenuItems() {
        menu.removeAllItems()
        
        if let _ = simulatorManager.activeSimulator {
            menu.addItem(PermissionHeaderMenuItem(simulatorManager: simulatorManager, refresh: refreshMenu))
            addMenuItemsForApps()
        } else {
            addMenuItemsForSimulators()
        }
        
        let menuItem = NSMenuItem(title: "Refresh List", action: #selector(refreshMenu), keyEquivalent: "r")
        menuItem.target = self
        menu.addItem(menuItem)
        menu.addItem(NSMenuItem(title: "Quit SimPermissions", action: Selector("terminate:"), keyEquivalent: "q"))
    }
    
    @objc func refreshMenu() {
        setupMenuItems()
    }
    
    func addMenuItemsForApps() {
        do {
            let permissions = try permissionManager.getPermissions()
            for permission in permissions {
                menu.addItem(PermissionMenuItem(permission: permission, permissionManager: permissionManager, refresh: setupMenuItems))
            }
            if permissions.count == 0 {
                menu.addItem(NSMenuItem(title: "No permissions found", action: nil, keyEquivalent: ""))
                menu.addItem(NSMenuItem.separatorItem())
            }
        } catch _ {
            menu.addItem(NSMenuItem(title: "No permissions found", action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem.separatorItem())
        }
    }
    
    func addMenuItemsForSimulators() {
        menu.addItem(NSMenuItem(title: "Select a simulator:", action: nil, keyEquivalent: ""))
        
        if let simulators = simulatorManager.getSimulators() {
            for simulator in simulators {
                menu.addItem(SimulatorMenuItem(simulator: simulator, simulatorsManager: simulatorManager, refresh: setupMenuItems))
            }
        } else {
            print("No simulators found")
            menu.addItem(NSMenuItem(title: "  No simulators found", action: nil, keyEquivalent: ""))
        }
        
        menu.addItem(NSMenuItem.separatorItem())
    }
}
