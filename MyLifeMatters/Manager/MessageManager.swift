
//
//  MessageManager.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/21/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class MessageManager {

    private static var sharedInstance: MessageManager!
    
    var messages = [Message]()
    
    static func getInstance() -> MessageManager {
        if(sharedInstance == nil) {
            sharedInstance = MessageManager()
        }
        return sharedInstance
    }
    
    private init() {
        
    }
}
