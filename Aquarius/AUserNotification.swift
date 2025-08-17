//
//  AUserNotification.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/9/10.
//

import UIKit
import Foundation
import CoreLocation
import UserNotifications

open class AUserNotification: NSObject {
    public static let shared = AUserNotification()
    
    public var receiveHandler: ((UNNotificationContent) -> Void)? = nil
    
    override public init() {
        super.init()
        
        AUserNotification.current.delegate = self
    }
    
    private static var current: UNUserNotificationCenter {
        get {
            UNUserNotificationCenter.current()
        }
    }
    //申请通知权限
    public static func authorization() {
        current
            .requestAuthorization(options: [.alert, .sound, .badge]) { (accepted, error) in
                if !accepted {
                    //print("用户不允许消息通知。")
                }
            }
    }
    //获取通知设置
    public static func getSettings(_ completionHandler: @escaping (AUserNotificationSettings) -> Void) {
        current
            .getNotificationSettings { settings in
                let userNotificationSettings: AUserNotificationSettings = AUserNotificationSettings(
                    authorizationStatus: settings.authorizationStatus,
                    sound: settings.soundSetting,
                    badge: settings.badgeSetting,
                    lockScreen: settings.lockScreenSetting,
                    notificationCenter: settings.notificationCenterSetting,
                    alert: settings.alertSetting,
                    previews: settings.showPreviewsSetting
                )
                completionHandler(userNotificationSettings)
            }
    }
    /*
     获取待推送的通知
     identifier:推送ID
     content:推送内容
     trigger:角标
     */
    public static func getUnPushNotifications(_ completionHandler: @escaping([UNNotificationRequest]) -> Void) {
        current.getPendingNotificationRequests { requests in
            completionHandler(requests)
        }
    }
    
