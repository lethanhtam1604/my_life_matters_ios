//
//  Type.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/25/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class Type: Object {
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var type_extension = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
