//
//  PermissionMenuItem.swift
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
