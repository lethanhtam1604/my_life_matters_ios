//
//  Utils.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/17/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import MBProgressHUD
import SystemConfiguration

protocol AlertDelegate {
    func okAlertActionClicked()
}

class Utils {
    
    public static func showHub(view : UIView) {
        let mbProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        mbProgressHUD.bezelView.color = UIColor.black
        mbProgressHUD.contentColor = UIColor.white
        mbProgressHUD.mode = MBProgressHUDMode.indeterminate
    }
    
    public static func hideHub(view : UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    static func showAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertAction(title: String, message: String, viewController: UIViewController, alertDelegate: AlertDelegate?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            if alertDelegate != nil {
                alertDelegate?.okAlertActionClicked()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func callNumber(phone: String) {
        let phone = "tel://" + phone
        let url:NSURL = NSURL(string:phone)!
        UIApplication.shared.openURL(url as URL)
    }
    
    static func getCurrentDateTime() -> String{
        var result = ""
        let date = NSDate()
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)

        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let second = calendar.component(.second, from: date as Date)

        result = String(year) + String(month) + String(day) + String(hour) + String(minutes) + String(second)
        return result
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
