//
//  SimulatorsManager.swift
//  SimPermissions
//
//  Created by Nick Entin on 7/21/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
//

import Foundation

class SimulatorManager {
    let fileMonitor: FileMonitor
    
    var activeSimulator: SimulatorModel? {
        didSet {
            if let activeSimulator = activeSimulator {
                fileMonitor.monitorChangesForSimulator(activeSimulator)
            } else {
                fileMonitor.stopMonitoring()
            }
        }
    }
    
    init(fileMonitor: FileMonitor) {
        self.fileMonitor = fileMonitor
    }
    
    func getSimulators() -> [SimulatorModel]? {
        var simulators: [SimulatorModel] = []
        
        if let devicesData = execute("xcrun", "simctl", "list", "devices", "--json") {
            do {
                if let json: [String : AnyObject] = try NSJSONSerialization.JSONObjectWithData(devicesData, options: NSJSONReadingOptions(rawValue: 0)) as? [String : AnyObject],
                    let deviceTypes: [String : AnyObject] = json["devices"] as? [String : AnyObject] {
                    for (deviceType, devices) in deviceTypes {
                        if deviceType.rangeOfString("iOS") != nil {
                            if let devices = devices as? [[String:String]] {
                                simulators.appendContentsOf(simulatorsFromDescriptionList(devices, system: deviceType))
                            }
                        }
                    }
                    return simulators
                }
            } catch _ {
                print ("Could not parse JSON")
            }
        } else {
            print("Could not load devices")
        }
        return nil
    }
    
    func simulatorsFromDescriptionList(descriptionList: [[String:String]], system: String) -> [SimulatorModel] {
        var simulators: [SimulatorModel] = []
        for device in descriptionList {
            if let name = device["name"], udid = device["udid"], state = device["state"] {
                let booted = (state == "Booted")
                    simulators.append(SimulatorModel(
                        name: name,
                        system: system,
                        udid: udid,
                        booted: booted
                        ))
            }
            
        }
        return simulators
    }
    
    func execute(args: String...) -> NSData? {
        let task = NSTask()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        
        let outputPipe = NSPipe()
        task.standardOutput = outputPipe
        
        task.launch()
        task.waitUntilExit()
        
        let fileHandle = outputPipe.fileHandleForReading;
        let data = fileHandle.readDataToEndOfFile()
        return data
    }
}
