//
//  DataManager.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/12/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import Alamofire
import EVReflection
import ObjectMapper
import SwiftyJSON

protocol LoadDataDelegate {
    func finish(thread: Int)
}

class DataManager {
    
    static func loadData(loadDataDelegate: LoadDataDelegate?) {
        var thread = 0
        
        let userID = UserDefaultManager.getInstance().getCurrentUser()
        let user = UserDAO.getUser(id: userID)!
        
        CivilManager.getInstance().civils = [Civil]()
        EmergencyManager.getInstance().emergencies = [Emergency]()
        ContactManager.getInstance().contacts = [Contact]()
        MessageManager.getInstance().messages = [Message]()
        MultimediaManager.getInstance().audios = MultimediaDAO.getMultimediaByUserIdAndTypeId(userId: userID, typeID: 5)
        
        var url = Global.baseURL + "civil/user/" + String(user.id) + "?token=" + user.token
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let json = JSON(value)
                    for item in json["data"].arrayValue {
                        let newCivil = Civil()
                        newCivil.id = item["id"].intValue
                        newCivil.user_id = item["user_id"].intValue
                        newCivil.name = item["name"].stringValue
                        newCivil.phone = item["phone"].stringValue
                        newCivil.email = item["email"].stringValue
                        newCivil.address = item["address"].stringValue
                        newCivil.website = item["website"].stringValue
                        newCivil.sent = true
                        
                        CivilDAO.addCivil(civil: newCivil)
                        CivilManager.getInstance().civils.append(newCivil)
                    }
                    thread = thread + 1
                    if loadDataDelegate != nil {
                        loadDataDelegate?.finish(thread: thread)
                    }
                }
            case .failure(_):
                return
            }
        }
        
        url = Global.baseURL + "emergency/user/" + String(user.id) + "?token=" + user.token
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let json = JSON(value)
                    for item in json["data"].arrayValue {
                        let newEmergency = Emergency()
                        newEmergency.id = item["id"].intValue
                        newEmergency.user_id = item["user_id"].intValue
                        newEmergency.name = item["name"].stringValue
                        newEmergency.phone = item["phone"].stringValue
                        newEmergency.sent = true
                        
                        EmergencyDAO.addEmergency(emergency: newEmergency)
                        EmergencyManager.getInstance().emergencies.append(newEmergency)
                    }
                    thread = thread + 1
                    if loadDataDelegate != nil {
                        loadDataDelegate?.finish(thread: thread)
                    }
                }
            case .failure(_):
                return
            }
        }
        
        url = Global.baseURL + "contact/user/" + String(user.id) + "?token=" + user.token
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let json = JSON(value)
                    for item in json["data"].arrayValue {
                        let newContact = Contact()
                        newContact.id = item["id"].intValue
                        newContact.user_id = item["user_id"].intValue
                        newContact.profile = item["profile"].stringValue
                        newContact.firstname = item["firstname"].stringValue
                        newContact.lastname = item["lastname"].stringValue
                        newContact.phone = item["phone"].stringValue
                        newContact.email = item["email"].stringValue
                        newContact.relationship = item["relationship"].stringValue
                        newContact.number = item["number"].intValue
                        newContact.sent = true
                        
                        ContactDAO.addContact(contact: newContact)
                        ContactManager.getInstance().contacts.append(newContact)
                        ContactManager.getInstance().sortByNumber()
                    }
                }
                thread = thread + 1
                if loadDataDelegate != nil {
                    loadDataDelegate?.finish(thread: thread)
                }
            case .failure(_):
                return
            }
        }
        
        url = Global.baseURL + "multimedia/user/" + String(user.id) + "?token=" + user.token
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let json = JSON(value)
                    let url = "http://yteannguyen.com/api/mylife/public/upload/"
                    for item in json["data"].arrayValue {
                        
                        let path = item["path"].stringValue
                        
                        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
                        _ = Alamofire.download(url + path, to: destination)
                        
                        let newAudio = Multimedia()
                        newAudio.id = item["id"].intValue
                        newAudio.user_id = item["user_id"].intValue
                        newAudio.type_id = item["type_id"].intValue
                        newAudio.name = path
                        newAudio.sent = true
                        newAudio.path = path
                        
                        MultimediaDAO.addMultimedia(multimedia: newAudio)
                        if item["type_id"].intValue == 5 {
                            MultimediaManager.getInstance().audios.append(newAudio)
                        }
                        MultimediaManager.getInstance().allMultimedia.append(newAudio)
                    }
                }
                thread = thread + 1
                if loadDataDelegate != nil {
                    loadDataDelegate?.finish(thread: thread)
                }
            case .failure(_):
                return
            }
        }
        
        url = Global.baseURL + "message/user/" + String(user.id) + "?token=" + user.token
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let json = JSON(value)
                    for item in json["data"].arrayValue {
                        let newMessage = Message()
                        newMessage.id = item["id"].intValue
                        newMessage.user_id = item["user_id"].intValue
                        newMessage.content = item["content"].stringValue
                        MessageDAO.addMessage(message: newMessage)
                        MessageManager.getInstance().messages.append(newMessage)
                    }
                }
            case .failure(_):
                return
            }
        }
    }
}
