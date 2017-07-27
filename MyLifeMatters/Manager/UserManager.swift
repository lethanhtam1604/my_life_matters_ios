//
//  UserManager.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/9/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class UserManager {

    private static var sharedInstance: UserManager!
    
    var user: User!
    
    static func getInstance() -> UserManager {
        if(sharedInstance == nil) {
            sharedInstance = UserManager()
        }
        return sharedInstance
    }
    
    private init() {
        
    }
}
