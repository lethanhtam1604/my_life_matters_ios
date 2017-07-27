//
//  CivilDAOImpl.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class CivilDAO {
    
    static var realm = try! Realm()
    
    static func getCivil(id: Int) -> Civil? {
        let allCivil = realm.objects(Civil.self)
        for civil in allCivil {
            if(civil.id == id){
                return civil
            }
        }
        return nil
    }
    
    static func getAllCivils() -> [Civil] {
        let allCivils = realm.objects(Civil.self)
        return Array(allCivils)
    }
    
    static func getCivilsByUserID(userID: Int) -> [Civil] {
        var result = [Civil]()
        let allCivil = realm.objects(Civil.self)
        for civil in allCivil {
            if(civil.user_id == userID){
                result.append(civil)
            }
        }
        return result
    }
    
    static func addCivil(civil: Civil) {
        try! realm.write {
            realm.add(civil)
        }
    }
    
    static func updateCivil(civil: Civil) {
        try! realm.write {
            realm.add(civil, update: true)
        }
    }
    
    static func deleteCivil(id: Int) {
        try! realm.write {
            if let civil = getCivil(id: id) {
                realm.delete(civil)
            }
        }
    }
    
    static func deleteCivil(civil: Civil) {
        try! realm.write {
            realm.delete(civil)
        }
    }
    
    static func getNextId() -> Int {
        let allCivil = realm.objects(Civil.self)
        if(allCivil.count > 0) {
            let lastId = allCivil.max(ofProperty: "id") as Int?
            return lastId! + 1
        } else {
            return 1
        }
    }
    
    static func querySearchCivil(userId: Int, keyword: String) -> [Civil] {
        if keyword == "" {
            return getAllCivils()
        }
        
        let predicate = NSPredicate(format: "user_id = \(userId) AND name CONTAINS[c] %@ OR phone CONTAINS[c] %@ OR email CONTAINS[c] %@ OR address CONTAINS[c] %@ OR website CONTAINS[c] %@",keyword, keyword, keyword, keyword, keyword)

        let result = realm.objects(Civil.self).filter(predicate)
        return Array(result)
    }
}