    public static func getPushedNotifications(_ completionHandler: @escaping([UNNotification]) -> Void) {
        current.getDeliveredNotifications { notifications in
            completionHandler(notifications)
        }
    }
    //发送通知（多少秒之后）
    @discardableResult
    public static func send(content: [Any], second: Int, repeats: Bool=false) -> String {
        return send(
            content: ANotificationContent(content),
            second: second,
            repeats: repeats
        )
    }
    //发送通知（多少秒之后）
    @discardableResult
    public static func send(content: [AUserNotificationContentType : Any], second: Int, repeats: Bool=false) -> String {
        return send(
            content: ANotificationContent(content: content),
            second: second,
            repeats: repeats
        )
    }
    //发送通知（多少秒之后）
    @discardableResult
    public static func send(content: ANotificationContent, second: Int, repeats: Bool=false) -> String {
        return send(
            title: content.title,
            subtitle: content.subtitle,
            content: content.content,
            badge: content.badge,
            userInfo: content.userInfo,
            second: second,
            repeats: repeats
        )
    }
    //发送通知（多少小时之后）
    @discardableResult
    public static func send(content: [Any], hour: Int, repeats: Bool=false) -> String {
        return send(
            content: ANotificationContent(content),
            second: hour*60*60,
            repeats: repeats
        )
    }
    //发送通知（多少小时之后）
    @discardableResult
    public static func send(content: [AUserNotificationContentType : Any], hour: Int, repeats: Bool=false) -> String {
        return send(
            content: ANotificationContent(content: content),
            second: hour*60*60,
            repeats: repeats
        )
    }
    //发送通知（多少小时之后）
    @discardableResult
    public static func send(content: ANotificationContent, hour: Int, repeats: Bool=false) -> String {
        return send(
            title: content.title,
            subtitle: content.subtitle,
            content: content.content,
            badge: content.badge,
            userInfo: content.userInfo,
            second: hour*60*60,
            repeats: repeats
        )
    }
    //发送通知（多少天之后）
    @discardableResult
    public static func send(content: [Any], day: Int, repeats: Bool=false) -> String {
        return send(
            content: ANotificationContent(content),
            second: day*60*60*12,
            repeats: repeats
        )
    }
    //发送通知（多少天之后）
    @discardableResult
    public static func send(content: [AUserNotificationContentType : Any], day: Int, repeats: Bool=false) -> String {
        return send(
            content: ANotificationContent(content: content),
            second: day*60*60*12,
            repeats: repeats
        )
    }
    //发送通知（多少天之后）
    @discardableResult
    public static func send(content: ANotificationContent, day: Int, repeats: Bool=false) -> String {
        return send(
            title: content.title,
            subtitle: content.subtitle,
            content: content.content,
            badge: content.badge,
            userInfo: content.userInfo,
            second: day*60*60*12,
            repeats: repeats
        )
    }
    //发送通知（多少周之后）
    @discardableResult
    public static func send(content: [Any], week: Int, repeats: Bool=false) -> String {
        return send(
            content: ANotificationContent(content),
            second: week*60*60*12*7,
            repeats: repeats
        )
    }
    //发送通知（多少周之后）
    @discardableResult
    public static func send(content: [AUserNotificationContentType : Any], week: Int, repeats: Bool=false) -> String {
        return send(
            content: ANotificationContent(content: content),
            second: week*60*60*12*7,
            repeats: repeats
        )
    }
    //发送通知（多少周之后）
    @discardableResult
    public static func send(content: ANotificationContent, week: Int, repeats: Bool=false) -> String {
        return send(
            title: content.title,
            subtitle: content.subtitle,
            content: content.content,
            badge: content.badge,
            userInfo: content.userInfo,
            second: week*60*60*12*7,
            repeats: repeats
        )
    }
    //发送通知（某一天）
    @discardableResult
    public static func send(content: [Any], date: Date, repeats: AUserNotificationRepeatType=AUserNotificationRepeatType.none) -> String {
        return send(
            content: ANotificationContent(content),
            date: date,
            repeats: repeats
        )
    }
    //发送通知（某一天）
    @discardableResult
    public static func send(content: [AUserNotificationContentType : Any], date: Date, repeats: AUserNotificationRepeatType=AUserNotificationRepeatType.none) -> String {
        return send(
            content: ANotificationContent(content: content),
            date: date,
            repeats: repeats
        )
    }
    //发送通知（某一天）
    @discardableResult
    public static func send(content: ANotificationContent, date: Date, repeats: AUserNotificationRepeatType=AUserNotificationRepeatType.none) -> String {
        return send(
            title: content.title,
            subtitle: content.subtitle,
            content: content.content,
            badge: content.badge,
            userInfo: content.userInfo,
            date: date,
            repeats: repeats
        )
    }
    //发送通知（基于位置）
    @discardableResult
    public static func send(content: [Any], coordinate: CLLocationCoordinate2D, radius: Double, repeats: Bool=false) -> String {
        return send(
            content: ANotificationContent(content),
            coordinate: coordinate,
            radius: radius,
            repeats: repeats
        )
    }
    //发送通知（基于位置）
    @discardableResult
    public static func send(content:[AUserNotificationContentType : Any], coordinate: CLLocationCoordinate2D, radius: Double, repeats: Bool=false) -> String {
        return send(
            content: ANotificationContent(content: content),
            coordinate: coordinate,
            radius: radius,
            repeats: repeats
        )
    }
    //发送通知（基于位置）
    @discardableResult
    public static func send(content: ANotificationContent, coordinate: CLLocationCoordinate2D, radius: Double, repeats: Bool=false) -> String {
        return send(
            title: content.title,
            subtitle: content.subtitle,
            content: content.content,
            badge: content.badge,
            userInfo: content.userInfo,
            coordinate: coordinate,
            radius: radius,
            repeats: repeats
        )
    }
    
