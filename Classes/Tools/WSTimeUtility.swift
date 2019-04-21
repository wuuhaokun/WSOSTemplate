//
//  WSTimeUtility.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/9/20.
//  Copyright © 2018年 TSAI CHENG HENG. All rights reserved.
//

import Foundation

public class WSTimeUtility {
    
    public init(){
        
    }
    
    public static func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let timeStamp:Int = Int(interval)
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date:Date = Date(timeIntervalSince1970: timeInterval)
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "HH:mm"
        let timeString = (dateFormat.string(from: date) as NSString)
        return timeString
    }
    
    public static func stringFromDateInterval(interval: TimeInterval) -> NSString {
        let timeStamp:Int = Int(interval)
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date:Date = Date(timeIntervalSince1970: timeInterval)
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "YYYY/MM/dd"
        let timeString = (dateFormat.string(from: date) as NSString)
        return timeString
    }
    
    public static func stringFromDateAndTimeInterval(interval: TimeInterval) -> NSString {
        let timeStamp:Int = Int(interval)
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date:Date = Date(timeIntervalSince1970: timeInterval)
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "YYYY/MM/dd HH:mm"
        let timeString = (dateFormat.string(from: date) as NSString)
        return timeString
    }
    
    open func getNowTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    open func getNowDate() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    open func getNowDateAndTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    public static func compareDate(_ date1: Date, date date2: Date) -> Bool {
        let result = date1.compare(date2)
        switch result {
        case .orderedDescending:// date1 小于 date2
            return true
        case .orderedSame:// 相等
            return false
        case .orderedAscending:// date1 大于 date2
            return false
        }
    }
    
}

