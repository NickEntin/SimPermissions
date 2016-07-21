//
//  AppDelegate.swift
//  SimPermissions
//
//  Created by Nick Entin on 7/20/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var statusItem: NSStatusItem
    var statusItemMenu: NSMenu
    
    let simulatorManager: SimulatorManager
    let appManager: AppManager
    let permissionManager: PermissionManager
    let menuManager: MenuManager
    let fileMonitor: FileMonitor
    
    override init() {
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusItem.image = NSImage(named: "StatusBarIcon")
        
        statusItemMenu = NSMenu()
        statusItem.menu = statusItemMenu
        
        fileMonitor = FileMonitor()
        simulatorManager = SimulatorManager(fileMonitor: fileMonitor)
        appManager = AppManager()
        permissionManager = PermissionManager(simulatorManager: simulatorManager)
        menuManager = MenuManager(simulatorManager: simulatorManager, appManager: appManager, permissionManager: permissionManager, fileMonitor: fileMonitor, menu: statusItemMenu)
        
        super.init()
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        PFMoveToApplicationsFolderIfNecessary()
        menuManager.setupMenuItems()
    }
}