    //删除某个未发送的通知
    public static func removeUnPushNotification(_ identifier: String) {
        current.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    //删除多个未发送的通知
    public static func removeUnPushNotifications(_ identifiers: [String]) {
        current.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    //删除所有未发送的通知
    public static func removeAllUnPushNotifications() {
        current.removeAllPendingNotificationRequests()
    }
    
    //通知中心删除某个通知（已发送的）
    public static func removePushedNotification(_ identifier: String) {
        current.removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    //通知中心删除多个通知（已发送的）
    public static func removePushedNotifications(_ identifiers: [String]) {
        current.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    
    //通知中心删除所有通知（已发送的）
    public static func removeAllPushedNotifications() {
        current.removeAllDeliveredNotifications()
    }
    //通知中心删除通知（已发送和未发送的）
    public static func removeUnPushAndPushedNotification(_ identifier: String) {
        AUserNotification.removeUnPushNotification(identifier)
        AUserNotification.removePushedNotification(identifier)
    }
    //通知中心删除多个通知（已发送和未发送的）
    public static func removeUnPushAndPushedNotifications(_ identifiers: [String]) {
        AUserNotification.removeUnPushNotifications(identifiers)
        AUserNotification.removePushedNotifications(identifiers)
    }
    /* 私有方法 */
    private static func send(title: String, subtitle: String?=nil, content: String, badge: Int?=nil, userInfo: [AnyHashable : Any]?=nil, second: Int, repeats: Bool=false) -> String {
        let notificationContent = getNotificationContent(
            title: title,
            subtitle: subtitle,
            content: content,
            badge: badge,
            userInfo: userInfo
        )
        
        //设置通知触发器
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(second), repeats: repeats)
        
        return addSecondNotification(
            notificationContent: notificationContent,
            trigger: trigger
        )
    }
    
    private static func send(title: String, subtitle: String?=nil, content: String, badge: Int?=nil, userInfo: [AnyHashable : Any]?=nil, date: Date, repeats: AUserNotificationRepeatType=AUserNotificationRepeatType.none) -> String {
        let notificationContent = getNotificationContent(
            title: title,
            subtitle: subtitle,
            content: content,
            badge: badge,
            userInfo: userInfo
        )
        
        let isRepeat: Bool = (repeats == .none) ? false : true
        
        var components = DateComponents()
        components.year = date.toYear()
        components.month = date.toMonth()
        components.day = date.toDay()
        components.hour = date.toHour()
        components.minute = date.toMinute()
        components.second = date.toSecond()
        
        let dateFromDateComponents = Calendar.current.date(from: components)
        var newComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second ], from: dateFromDateComponents!)
        if repeats != .none {
            switch repeats {
            case .minute:
                newComponents = Calendar.current.dateComponents([ .second], from: dateFromDateComponents!)
            case .hour:
                newComponents = Calendar.current.dateComponents([ .minute], from: dateFromDateComponents!)
            case .day:
                newComponents = Calendar.current.dateComponents([.hour, .minute], from: dateFromDateComponents!)
            case .week:
                newComponents = Calendar.current.dateComponents([.hour, .minute, .weekday], from: dateFromDateComponents!)
            case .month:
                newComponents = Calendar.current.dateComponents([.hour, .minute, .day], from: dateFromDateComponents!)
            case .year:
                newComponents = Calendar.current.dateComponents([.hour, .minute, .day, .month], from: dateFromDateComponents!)
            default:
                break
            }
        }
        components = newComponents
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: isRepeat)
        
        return addCalendarNotification(
            notificationContent: notificationContent,
            trigger: trigger
        )
    }
    
    private static func send(title: String, subtitle: String?=nil, content: String, badge: Int?=nil, userInfo: [AnyHashable : Any]?=nil, coordinate: CLLocationCoordinate2D, radius: Double, repeats: Bool=false) -> String {
        let notificationContent = getNotificationContent(
            title: title,
            subtitle: subtitle,
            content: content,
            badge: badge,
            userInfo: userInfo
        )
        
        let region = CLCircularRegion(
            center: coordinate,
            radius: CLLocationDistance(radius),
            identifier: "center"
        )
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        let trigger = UNLocationNotificationTrigger(
            region: region,
            repeats: repeats
        )
        
        return addLocationNotification(
            notificationContent: notificationContent,
            trigger: trigger
        )
    }
    
    private static func getNotificationContent(title: String, subtitle: String?, content: String, badge: Int?, userInfo: [AnyHashable : Any]?) -> UNMutableNotificationContent {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        if subtitle != nil {
            notificationContent.subtitle = subtitle!
        }
        notificationContent.body = content
        if badge != nil {
            notificationContent.badge = badge?.toNumber
        }
        if userInfo != nil {
            notificationContent.userInfo = userInfo!
        }
        
        return notificationContent
    }
    
    private static func getRequestIdentifier() -> String {
        return ACommon.getBundleID() + "." + String.random(length: 5)
    }
    
    private static func addSecondNotification(notificationContent: UNMutableNotificationContent, trigger: UNTimeIntervalNotificationTrigger) -> String {
        let requestIdentifier = getRequestIdentifier()
        //设置一个通知请求
        let request = UNNotificationRequest(
            identifier: requestIdentifier,
            content: notificationContent,
            trigger: trigger
        )
        
        //将通知请求添加到发送中心
        current.add(request) { error in
            if error == nil {
                //print("Time Interval Notification scheduled: \(requestIdentifier)")
            }
        }
        
        return requestIdentifier
    }
    
