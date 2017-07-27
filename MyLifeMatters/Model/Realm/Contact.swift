//
//  Contact.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/25/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object {
    
    dynamic var id = 0
    dynamic var user_id = 0
    dynamic var profile = ""
    dynamic var firstname = ""
    dynamic var lastname = ""
    dynamic var phone = ""
    dynamic var email = ""
    dynamic var relationship = ""
    dynamic var number = 0
    dynamic var sent = false

    override static func primaryKey() -> String? {
        return "id"
    }
}
