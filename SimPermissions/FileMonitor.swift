//
//  FileMonitor.swift
//  SimPermissions
//
//  Created by Nick Entin on 8/1/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
//

import Foundation
import SwiftFSWatcher

class FileMonitor {
    var fileWatcher: SwiftFSWatcher?
    var refresh: ()->() = {}
    
    func monitorChangesForSimulator(simulator: SimulatorModel) {
        stopMonitoring()
        
        let fileWatcher = SwiftFSWatcher(["/Users/\(NSUserName())/Library/Developer/CoreSimulator/Devices/\(simulator.udid)/data/Library/TCC/"])
        fileWatcher.watch { changeEvents in
            self.refresh()
        }
        self.fileWatcher = fileWatcher
    }
    
    func stopMonitoring() {
        self.fileWatcher?.pause()
        self.fileWatcher = nil
    }
}
