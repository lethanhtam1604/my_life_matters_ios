//
//  User.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/25/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    dynamic var id = 0
    dynamic var account = ""
    dynamic var firstname = ""
    dynamic var lastname = ""
    dynamic var phone = ""
    dynamic var email = ""
    dynamic var password = ""
    dynamic var birthday = ""
    dynamic var address = ""
    dynamic var token = ""
    dynamic var bypass = ""
    dynamic var transfer = ""
    dynamic var setup = ""
    dynamic var sent_bypass = false
    dynamic var sent_profile = false

    override static func primaryKey() -> String? {
        return "id"
    }
}
