//
//  NSDateExtensions.swift
//  Wipro
//
//  Created by Mladen Despotovic on 20/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation

let dateFormatter = NSDateFormatter.init()

extension NSDate {
        
    class func dateFrom(UTCNoTimezone:String) -> NSDate? {
        
        let posixLocale = NSLocale.init(localeIdentifier:"en_US_POSIX")
        dateFormatter.locale = posixLocale
        let timeZone = NSTimeZone.init(name:"UTC")
        dateFormatter.timeZone = timeZone
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        return dateFormatter.dateFromString(UTCNoTimezone)
    }

    func shortDateString() -> String {
        
        let posixLocale = NSLocale.init(localeIdentifier:"en_US_POSIX")
        dateFormatter.locale = posixLocale
        let timeZone = NSTimeZone.init(name:"UTC")
        dateFormatter.timeZone = timeZone
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateFormat = "dd MMM"

        return dateFormatter.stringFromDate(self)
    }
    
    func timeString() -> String {
        
        let posixLocale = NSLocale.init(localeIdentifier:"en_US_POSIX")
        dateFormatter.locale = posixLocale
        let timeZone = NSTimeZone.init(name:"UTC")
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "H:mm a"
        
        return dateFormatter.stringFromDate(self)
    }
}
