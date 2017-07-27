//
//  UserDAO.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class UserDAO {
    
    static var realm = try! Realm()
    
    static func getUser(id: Int) -> User? {
        let allUser = realm.objects(User.self)
        for user in allUser {
            if(user.id == id){
                return user
            }
        }
        return nil
    }
    
    static func getUserByAccountOrEmail(accountOrEmail: String) -> User? {
        let allUser = realm.objects(User.self)
        for user in allUser {
            if user.account == accountOrEmail || user.email == accountOrEmail {
                return user
            }
        }
        return nil
    }
    
    static func addUser(user: User) {
        try! realm.write {
            realm.add(user)
        }
    }
    
    static func updateUser(user: User) {
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    
    static func deleteUser(id: Int) {
        try! realm.write {
            if let user = getUser(id: id) {
                realm.delete(user)
            }
        }
    }
    
    static func deleteUser(user: User) {
        try! realm.write {
            realm.delete(user)
        }
    }
    
    static func getNextId() -> Int {
        let allUser = realm.objects(User.self)
        if(allUser.count > 0) {
            let lastId = allUser.max(ofProperty: "id") as Int?
            return lastId! + 1
        } else {
            return 1
        }
    }
}
