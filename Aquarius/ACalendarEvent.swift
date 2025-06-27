//
//  ACalendarEvent.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/9/13.
//

import UIKit
import EventKit
import Foundation

public enum ACalendarEventType {
    case title, notes, location, allDay, startDate, endDate, alarmPrevMinute, url
}

open class ACalendarEvent: NSObject {
    public static let shared = ACalendarEvent()
    
    let eventStore: EKEventStore = EKEventStore()

    public func openCalendarApp() {
        if UIApplication.shared.canOpenURL(URL(string:"calshow:")!) {
            UIApplication.shared.open(URL(string:"calshow:")!, options: [:], completionHandler: nil)
        }
    }
    /*
     startDate: 开始日期
     endDate: 结束日期
     isLocal: 是否获取本地，默认为false（所有的）
     completion: 返回EKEvent数组
     */
    public func select(startDate: Date, endDate: Date, isLocal: Bool=false, completion: @escaping (([EKEvent]?) -> Void)) {
        if !isLocal {
            selectAll(
                startDate: startDate,
                endDate: endDate,
                completion: completion
            )
        } else {
            selectLocal(
                startDate: startDate,
                endDate: endDate,
                completion: completion
            )
        }
    }
    /*
     查找所有的日历事件
     
     startDate: 开始日期
     endDate: 结束日期
     completion: 返回EKEvent数组
     */
    public func selectAll(startDate: Date, endDate: Date, completion: @escaping (([EKEvent]?) -> Void)) {
        eventStore.requestAccess(to: .event) { [weak self] ( granted, error ) in
            if granted && error == nil {
                let predicate = self?.eventStore.predicateForEvents(
                    withStart: startDate,
                    end: endDate,
                    calendars: nil
                )
                
                completion(self?.eventStore.events(matching: predicate!) as [EKEvent]?)
            } else {
                completion([])
            }
        }
    }
    /*
     查找本地的日历事件
     
     startDate: 开始日期
     endDate: 结束日期
     completion: 返回EKEvent数组
     */
    public func selectLocal(startDate: Date, endDate: Date, completion: @escaping (([EKEvent]?) -> Void)) {
        eventStore.requestAccess(to: .event) { [weak self] ( granted, error ) in
            if granted && error == nil {
                //获取本地日历（剔除节假日，生日等其他系统日历）
                let calendars = self?.eventStore.calendars(for: .event).filter({
                    (calender) -> Bool in
                    return calender.type == .local || calender.type == .calDAV
                })
                
                let predicate = self?.eventStore.predicateForEvents(
                    withStart: startDate,
                    end: endDate,
                    calendars: calendars
                )
                
                completion(self?.eventStore.events(matching: predicate!) as [EKEvent]?)
            } else {
                completion([])
            }
        }
    }
    /*
     title: 标题
     notes: 备注
     location: 位置i信息
     allDay: 是否为全天事件，默认为false
     startDate: 开始日期
     endDate: 结束日期
     alarmPrevMinute: 提前多少分钟提醒
     */
    public func add(dictionary: [ACalendarEventType : Any], span: EKSpan=EKSpan.thisEvent) {
        let event: EKEvent = getCalendarEvent(dictionary)
        do {
            let _ = try eventStore.save(
                event,
                span: span
            )
        } catch {
            //print(error)
        }
    }
    /*
     title: 标题
     notes: 备注
     location: 位置i信息
     allDay: 是否为全天事件，默认为false
     startDate: 开始日期
     endDate: 结束日期
     alarmPrevMinute: 提前多少分钟提醒
     */
    public func add(title: String, notes: String?=nil, location: String?=nil, allDay: Bool=false, startDate: Date, endDate: Date, alarmPrevMinute: Int, span: EKSpan=EKSpan.thisEvent) {
        let event: EKEvent = getCalendarEvent(
            title: title,
            notes: notes,
            location: location,
            allDay: allDay,
            startDate: startDate,
            endDate: endDate,
            alarmPrevMinute: alarmPrevMinute
        )
        
        do {
            let _ = try eventStore.save(
                event,
                span: span
            )
        } catch {
            //print(error)
        }
    }
    
    public func update(_ event: EKEvent) {
        do {
            let _ = try eventStore.save(
                event,
                span: .thisEvent,
                commit: true
            )
        } catch {
            //print(error)
        }
    }
    
    public func remove(event: EKEvent, span: EKSpan=EKSpan.thisEvent) {
        do {
            let _ = try eventStore.remove(event, span: span)
        } catch {
            //print(error)
        }
    }
    
    private func getCalendarEvent(_ dictionary: [ACalendarEventType : Any]) -> EKEvent {
        let event: EKEvent = EKEvent(eventStore: eventStore)
        event.title = dictionary[.title] as? String
        if dictionary[.notes] != nil {
            event.notes = dictionary[.notes] as? String
        }
        if dictionary[.location] != nil {
            event.location = dictionary[.location] as? String
        }
        event.isAllDay = dictionary[.allDay] == nil ? false : (dictionary[.allDay] as! Bool)
        event.startDate = dictionary[.startDate] as? Date
        event.endDate = dictionary[.endDate] as? Date
        if dictionary[.alarmPrevMinute] != nil {
            event.addAlarm(EKAlarm(relativeOffset: TimeInterval(-60*(dictionary[.alarmPrevMinute] as! Int))))
        }
        event.calendar = eventStore.defaultCalendarForNewEvents
        if dictionary[.url] != nil {
            event.url = dictionary[.url] as? URL
        }
        
        return event
    }
    
