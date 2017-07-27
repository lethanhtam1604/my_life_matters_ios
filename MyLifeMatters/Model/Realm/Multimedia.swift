//
//  Multimedia.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/25/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class Multimedia: Object{
    
    dynamic var id = 0
    dynamic var user_id = 0
    dynamic var name = ""
    dynamic var type_id = 0
    dynamic var path = ""
    dynamic var sent = false
    dynamic var choose = false

    override static func primaryKey() -> String? {
        return "id"
    }
}
