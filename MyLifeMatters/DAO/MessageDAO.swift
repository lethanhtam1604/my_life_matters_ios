//
//  MessageDAOImpl.swift
//  MyLifeMatters
//
//  Created by MD101 on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

class MessageDAO {
    
    static var realm = try! Realm()
    
    static func getMessage(id: Int) -> Message? {
        let allMessage = realm.objects(Message.self)
        for message in allMessage {
            if(message.id == id){
                return message
            }
        }
        return nil
    }
    
    static func getMessagesByUserID(userID: Int) -> [Message] {
        var result = [Message]()
        let allMessage = realm.objects(Message.self)
        for message in allMessage {
            if(message.user_id == userID){
                result.append(message)
            }
        }
        return result
    }
    
    static func getAllMessages() -> [Message] {
        let allMessages = realm.objects(Message.self)
        return Array(allMessages)
    }
    
    static func addMessage(message: Message) {
        try! realm.write {
            realm.add(message)
        }
    }
    
    static func updateMessage(message: Message) {
        try! realm.write {
            realm.add(message, update: true)
        }
    }
    
    static func deleteMessage(id: Int) {
        try! realm.write {
            if let message = getMessage(id: id) {
                realm.delete(message)
            }
        }
    }
    
    static func deleteMessage(message: Message) {
        try! realm.write {
            realm.delete(message)
        }
    }
    
    static func getNextId() -> Int {
        let allMessage = realm.objects(Message.self)
        if(allMessage.count > 0) {
            let lastId = allMessage.max(ofProperty: "id") as Int?
            return lastId! + 1
        } else {
            return 1
        }
    }
    
    static func querySearchMessage(userId: Int, keyword: String) -> [Message] {
        if keyword == "" {
            return getAllMessages()
        }
        
        let predicate = NSPredicate(format: "user_id = \(userId) AND content CONTAINS[c] %@",keyword)
        
        let result = realm.objects(Message.self).filter(predicate)
        return Array(result)
    }
}
