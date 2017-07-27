//
//  NSDate.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/24/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

extension NSDate {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601) as Calendar!
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }()
    }
    var iso8601: String { return Formatter.iso8601.string(from: self as Date) }
}
