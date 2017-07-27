//
//  EmergencyManager.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/6/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class EmergencyManager {
    
    private static var sharedInstance: EmergencyManager!
    
    var emergencies = [Emergency]()
    
    static func getInstance() -> EmergencyManager {
        if(sharedInstance == nil) {
            sharedInstance = EmergencyManager()
        }
        return sharedInstance
    }
    
    private init() {
        
    }
}
