//
//  MultimediaManager.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/16/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class MultimediaManager {

    private static var sharedInstance: MultimediaManager!
    
    var audios = [Multimedia]()
    var allMultimedia = [Multimedia]()
    
    static func getInstance() -> MultimediaManager {
        if(sharedInstance == nil) {
            sharedInstance = MultimediaManager()
        }
        return sharedInstance
    }
    
    private init() {
                
    }
}
