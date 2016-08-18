//
//  MenuManager.swift
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
