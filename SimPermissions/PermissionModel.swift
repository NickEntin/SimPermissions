//
//  PermissionModel.swift
//  SimPermissions
//
//  Created by Nick Entin on 7/21/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
//

import Foundation

struct PermissionModel {
    let permissionType: String
    let appIdentifier: String
    let allowed: Bool
    let appMetadata: AppMetadata?
}
