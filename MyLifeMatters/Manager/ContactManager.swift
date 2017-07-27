//
//  ContactManager.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/6/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class ContactManager {
    
    private static var sharedInstance: ContactManager!
    
    var contacts = [Contact]()
    
    static func getInstance() -> ContactManager {
        if(sharedInstance == nil) {
            sharedInstance = ContactManager()
        }
        return sharedInstance
    }
    
    private init() {

    }
    
    func sortByNumber() {
        contacts.sort(by: { $0.number < $1.number })
    }
}