    private static func addCalendarNotification(notificationContent: UNMutableNotificationContent, trigger: UNCalendarNotificationTrigger) -> String {
        let requestIdentifier = getRequestIdentifier()
        //设置一个通知请求
        let request = UNNotificationRequest(
            identifier: requestIdentifier,
            content: notificationContent,
            trigger: trigger
        )
        
        //将通知请求添加到发送中心
        current.add(request) { error in
            if error == nil {
                //print("Time Interval Notification scheduled: \(requestIdentifier)")
            }
        }
        
        return requestIdentifier
    }
    
    private static func addLocationNotification(notificationContent: UNMutableNotificationContent, trigger: UNLocationNotificationTrigger) -> String {
        let requestIdentifier = getRequestIdentifier()
        //设置一个通知请求
        let request = UNNotificationRequest(
            identifier: requestIdentifier,
            content: notificationContent,
            trigger: trigger
        )
        
        //将通知请求添加到发送中心
        current.add(request) { error in
            if error == nil {
                //print("Time Interval Notification scheduled: \(requestIdentifier)")
            }
        }
        
        return requestIdentifier
    }
}

extension AUserNotification: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if receiveHandler != nil {
            receiveHandler!(response.notification.request.content)
        }
        completionHandler()
    }
}

public enum AUserNotificationContentType {
    case title
    case subtitle
    case content
    case badge
    case userInfo
}
public enum AUserNotificationRepeatType {
    case none
    case minute
    case hour
    case day
    case week
    case month
    case year
}
public struct ANotificationContent {
    public var title: String
    public var subtitle: String?
    public var content: String
    public var badge: Int?
    public var userInfo: [AnyHashable : Any]?
    
    public init(title: String, subtitle: String?=nil, content: String, badge: Int?=nil, userInfo: [AnyHashable : Any]?=nil) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
        if badge != nil {
            self.badge = badge
        }
        if userInfo != nil {
            self.userInfo = userInfo
        }
    }
    
    public init(_ content: [Any]) {
        self.title = content.getString(0)
        self.subtitle = content.getString(1)
        self.content = content.getString(2)
        if content.count > 3 {
            let badgeNum: Int = content.getInt(3)
            self.badge = badgeNum
        }
        if content.count > 4 {
            self.userInfo = content.get(4) as? [AnyHashable : Any]
        }
    }
    
    public init(content: [AUserNotificationContentType : Any]) {
        self.title = content[.title] as! String
        if content[.subtitle] != nil {
            self.subtitle = content[.subtitle] as? String
        }
        
        self.content = content[.content] as! String
        
        if content[.badge] != nil {
            self.badge = content[.badge] as? Int
        }
        if content[.userInfo] != nil {
            self.userInfo = content[.userInfo] as? [AnyHashable : Any]
        }
    }
}

public struct AUserNotificationSettings {
    /*
    .notDetermined: 还未设置，通常在这里重新申请权限
    .denied: 已拒绝
    .authorized: 已设置权限
    .provisional:
    .ephemeral:
    */
    var authorizationStatus: UNAuthorizationStatus
    /*
    .enabled: 开启声音
    .disabled: 关闭声音
    .notSupported: 不支持
    */
    var sound: UNNotificationSetting
    /*
    .enabled: 开启角标
    .disabled: 关闭角标
    .notSupported: 不支持
    */
    var badge: UNNotificationSetting
    /*
    .enabled: 开启锁屏显示
    .disabled: 关闭锁屏显示
    .notSupported: 不支持
    */
    var lockScreen: UNNotificationSetting
    /*
    .enabled: 开启历史记录显示
    .disabled: 关闭历史记录显示
    .notSupported: 不支持
    */
    var notificationCenter: UNNotificationSetting
    /*
    .enabled: 开启横幅显示
    .disabled: 关闭横幅显示
    .notSupported: 不支持
    */
    var alert: UNNotificationSetting
    /*
    .always: 始终显示预览
    .whenAuthenticated: 解锁时预览
    .never: 不预览
    */
    var previews: UNShowPreviewsSetting
}
