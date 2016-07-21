//
//  AppManager.swift
//  SimPermissions
//
//  Created by Nick Entin on 7/21/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
//

import Foundation

class AppManager {
    func getAppMetadata(udid: String, bundleIdentifier: String) -> AppMetadata? {
        let fileManager = NSFileManager.defaultManager()
        let basePath = "/Users/\(NSUserName())/Library/Developer/CoreSimulator/Devices/\(udid)/data/Containers/Bundle/Application"

        do {
            let appDirectories: [String] = try fileManager.contentsOfDirectoryAtPath(basePath)
            for appDirectory in appDirectories {
                if appDirectory == ".DS_Store" {
                    continue
                }
                let appContents: [String] = try fileManager.contentsOfDirectoryAtPath("\(basePath)/\(appDirectory)")
                for appContent in appContents {
                    if appContent.hasSuffix(".app") {
                        if let appInfo = NSDictionary(contentsOfFile: "\(basePath)/\(appDirectory)/\(appContent)/Info.plist") {
                            if let bundleName: String = appInfo["CFBundleName"] as? String,
                                let bundleId: String = appInfo["CFBundleIdentifier"] as? String,
                                let appVersion: String = appInfo["CFBundleShortVersionString"] as? String {
                                if bundleId == bundleIdentifier {
                                    let iconPath = "\(basePath)/\(appDirectory)/\(appContent)/AppIcon60x60@3x.png"
                                    let meta = AppMetadata(
                                        uuid: appDirectory,
                                        displayName: bundleName,
                                        version: appVersion,
                                        iconPath: iconPath
                                    )
                                    return meta
                                }
                            }
                        }
                    }
                }
            }
        } catch _ {
            
        }

        return nil
    }
}
