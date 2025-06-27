//
//  Notification++.swift
//  Aquarius
//
//  Created by SONG JIN on 2025/5/6.
//

import Foundation

extension Notification {
    /// 获取通知名称
    /// - Returns: 通知名称
    public func nameValue() -> String {
        return self.name.rawValue
    }
    /// 获取传递的对象
    ///
    /// **Note: 此方法不安全，传递的值必须为[String : Any]的字典**
    ///
    /// - Parameter key: key值
    /// - Returns: 对应的value
    public func objectValue(_ key: String) -> Any {
        let dict: [String : Any] = self.object as! [String : Any]
        return dict[key] as Any
    }
    /// 判断是否为当前通知
    /// - Parameter notificationName: 通知名称
    /// - Returns: 是否相同
    public func isNotificationName(_ notificationName: String) -> Bool {
        return self.nameValue() == notificationName
    }
}
