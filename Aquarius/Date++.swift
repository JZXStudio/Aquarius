//
//  Date++.swift
//  Aquarius
//
//  Created by SONG JIN on 2023/3/13.
//

import Foundation

extension Date {
    static public
    func stringConvertDate(string: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    static public
    func a_day(year: String, month: String, day: String, hour: String="00", minute: String="00", second: String="00") -> Date {
        let convertDay: String = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second
        print(convertDay)
        return Date.stringConvertDate(string: convertDay)
    }
    
    static public
    func currentDay() -> Date {
        return Date.afterDay(0)
    }
    
    static public
    func nextDay() -> Date {
        return Date.afterDay()
    }
    
    static public
    func nextWeek() -> Date {
        return Date.afterDay(7)
    }
    
    static public
    func afterDay(_ num: Int=1) -> Date {
        return Date(timeIntervalSinceNow: TimeInterval(24*60*60*num))
    }
    
    static public
    func prevDay(_ num: Int=1) -> Date {
        return Date(timeIntervalSinceNow: TimeInterval(24*60*60 * -num))
    }
    
    static public
    func afterWeek(_ num: Int=1) -> Date {
        let numberOfDays = 7 * num
        
        return Date(timeIntervalSinceNow: TimeInterval(24*60*60*numberOfDays))
    }
    
    static public
    func prevWeek(_ num: Int=1) -> Date {
        let numberOfDays = 7 * -num
        
        return Date(timeIntervalSinceNow: TimeInterval(24*60*60*numberOfDays))
    }
    
    public func getDaysInMonth() -> Int {
        let year: Int = Int(self.toString(formatter: "yyyy"))!
        let month: Int = Int(self.toString(formatter: "MM"))!
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            return isLeapYear ? 29 : 28
        default:
            fatalError("非法的月份:\(month)")
        }
    }
    
    //Date格式转换成时间戳
    public func dateToTimestamp() -> Int {
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
         
        //当前时间的时间戳
        let timeInterval:TimeInterval = self.timeIntervalSince1970
        return Int(timeInterval)
    }
    
    public func convertToString() -> String {
        return convertToString(formatter: "yyyy-MM-dd")
    }
    
    public func convertToString(formatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = formatter
        
        let date = dateFormatter.string(from: self)
        return date
    }
    
    public func toString() -> String {
        return convertToString()
    }
    
    public func toShortEnglishString() -> String {
        return toString(formatter: toShortEnglishFormatterString())
    }
    
    public func toShortChineseString() -> String {
        return toString(formatter: toShortChineseFormatterString())
    }
    
    public func toLongEnglishString() -> String {
        return toString(formatter: toLongEnglishFormatterString())
    }
    
    public func toLongChineseString() -> String {
        return toString(formatter: toLongChineseFormatterString())
    }
    
    public func toString(formatter: String) -> String {
        return convertToString(formatter: formatter)
    }
    
    public func toYearString() -> String {
        return toString(formatter: "yyyy")
    }
    
    public func toYear() -> Int? {
        return toYearString().toInt()
    }
    
    public func toMonthString() -> String {
        return toString(formatter: "MM")
    }
    
    public func toMonth() -> Int? {
        return toMonthString().toInt()
    }
    
    public func toDayString() -> String {
        return toString(formatter: "dd")
    }
    
    public func toDay() -> Int? {
        return toDayString().toInt()
    }
    
    public func toTimeString() -> String {
        return toString(formatter: "HH:mm:ss")
    }
    
    public func toHourString() -> String {
        return toString(formatter: "HH")
    }
    
    public func toHour() -> Int? {
        return toHourString().toInt()
    }
    
    public func toMinuteString() -> String {
        return toString(formatter: "mm")
    }
    
    public func toMinute() -> Int? {
        return toMinuteString().toInt()
    }
    
    public func toSecondString() -> String {
        return toString(formatter: "ss")
    }
    
    public func toSecond() -> Int? {
        return toSecondString().toInt()
    }
    /// 计算与另一个日期之间相差多少秒
    /// - Parameter date: 另一个日期
    /// - Returns: 秒
    public func toSecondsBetween(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second], from: date, to: self)
        let seconds = abs(components.second!)
        return seconds
    }
    
    public func getDateTime(time: String) -> Date {
        var dateString = self.convertToString(formatter: "yyyy-MM-dd")
        dateString = dateString + " " + time
        return Date.stringConvertDate(string: dateString)
    }
    
    public func toShortEnglishFormatterString() -> String {
        return "yyyy-MM-dd"
    }
    
    public func toShortChineseFormatterString() -> String {
        return "yyyy年MM月dd日"
    }
    
    public func toLongEnglishFormatterString() -> String {
        return  "yyyy-MM-dd HH:mm:ss"
    }
    
    public func toLongChineseFormatterString() -> String {
        return  "yyyy年MM月dd日 HH:mm:ss"
    }
    
    public func getStartDateOfMonth() -> Date {
        let yearAndMonth: String = toString(formatter: "yyyy-MM")
        return (yearAndMonth+"-01").toDate(toShortEnglishFormatterString())
    }
    
    public func getEndDateOfMonth() -> Date {
        let yearAndMonth: String = toString(formatter: "yyyy-MM")
        let daysOfMonth: Int = getDaysInMonth()
        return (yearAndMonth+"-\(daysOfMonth)").toDate(toShortEnglishFormatterString())
    }
    
    public func getEndDateOfWeek() -> Date {
        let yearAndMonth: String = toString(formatter: "yyyy-MM")
        var day: Int = toString(formatter: "dd").toInt()!
        let daysOfMonth: Int = getDaysInMonth()
        
        if day + 6 < daysOfMonth {
            return (yearAndMonth+"-\(day+6)").toDate(toShortEnglishFormatterString())
        } else {
            var month: Int = toMonthString().toInt()!
            if month + 1 <= 12 {
                let year: String = toYearString()
                month = month + 1
                let daysOfNextMonth: Int = (year+"-"+month.toString()+"-1").toDate(toShortEnglishFormatterString()).getDaysInMonth()
                day = day + 6 - daysOfNextMonth
                return (year+"-"+month.toString()+"-"+day.toString()).toDate(toShortEnglishFormatterString())
            } else {
                let year: Int = toYearString().toInt()! + 1
                month = 1
                day = day + 6 - daysOfMonth
                return (year.toString()+"-"+month.toString()+"-"+day.toString()).toDate(toShortEnglishFormatterString())
            }
        }
    }
    //判断传入的date是否为nil，如果不为nil，则赋值给当前date
    public mutating func a_isValid(_ date: Date?) {
        if date != nil {
            self = date!
        }
    }
}
