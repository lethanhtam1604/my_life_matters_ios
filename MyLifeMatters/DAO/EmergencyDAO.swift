//
//  EmergencyDAOImpl.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class EmergencyDAO {
    
    static var realm = try! Realm()
    
    static func getEmergency(id: Int) -> Emergency? {
        let allEmergency = realm.objects(Emergency.self)
        for emergency in allEmergency {
            if(emergency.id == id){
                return emergency
            }
        }
        return nil
    }
    
    static func getAllEmergencys() -> [Emergency] {
        let allEmergencys = realm.objects(Emergency.self)
        return Array(allEmergencys)
    }
    
    static func getEmergenciesByUserID(userID: Int) -> [Emergency] {
        var result = [Emergency]()
        let allEmergency = realm.objects(Emergency.self)
        for emergency in allEmergency {
            if(emergency.user_id == userID){
                result.append(emergency)
            }
        }
        return result
    }
    
    static func addEmergency(emergency: Emergency) {
        try! realm.write {
            realm.add(emergency)
        }
    }
    
    static func updateEmergency(emergency: Emergency) {
        try! realm.write {
            realm.add(emergency, update: true)
        }
    }
    
    static func deleteEmergency(id: Int) {
        try! realm.write {
            if let emergency = getEmergency(id: id) {
                realm.delete(emergency)
            }
        }
    }
    static func deleteEmergency(emergency: Emergency) {
        try! realm.write {
            realm.delete(emergency)
        }
    }
    
    static func getNextId() -> Int {
        let allEmergency = realm.objects(Emergency.self)
        if(allEmergency.count > 0) {
            let lastId = allEmergency.max(ofProperty: "id") as Int?
            return lastId! + 1
        } else {
            return 1
        }
    }
    
    static func querySearchEmergency(userId: Int, keyword: String) -> [Emergency] {
        if keyword == "" {
            return getAllEmergencys()
        }
        
        let predicate = NSPredicate(format: "user_id = \(userId) AND name CONTAINS[c] %@ OR phone CONTAINS[c] %@", keyword, keyword)
        
        let result = realm.objects(Emergency.self).filter(predicate)
        return Array(result)
    }
}