    private func getCalendarEvent(title: String, notes: String?, location: String?, allDay: Bool=false, startDate: Date, endDate: Date, alarmPrevMinute: Int?) -> EKEvent {
        let event: EKEvent = EKEvent(eventStore: eventStore)
        event.title = title
        if notes != nil {
            event.notes = notes
        }
        if location != nil {
            event.location = location
        }
        event.isAllDay = allDay
        event.startDate = startDate
        event.endDate = endDate
        if alarmPrevMinute != nil {
            event.addAlarm(EKAlarm(relativeOffset: TimeInterval(-60*alarmPrevMinute!)))
        }
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        return event
    }
}

public enum AReminderEventType {
    case title, notes, location, alarmPrevMinute, isCompleted
}
open class AReminderEvent: NSObject {
    public static let shared = AReminderEvent()
    
    let eventStore: EKEventStore = EKEventStore()
    
    public func openReminderApp() {
        if UIApplication.shared.canOpenURL(URL(string:"x-apple-reminder://")!) {
            UIApplication.shared.open(URL(string:"x-apple-reminder://")!, options: [:], completionHandler: nil)
        }
    }
    /*
     startDate: 开始日期
     endDate: 结束日期
     isLocal: 是否获取本地，默认为false（所有的）
     completion: 返回EKEvent数组
     */
    public func select(isLocal: Bool=false, completion: @escaping (([EKReminder]?) -> Void)) {
        if !isLocal {
            selectAll(completion)
        } else {
            selectLocal(completion)
        }
    }
    /*
     查找所有的日历事件
     
     startDate: 开始日期
     endDate: 结束日期
     completion: 返回EKEvent数组
     */
    public func selectAll(_ completion: @escaping (([EKReminder]?) -> Void)) {
        eventStore.requestAccess(to: .reminder) { [weak self] ( granted, error ) in
            if granted && error == nil {
                let predicate = self?.eventStore.predicateForReminders(in: nil)
                self?.eventStore.fetchReminders(matching: predicate!, completion: completion)
            } else {
                completion([])
            }
        }
    }
    /*
     查找本地的日历事件
     
     startDate: 开始日期
     endDate: 结束日期
     completion: 返回EKEvent数组
     */
    public func selectLocal(_ completion: @escaping (([EKReminder]?) -> Void)) {
        eventStore.requestAccess(to: .reminder) { [weak self] ( granted, error ) in
            if granted && error == nil {
                //获取本地日历（剔除节假日，生日等其他系统日历）
                let calendars = self?.eventStore.calendars(for: .event).filter({
                    (calender) -> Bool in
                    return calender.type == .local || calender.type == .calDAV
                })
                
                let predicate = self?.eventStore.predicateForReminders(in: calendars)
                self?.eventStore.fetchReminders(matching: predicate!, completion: completion)
            } else {
                completion([])
            }
        }
    }
    /*
     title: 标题
     notes: 备注
     location: 位置i信息
     allDay: 是否为全天事件，默认为false
     startDate: 开始日期
     endDate: 结束日期
     alarmPrevMinute: 提前多少分钟提醒
     */
    public func add(dictionary: [AReminderEventType : Any]) {
        let reminder: EKReminder = getReminderEvent(dictionary)
        do {
            let _ = try eventStore.save(
                reminder,
                commit: true
            )
        } catch {
            //print(error)
        }
    }
    /*
     title: 标题
     notes: 备注
     location: 位置i信息
     allDay: 是否为全天事件，默认为false
     startDate: 开始日期
     endDate: 结束日期
     alarmPrevMinute: 提前多少分钟提醒
     */
    public func add(title: String, isCompleted: Bool?=nil, notes: String?=nil, location: String?=nil, alarmPrevMinute: Int) {
        let reminder: EKReminder = getReminderEvent(
            title: title,
            isCompleted: isCompleted,
            notes: notes,
            location: location,
            alarmPrevMinute: alarmPrevMinute
        )
        
        do {
            let _ = try eventStore.save(
                reminder,
                commit: true
            )
        } catch {
            //print(error)
        }
    }
    
    public func update(_ reminder: EKReminder) {
        do {
            let _ = try eventStore.save(
                reminder,
                commit: true
            )
        } catch {
            //print(error)
        }
    }
    
    public func remove(_ reminder: EKReminder) {
        do {
            let _ = try eventStore.remove(reminder, commit: true)
        } catch {
            //print(error)
        }
    }
    
    private func getReminderEvent(_ dictionary: [AReminderEventType : Any]) -> EKReminder {
        let reminder: EKReminder = EKReminder(eventStore: eventStore)
        reminder.title = dictionary[.title] as? String
        if dictionary[.isCompleted] != nil {
            reminder.isCompleted = dictionary[.isCompleted] as! Bool
        }
        if dictionary[.notes] != nil {
            reminder.notes = dictionary[.notes] as? String
        }
        if dictionary[.location] != nil {
            reminder.location = dictionary[.location] as? String
        }
        if dictionary[.alarmPrevMinute] != nil {
            reminder.addAlarm(EKAlarm(relativeOffset: TimeInterval(-60*(dictionary[.alarmPrevMinute] as! Int))))
        }
        
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        
        return reminder
    }
    
    private func getReminderEvent(title: String, isCompleted: Bool?, notes: String?, location: String?, alarmPrevMinute: Int?) -> EKReminder {
        let reminder: EKReminder = EKReminder(eventStore: eventStore)
        reminder.title = title
        if isCompleted != nil {
            reminder.isCompleted = isCompleted!
        }
        if notes != nil {
            reminder.notes = notes
        }
        if location != nil {
            reminder.location = location
        }
        if alarmPrevMinute != nil {
            reminder.addAlarm(EKAlarm(relativeOffset: TimeInterval(-60*alarmPrevMinute!)))
        }
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        
        return reminder
    }
}
