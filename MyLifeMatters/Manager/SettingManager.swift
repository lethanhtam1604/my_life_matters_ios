//
//  SettingManager.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/28/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SettingManager {

    private static var sharedInstance: SettingManager!
    
    var settings = [Setting]()
    
    static func getInstance() -> SettingManager {
        if(sharedInstance == nil) {
            sharedInstance = SettingManager()
        }
        return sharedInstance
    }
    
    private init() {
        
        var setting = Setting()
        setting.id = 0
        let userIcon = FAKFontAwesome.userIcon(withSize: 30)
        userIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let userImg  = userIcon?.image(with: CGSize(width: 30, height: 30))
        setting.icon = userImg
        setting.title = "Profile"
        settings.append(setting)
        
        setting = Setting()
        setting.id = 1
        let globeIcon = FAKFontAwesome.globeIcon(withSize: 30)
        globeIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let globeImg  = globeIcon?.image(with: CGSize(width: 30, height: 30))
        setting.icon = globeImg
        setting.title = "Life lines"
        settings.append(setting)
        
        setting = Setting()
        setting.id = 2
        let chatbubbleWorkingIcon = FAKIonIcons.chatbubbleWorkingIcon(withSize: 30)
        chatbubbleWorkingIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let chatbubbleWorkingImg  = chatbubbleWorkingIcon?.image(with: CGSize(width: 30, height: 30))
        setting.icon = chatbubbleWorkingImg
        setting.title = "Message Template"
        settings.append(setting)
        
        setting = Setting()
        setting.id = 3
        let uploadIcon = FAKFontAwesome.uploadIcon(withSize: 30)
        uploadIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let uploadImg  = uploadIcon?.image(with: CGSize(width: 30, height: 30))
        setting.icon = uploadImg
        setting.title = "File Transfer"
        settings.append(setting)
        
        setting = Setting()
        setting.id = 4
        let ttyIcon = FAKFontAwesome.ttyIcon(withSize: 30)
        ttyIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let ttyImg  = ttyIcon?.image(with: CGSize(width: 30, height: 30))
        setting.icon = ttyImg
        setting.title = "Emercency Dialing"
        settings.append(setting)
        
        setting = Setting()
        setting.id = 5
        let cogIcon = FAKFontAwesome.cogIcon(withSize: 30)
        cogIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let cogImg  = cogIcon?.image(with: CGSize(width: 30, height: 30))
        setting.icon = cogImg
        setting.title = "Audio Settings"
        settings.append(setting)
        
        setting = Setting()
        setting.id = 6
        let heartIcon = FAKFontAwesome.heartIcon(withSize: 30)
        heartIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let heartImg  = heartIcon?.image(with: CGSize(width: 30, height: 30))
        setting.icon = heartImg
        setting.title = "Civil Rights Groups"
        settings.append(setting)
        
        setting = Setting()
        setting.id = 7
        let signOutIcon = FAKFontAwesome.signOutIcon(withSize: 30)
        signOutIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let signOutImg  = signOutIcon?.image(with: CGSize(width: 30, height: 30))
        setting.icon = signOutImg
        setting.title = "Sign Out"
        settings.append(setting)
    }

}
