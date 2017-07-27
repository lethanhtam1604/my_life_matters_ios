//
//  MultimediaDAOImpl.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class MultimediaDAO {
    
    static var realm = try! Realm()
    
    static func getMultimedia(id: Int) -> Multimedia? {
        let allMultimedia = realm.objects(Multimedia.self)
        for multimedia in allMultimedia {
            if(multimedia.id == id){
                return multimedia
            }
        }
        return nil
    }
    
    static func getMultimediaByUserIdAndTypeId(userId: Int, typeID: Int) -> [Multimedia] {
        var result = [Multimedia]()
        let allMultimedia = realm.objects(Multimedia.self)
        for multimedia in allMultimedia {
            if multimedia.user_id == userId && multimedia.type_id == typeID {
                 result.append(multimedia)
            }
        }
        return result
    }
    
    static func getAllMultimedias() -> [Multimedia] {
        let allMultimedias = realm.objects(Multimedia.self)
        return Array(allMultimedias)
    }
    
    static func addMultimedia(multimedia: Multimedia) {
        try! realm.write {
            realm.add(multimedia)
        }
    }
    
    static func updateMultimedia(multimedia: Multimedia) {
        try! realm.write {
            realm.add(multimedia, update: true)
        }
    }
    
    static func deleteMultimedia(id: Int) {
        try! realm.write {
            if let multimedia = getMultimedia(id: id) {
                realm.delete(multimedia)
            }
        }
    }
    
    static func deleteMultimedia(multimedia: Multimedia) {
        try! realm.write {
            realm.delete(multimedia)
        }
    }
    
    static func getNextId() -> Int {
        let allMultimedia = realm.objects(Multimedia.self)
        if(allMultimedia.count > 0) {
            let lastId = allMultimedia.max(ofProperty: "id") as Int?
            return lastId! + 1
        } else {
            return 1
        }
    }
    
    static func querySearchMultimedia(userId: Int, keyword: String) -> [Multimedia] {
        if keyword == "" {
            return getAllMultimedias()
        }
        
        let predicate = NSPredicate(format: "user_id = \(userId) AND path CONTAINS[c] %@",keyword)
        
        let result = realm.objects(Multimedia.self).filter(predicate)
        return Array(result)
    }
}
