//
//  CivilManager.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/6/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class CivilManager {

    private static var sharedInstance: CivilManager!
    
    var civils = [Civil]()
    
    static func getInstance() -> CivilManager {
        if(sharedInstance == nil) {
            sharedInstance = CivilManager()
        }
        return sharedInstance
    }
    
    private init() {
    
    }
}
