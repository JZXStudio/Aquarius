//
//  AUserDefaults.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/9/5.
//

import Foundation

/// 本地存储
public struct AUserDefaults {
    /// 单例
    public static let shared = AUserDefaults()
    internal static var userDefaultKey: String = ""
    /// 设置本地存储的KEY
    ///
    /// 此方法需与**setValue**共同使用
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// userDefaults.fotKey("key值")
    /// ```
    /// - Parameter key: key值
    public func forKey(_ key: String) {
        AUserDefaults.userDefaultKey = key
    }
    /// 设置本地存储的KEY对应的值
    ///
    /// 此方法需与**forKey**共同使用
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// userDefaults.fotKey("key值")
    /// userDefaults.setValue(20)
    /// ```
    /// - Parameter value: key对应的值
    public func setValue(_ value: Any) {
        if AUserDefaults.userDefaultKey != "" {
            UserDefaults.standard.setValue(value, forKey: AUserDefaults.userDefaultKey)
            AUserDefaults.userDefaultKey = ""
        }
    }
    /// 获取本地存储的KEY对应的值
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: Any = userDefaults.getValue("key值")!
    /// let boolValue: Bool = userDefaults.getValue("key值") as! Bool
    /// ```
    /// - Parameter key: key
    /// - Returns: 对应的value（Any类型，需要自行转换为对应的数据类型）
    public func getValue(_ key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    /// 获取本地存储的KEY对应的值（自动转换为String类型）
    ///
    /// **此方不安全，需要提前判断值类型是否为String，否则报错**
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: String = userDefaults.getStringValue("key值")!
    /// ```
    /// - Parameter key: key
    /// - Returns: String类型的value
    public func getStringValue(_ key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    /// 获取本地存储的KEY对应的值（自动转换为数组类型）
    ///
    /// **此方不安全，需要提前判断值类型是否为数组类型，否则报错**
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: [Any] = userDefaults.getArrayValue("key值")!
    /// ```
    /// - Parameter key: key
    /// - Returns: 数组类型的value
    public func getArrayValue(_ key: String) -> [Any]? {
        return UserDefaults.standard.array(forKey: key)
    }
    /// 获取本地存储的KEY对应的值（自动转换为字典类型）
    ///
    /// **此方不安全，需要提前判断值类型是否为字典类型，否则报错**
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: [String, Any] = userDefaults.getDictionaryValue("key值")!
    /// ```
    /// - Parameter key: key
    /// - Returns: 字典类型的value
    public func getDictionaryValue(_ key: String) -> Dictionary<String, Any>? {
        return UserDefaults.standard.dictionary(forKey: key)
    }
    /// 获取本地存储的KEY对应的值（自动转换为data类型）
    ///
    /// **此方不安全，需要提前判断值类型是否为字典类型，否则报错**
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: Data = userDefaults.getDataValue("key值")!
    /// ```
    /// - Parameter key: key
    /// - Returns: Data类型的value
    public func getDataValue(_ key: String) -> Data? {
        return UserDefaults.standard.data(forKey: key)
    }
    /// 获取本地存储的KEY对应的值（自动转换为String类型的数组）
    ///
    /// **此方不安全，需要提前判断值类型是否为字典类型，否则报错**
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: [String] = userDefaults.getStringArrayValue("key值")!
    /// ```
    /// - Parameter key: key
    /// - Returns: String类型的数组
    public func getStringArrayValue(_ key: String) -> [String]? {
        return UserDefaults.standard.stringArray(forKey: key)
    }
    /// 获取本地存储的KEY对应的值（自动转换为Int类型）
    ///
    /// 此方不安全，需要提前判断值类型是否为Int，否则报错
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: Int = userDefaults.getIntValue("key值")!
    /// ```
    /// - Parameter key: key
    /// - Returns: Int类型的value
    public func getIntValue(_ key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    /// 获取本地存储的KEY对应的值（自动转换为NSInteger类型）
    ///
    /// 此方不安全，需要提前判断值类型是否为NSInteger，否则报错
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: NSInteger = userDefaults.getIntegerValue("key值")!
    /// ```
    /// - Parameter key: key
    /// - Returns: NSInteger类型的value
    public func getIntegerValue(_ key: String) -> NSInteger {
        return UserDefaults.standard.integer(forKey: key)
    }
    /// 获取本地存储的KEY对应的值（自动转换为Float类型）
    ///
    /// 此方不安全，需要提前判断值类型是否为Float，否则报错
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: Float = userDefaults.getFloatValue("key值")!
    /// ```
    /// - Parameter key: key
    /// - Returns: Float类型的value
    public func getFloatValue(_ key: String) -> Float {
        return UserDefaults.standard.float(forKey: key)
    }
    /// 获取本地存储的KEY对应的值（自动转换为Double类型）
    ///
    /// 此方不安全，需要提前判断值类型是否为Double，否则报错
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: Double = userDefaults.getDoubleValue("key值")!
    /// ```
    /// - Parameter key: key
    /// - Returns: Double类型的value
    public func getDoubleValue(_ key: String) -> Double {
        return UserDefaults.standard.double(forKey: key)
    }
    /// 获取本地存储的KEY对应的值（自动转换为Bool类型）
    ///
    /// 此方不安全，需要提前判断值类型是否为Bool，否则报错
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: Bool = userDefaults.getBoolValue("key值")!
    /// ```
    /// - Parameter key: key
    /// - Returns: Bool类型的value
    public func getBoolValue(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    public func getDateValue(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    /// 获取本地存储的KEY对应的值（自动转换为URL类型）
    ///
    /// 此方不安全，需要提前判断值类型是否为URL，否则报错
    /// ```
    /// let userDefaults: AUserDefaults = A.ui.userDefaults
    /// let value: URL = userDefaults.getURLValue("key值")!
    /// ```
    /// - Parameter key: key
    /// - Returns: URL类型的value
    public func getURLValue(_ key: String) -> URL? {
        return UserDefaults.standard.url(forKey: key)
    }
}
