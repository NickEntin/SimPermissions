//
//  SimulatorsManager.swift
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
