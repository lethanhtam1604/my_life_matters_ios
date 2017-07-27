//
//  String.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/24/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let PHONE_REGEX = "^((\\+)|())[0-9]{3,100}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func isValidAccount() -> Bool {
        let RegEx = "\\A\\w{6,18}\\z"
        let accountTest = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return accountTest.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let RegEx = ".{6,18}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  passwordTest.evaluate(with: self)
        return result
    }
    
    func isValidName() -> Bool {
        let RegEx = ".{1,50}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  nameTest.evaluate(with: self)
        return result
    }
    
    func isValidMessage() -> Bool {
        let RegEx = ".{1,500}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  nameTest.evaluate(with: self)
        return result
    }
    
    func isValidUrl () -> Bool {
        if let url = NSURL(string: self) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    var dateFromISO8601: NSDate? {
        return NSDate.Formatter.iso8601.date(from: self) as NSDate?
    }
    
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}
