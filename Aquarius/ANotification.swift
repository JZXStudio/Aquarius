//
//  ANotification.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/8/12.
//

import Foundation

/// 通知管理类
///
/// *Sample:*
///
/// `swift
/// let notification: ANotification = ANotification([
///     notificationName1,
///     nptificationName2
/// ])
/// `
open class ANotification: NSObject {
    public static let kANotificationData: String = "a_notification_data"
    static let kANotificationInThread_Name: String = "a_notification_in_thread_name"
    static let kANotification_OnceTag: String = "a_notification_once_tag"
    
    var notificationNames: Array<String> = []
    
    public weak var delegate: ANotificationDelegate?
    
    deinit {
        delegate = nil
        clearNotifications()
    }
    
    public override init() {
        super.init()
        
        self.a_Notifications(notificationsNames: self.notificationNames)
    }
    
    public init(notifications: Array<String>) {
        super.init()
        
        self.notificationNames = notifications
        self.a_Notifications(notificationsNames: self.notificationNames)
    }
    
    private func a_Notifications(notificationsNames:Array<String>) {
        for notificationName: String in notificationsNames {
            NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(notification:)), name: Notification.Name(notificationName), object: nil)
        }
    }
    /// 清除所有通知
    public func clearNotifications() {
        for notificationName: String in self.notificationNames {
            NotificationCenter.default.removeObserver(self, name: Notification.Name(notificationName), object: nil)
        }
        
        self.notificationNames.removeAll()
    }
    /// 添加通知
    /// - Parameter notificationName: 通知名称
    public func addNotification(notificationName: String) {
        self.notificationNames.append(notificationName)
        
        self.a_Notifications(notificationsNames: [notificationName])
    }
    /// 添加多个通知
    /// - Parameter notificationNames: 通知名称数组
    public func addNotifications(notificationNames: Array<String>) {
        for notificationName: String in notificationNames {
            self.notificationNames.append(notificationName)
        }
        
        self.a_Notifications(notificationsNames: notificationNames)
    }
    /// 删除通知
    /// - Parameter notificationName: 通知名称
    public func removeNotification(notificationName: String) {
        let i: Int = self.searchNotification(notificationName: notificationName)
        if i == -1 {
            return
        }
        self.notificationNames.remove(at: i)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(notificationName), object: nil)
    }
    /// 删除多个通知
    /// - Parameter notificationNames: 要删除的通知数组
    /// - Returns: 是否成功
    @discardableResult
    public func removeNotifications(notificationNames: Array<String>) -> Bool {
        var isRemoveSuccess = false
        for notificationName: String in notificationNames {
            let index: Int = self.searchNotification(notificationName: notificationName)
            if index == -1 {
                isRemoveSuccess = true
                continue
            }
            
            self.notificationNames.remove(at: index)
            NotificationCenter.default.removeObserver(self, name: Notification.Name(notificationName), object: nil)
        }
        
        return isRemoveSuccess
    }
    /// 发送通知
    /// - Parameters:
    ///   - notificationName: 通知名称
    ///   - object: 传递的通知对象
    public static func PostNotification(notificationName: String, object: Dictionary<String, Any>?=nil) {
        NotificationCenter.default.post(name: Notification.Name(notificationName), object: object)
    }
    /// 向主线程发送通知
    /// - Parameters:
    ///   - notificationName: 通知名称
    ///   - object: 传递的通知对象
    public static func PostMainNotification(notificationName: String, object: Dictionary<String, Any>?=nil) {
        DispatchGroup().notify(queue: DispatchQueue.main) {
            NotificationCenter.default.post(name: Notification.Name(notificationName), object: object)
        }
    }
    
    public static func PostOnceNotification(notificationName: String, object: Dictionary<String, Any>) {
        var newObject: Dictionary<String, Any> = [:]
        if !object.isEmpty {
            newObject = object
        }
        newObject[kANotification_OnceTag] = NSNumber.init(value: true)
        self.PostNotification(notificationName: notificationName, object: newObject)
    }
    /// 组装成标准的通知传递对象
    ///
    /// **Sample:**
    ///
    /// **发送通知**
    ///
    /// `swift
    /// let value: String = "notificationValue"
    /// let object: [String : Any] = packageCoreNotificationDataValue(value)
    /// ANotification.PostNotification("notification name", object)
    /// `
    ///
    /// **接收通知**
    ///
    /// `swift
    /// func ANotificationReceive(notification: Notification) {
    /// if notification.isNotificationName("notification name") {
    ///     let object: Any = notification.objectValue(kANotificationData)
    ///     A.log.info(object as String)
    /// }
    ///
    /// - Parameter value: 传递对象
    /// - Returns: 组装的字典
    public static func packageCoreNotificationDataValue(value:Any) -> Dictionary<String, Any> {
        return [kANotificationData : value]
    }
    
    public func searchNotification(notificationName: String) -> Int {
        var isExistNotification: Bool = false
        var i: Int = 0
        for currentNotificationName: String in self.notificationNames {
            if currentNotificationName == notificationName {
                isExistNotification = true
                break
            } else {
                i = i + 1
            }
        }
        
        if !isExistNotification {
            i = -1
        }
        
        return i
    }
    
    @objc public func receiveNotification(notification: Notification) {
        if (notification.object != nil) {
            if notification.object is Dictionary<String, String> {
                let notificationObject: Dictionary<String, Any> = notification.object as! Dictionary<String, Any>
                
                var onceTag: NSNumber = NSNumber(value: false)
                
                if notificationObject[ANotification.kANotification_OnceTag] != nil {
                    onceTag = notificationObject[ANotification.kANotification_OnceTag] as! NSNumber
                }
                
                if onceTag.boolValue {
                    self.removeNotification(notificationName: notification.name.rawValue)
                }
            }
        }
        
        delegate?.ANotificationReceive(notification: notification)
    }
}

public protocol ANotificationDelegate: NSObjectProtocol {
    /// 接收通知的delegate
    /// - Parameter notification: 通知名称
    func ANotificationReceive(notification: Notification)
}
