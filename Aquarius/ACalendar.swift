//
//  ACalendar.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/9/11.
//

import Foundation

open class ACalendar: NSObject {
    public static let shared = ACalendar()
    
    public func today() -> Date {
        return Date.currentDay()
    }
    
    public func tomorrow() -> Date {
        return Date.nextDay()
    }
    
    public func nextWeek() -> Date {
        return Date.nextWeek()
    }
    
    public func day() -> Int? {
        return today().toDay()
    }
    
    public func dayString() -> String {
        return today().toDayString()
    }
    
    public func month() -> Int? {
        return today().toMonth()
    }
    
    public func monthString() -> String {
        return today().toMonthString()
    }
    
    public func year() -> Int? {
        return today().toYear()
    }
    
    public func yearString() -> String {
        return today().toYearString()
    }
    //未来的某一天
    public func futureDay(_ day: Int) -> Date {
        return Date.afterDay(day)
    }
    //过去的某一天
    public func pastDay(_ day: Int) -> Date {
        return Date.prevDay(day)
    }
}
