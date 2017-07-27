//
//  UserDefaultManager.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/29/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class UserDefaultManager {

    private static var sharedInstance: UserDefaultManager!
    
    private let defaults = UserDefaults.standard
    
    private let isInitApp = "isInitApp"
    private let currentUser = "currentUser"
    private let indexOutputFormat = "indexOutputFormat"
    private let indexSampleRate = "indexSampleRate"
    private let indexEncodeBitRate = "indexEncodeBitRate"
    private let indexAudioList = "indexAudioList"

    static func getInstance() -> UserDefaultManager {
        if(sharedInstance == nil) {
            sharedInstance = UserDefaultManager()
        }
        return sharedInstance
    }
    
    private init() {
        
    }

    func setIsInitApp(value: Bool) {
        defaults.set(value, forKey: isInitApp)
        defaults.synchronize()
    }
    
    func getIsInitApp() -> Bool {
        return defaults.bool(forKey: isInitApp)
    }
    
    func setCurrentUser(userID: Int) {
        defaults.set(userID, forKey: currentUser)
        defaults.synchronize()
    }
    
    func getCurrentUser() -> Int {
        return defaults.integer(forKey: currentUser)
    }
    
    func setIndexOutputFormat(value: Int) {
        defaults.set(value, forKey: indexOutputFormat)
        defaults.synchronize()
    }
    
    func getIndexOutputFormat() -> Int {
        return defaults.integer(forKey: indexOutputFormat)
    }
    
    func setIndexSampleRate(value: Int) {
        defaults.set(value, forKey: indexSampleRate)
        defaults.synchronize()
    }
    
    func getIndexSampleRate() -> Int {
        return defaults.integer(forKey: indexSampleRate)
    }
    
    func setIndexEncodeBitRate(value: Int) {
        defaults.set(value, forKey: indexEncodeBitRate)
        defaults.synchronize()
    }
    
    func getIndexEncodeBitRate() -> Int {
        return defaults.integer(forKey: indexEncodeBitRate)
    }
    
    func setIndexAudioList(value: Int) {
        defaults.set(value, forKey: indexAudioList)
        defaults.synchronize()
    }
    
    func getIndexAudioList() -> Int {
        return defaults.integer(forKey: indexAudioList)
    }
}
