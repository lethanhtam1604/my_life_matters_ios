//
//  ContactDAOImpl.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class ContactDAO {
    
    static var realm = try! Realm()
    
    static func getContact(id: Int) -> Contact? {
        let allContact = realm.objects(Contact.self)
        for contact in allContact {
            if(contact.id == id){
                return contact
            }
        }
        return nil
    }
    
    static func getContactsByUserID(userID: Int) -> [Contact] {
        var result = [Contact]()
        let allContact = realm.objects(Contact.self)
        for contact in allContact {
            if(contact.user_id == userID){
                result.append(contact)
            }
        }
        return result
    }
    
    static func getAllContacts() -> [Contact] {
        let allContacts = realm.objects(Contact.self)
        return Array(allContacts)
    }
    
    static func addContact(contact: Contact) {
        try! realm.write {
            realm.add(contact)
        }
    }
   
    static func updateContact(contact: Contact) {
        try! realm.write {
            realm.add(contact, update: true)
        }
    }
    
    static func deleteContact(id: Int) {
        try! realm.write {
            if let contact = getContact(id: id) {
                realm.delete(contact)
            }
        }
    }
    
    static func deleteContact(contact: Contact) {
        try! realm.write {
            realm.delete(contact)
        }
    }
    
    static func getNextId() -> Int {
        let allContact = realm.objects(Contact.self)
        if(allContact.count > 0) {
            let lastId = allContact.max(ofProperty: "id") as Int?
            return lastId! + 1
        } else {
            return 1
        }
    }
    
    static func getNumberMaxByUserId(userId: Int) -> Int {
        let allContact = getContactsByUserID(userID: userId)
        var numberMax = 0
        if(allContact.count > 0) {
            for contact in allContact {
                if contact.number > numberMax {
                    numberMax = contact.number
                }
            }
        }
        
        return numberMax
    }
    
    static func querySearchContact(userId: Int, keyword: String) -> [Contact] {
        if keyword == "" {
            return getAllContacts()
        }
        
        let predicate = NSPredicate(format: "user_id = \(userId) AND profile CONTAINS[c] %@ OR firstname CONTAINS[c] %@ OR lastname CONTAINS[c] %@ OR phone CONTAINS[c] %@ OR email CONTAINS[c] %@ OR relationship CONTAINS[c] %@", keyword, keyword, keyword, keyword, keyword, keyword)
        
        let result = realm.objects(Contact.self).filter(predicate)
        return Array(result)
    }
}
