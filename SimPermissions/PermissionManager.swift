//
//  PermissionsManager.swift
//  SimPermissions
//
//  Created by Nick Entin on 7/20/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
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
