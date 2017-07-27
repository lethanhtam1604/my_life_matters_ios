//
//  Message.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/25/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class Message: Object{
    
    dynamic var id = 0
    dynamic var user_id = 0
    dynamic var content = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
