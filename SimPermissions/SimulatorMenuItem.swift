//
//  SimulatorMenuItem.swift
//  SimPermissions
//
//  Created by Nick Entin on 7/21/16.
//  Copyright © 2016 Nick Entin. All rights reserved.
//

import AppKit

class SimulatorMenuItem : NSMenuItem {
    var simulator: SimulatorModel
    var simulatorsManager: SimulatorManager
    var refresh: ()->()
    
    init(simulator: SimulatorModel, simulatorsManager: SimulatorManager, refresh: ()->()) {
        self.simulator = simulator
        self.simulatorsManager = simulatorsManager
        self.refresh = refresh
        
        super.init(title: " \(simulator.name) (\(simulator.system))", action: #selector(selectSimulator), keyEquivalent: "")
        
        self.target = self
        
        let menuItemView = SimulatorMenuItemView(simulator: simulator)
        menuItemView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(selectSimulator)))
        view = menuItemView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(title aString: String, action aSelector: Selector, keyEquivalent charCode: String) {
        fatalError("init(title:action:keyEquivalent:) has not been implemented")
    }
    
    @objc func selectSimulator(sender: AnyObject) {
        simulatorsManager.activeSimulator = simulator
        refresh()
    }
}
