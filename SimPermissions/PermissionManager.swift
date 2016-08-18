//
//  PermissionsManager.swift
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

import Foundation
import SQLite

class PermissionManager {
    enum PermissionManagerError : ErrorType {
        case NoActiveSimulator
    }
    
    let simulatorManager: SimulatorManager
    let appManager: AppManager
    
    init(simulatorManager: SimulatorManager) {
        self.simulatorManager = simulatorManager
        self.appManager = AppManager()
    }
    
    func getPermissions() throws -> [PermissionModel] {
        if let udid = simulatorManager.activeSimulator?.udid {
            let db = try Connection(path(udid))
            
            let access = Table("access")
            let service = Expression<String>("service")
            let client = Expression<String>("client")
            let allowed = Expression<Int>("allowed")
            
            var permissions: [PermissionModel] = []
            
            for row in try db.prepare(access) {
                if (row[client].rangeOfString("com.apple") == nil) {
                    let metadata = appManager.getAppMetadata(udid, bundleIdentifier: row[client])
                    permissions.append(PermissionModel(
                        permissionType: row[service],
                        appIdentifier: row[client],
                        allowed: (row[allowed] == 1),
                        appMetadata: metadata
                        ))
                }
            }
            
            return permissions
        } else {
            throw PermissionManagerError.NoActiveSimulator
        }
    }
    
    func grantPermission(permission: PermissionModel) throws {
        if let udid = simulatorManager.activeSimulator?.udid {
            let db = try Connection(path(udid))
            
            let access = Table("access")
            let service = Expression<String>("service")
            let client = Expression<String>("client")
            let allowed = Expression<Int>("allowed")
            
            let rows = access.filter(service == permission.permissionType && client == permission.appIdentifier)
            try db.run(rows.update(allowed <- 1))
        } else {
            throw PermissionManagerError.NoActiveSimulator
        }
    }
    
    func revokePermission(permission: PermissionModel) throws {
        if let udid = simulatorManager.activeSimulator?.udid {
            let db = try Connection(path(udid))
            
            let access = Table("access")
            let service = Expression<String>("service")
            let client = Expression<String>("client")
            let allowed = Expression<Int>("allowed")
            
            let rows = access.filter(service == permission.permissionType && client == permission.appIdentifier)
            try db.run(rows.update(allowed <- 0))
        } else {
            throw PermissionManagerError.NoActiveSimulator
        }
    }
    
    func deletePermission(permission: PermissionModel) throws {
        if let udid = simulatorManager.activeSimulator?.udid {
            let db = try Connection(path(udid))
            
            let access = Table("access")
            let service = Expression<String>("service")
            let client = Expression<String>("client")
            
            let rows = access.filter(service == permission.permissionType && client == permission.appIdentifier)
            try db.run(rows.delete())
        } else {
            throw PermissionManagerError.NoActiveSimulator
        }
    }
    
    func path(udid: String) -> String {
        return "/Users/\(NSUserName())/Library/Developer/CoreSimulator/Devices/\(udid)/data/Library/TCC/TCC.db"
    }
}
