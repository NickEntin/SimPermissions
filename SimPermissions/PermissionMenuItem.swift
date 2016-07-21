//
//  PermissionMenuItem.swift
//  SimPermissions
//
//  Created by Nick Entin on 7/21/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
//

import AppKit

class PermissionMenuItem : NSMenuItem {
    let permission: PermissionModel
    let permissionManager: PermissionManager
    let refresh: ()->()
    
    init(permission: PermissionModel, permissionManager: PermissionManager, refresh: ()->()) {
        self.permission = permission
        self.permissionManager = permissionManager
        self.refresh = refresh
        
        super.init(title: "", action: nil, keyEquivalent: "")
        
        let permissionView = PermissionMenuItemView(permission: permission)
        permissionView.allowButton.target = self
        permissionView.allowButton.action = #selector(grantPermission)
        permissionView.revokeButton.target = self
        permissionView.revokeButton.action = #selector(revokePermission)
        permissionView.deleteButton.target = self
        permissionView.deleteButton.action = #selector(clearPermission)
        view = permissionView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(title aString: String, action aSelector: Selector, keyEquivalent charCode: String) {
        fatalError("init(title:action:keyEquivalent:) has not been implemented")
    }
    
    @objc func grantPermission(sender: AnyObject) {
        do {
            try permissionManager.grantPermission(permission)
            refresh()
        } catch _ {
            print("Unable to grant permission")
        }
    }
    
    @objc func revokePermission(sender: AnyObject) {
        do {
            try permissionManager.revokePermission(permission)
            refresh()
        } catch _ {
            print("Unable to revoke permission")
        }
    }
    
    @objc func clearPermission(sender: AnyObject) {
        do {
            try permissionManager.deletePermission(permission)
            refresh()
        } catch _ {
            print("Unable to clear permission")
        }
    }
}
