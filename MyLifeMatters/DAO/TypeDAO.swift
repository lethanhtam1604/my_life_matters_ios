//
//  TypeDAOImpl.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class TypeDAO {
    
    static var realm = try! Realm()
    
    static func getType(id: Int) -> Type? {
        let allType = realm.objects(Type.self)
        for type in allType {
            if(type.id == id){
                return type
            }
        }
        return nil
    }
    
    static func getAllTypes() -> [Type] {
        let allTypes = realm.objects(Type.self)
        return Array(allTypes)
    }
    
    static func addType(type: Type) {
        try! realm.write {
            realm.add(type)
        }
    }
    
    static func updateType(type: Type) {
        try! realm.write {
            realm.add(type, update: true)
        }
    }
    
    static func deleteType(id: Int) {
        try! realm.write {
            if let type = getType(id: id) {
                realm.delete(type)
            }
        }
    }
    
    static func deleteType(type: Type) {
        try! realm.write {
            realm.delete(type)
        }
    }
    
    static func getNextId() -> Int {
        let allType = realm.objects(Type.self)
        if(allType.count > 0) {
            let lastId = allType.max(ofProperty: "id") as Int?
            return lastId! + 1
        } else {
            return 1
        }
    }
}
