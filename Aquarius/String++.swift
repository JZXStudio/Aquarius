//
//  String++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/1.
//

import UIKit
import Foundation

extension String {
    public var a_color: UIColor {
        var cString : String = self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        // String should be 6 or 8 characters
        if cString.count < 6 {
            return UIColor.clear
        }
        // 判断前缀
        if cString.hasPrefix("0x") {
            cString.removeFirst(2)
        }
        
        if cString.hasPrefix("0X") {
            cString.removeFirst(2)
        }
        
        if cString.hasPrefix("#") {
            cString.removeFirst(1)
        }
        
        if cString.count != 6 {
            return UIColor.clear
        }
        
        // 从六位数值中找到RGB对应的位数并转换
        let mask = 0x000000FF
        let r: Int
        let g: Int
        let b: Int
                
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        if #available(iOS 13.0, *) {
            // 系统版本高于13.0
            var color: UInt64 = 0
            let scanner = Scanner(string: cString)
            scanner.scanHexInt64(&color)
                    
            r = Int(color >> 16) & mask
            g = Int(color >> 8) & mask
            b = Int(color) & mask
                    
            red   = CGFloat(r)
            green = CGFloat(g)
            blue  = CGFloat(b)
        } else {
            // 系统版本低于13.0
            var color: UInt32 = 0
            let scanner = Scanner(string: cString)
            scanner.scanHexInt32(&color)

            r = Int(color >> 16) & mask
            g = Int(color >> 8) & mask
            b = Int(color) & mask
                    
            red   = CGFloat(r)
            green = CGFloat(g)
            blue  = CGFloat(b)
        }
        return UIColor.init(red: (red / 255.0), green: (green / 255.0), blue: (blue / 255.0), alpha: 1.0)
    }
    
    public var asURL: URL? {
        URL(string: self)
    }
    //转字典
    public var toDictionary: [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
    //转数组
    public var toArray: [Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]
    }
    //转AttributedString
    public var toAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return NSAttributedString()
        }
        
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType : NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return NSAttributedString()
        }
    }
    //返回本地化
    public var toLocalized: String {
        NSLocalizedString(self, comment: "")
    }
    //判断是否只包含数字
    public var isOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }
    //如果字符串不是空的并且只包含字母数字字符，则返回 true
    public var isAlphanumeric: Bool {
        !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    //检查是否是email
    public var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    public var length: Int {
        get {
            return self.count
        }
    }

    public func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }

    public func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }

    public func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return String(self[indexRange])
    }
    /// 根据start和end查找包含的字符串（只查找第一个匹配的）
    /// - Parameters:
    ///   - start: 起始字符串
    ///   - end: 终止字符串
    /// - Returns: 查找结果
    public func substring(_ start: String, _ end: String) -> String? {
        guard
            let leftRange = range(of: start), let rightRange = range(of: end, options: .backwards)
            , leftRange.upperBound <= rightRange.lowerBound
            else { return nil }

        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: end)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }

    public func character(_ at: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: at)]
    }

    public func lastIndexOfCharacter(_ c: Character) -> Int? {
        return range(of: String(c), options: .backwards)?.lowerBound.utf16Offset(in: self)
    }
    
    public func findLast(_ sub:String)->Int {
        var pos = -1
        if let range = range(of:sub, options: .backwards ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
    static public
    func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    static public
    func dateConvertString(date: Date, dateFormat: String = "yyyy-MM-dd") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    /// 转换Date
    /// - Parameter dateFormat: 日期格式
    /// - Returns: 转换后的Date
    ///
    /// **Note: dateFromat默认值为"yyyy-MM-dd HH:mm:ss"**
    ///
    public func toDate(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        return date!
    }
    /// 转换成yyyy-MM-dd格式Date
    /// - Returns: 转换后的Date
    public func toShortDate() -> Date {
        return toDate("yyyy-MM-dd")
    }
    /// 转换成yyyy-MM-dd HH:mm:ss格式Date
    /// - Returns: 转换后的Date
    public func toLongDate() -> Date {
        return toDate("yyyy-MM-dd HH:mm:ss")
    }
    /// 转换为UIImage类型
    /// - Returns: 转换后的UIImage
    public func toContentsOfFileImage() -> UIImage? {
        return UIImage.init(contentsOfFile: self)
    }
    /// 转换为UIImage类型
    /// - Returns: 转换后的UIImage
    public func toNamedImage() -> UIImage? {
        return UIImage(named: self)
    }
    /// 转换为UIImage类型
    /// - Returns: 转换后的UIImage
    public func toSystemNameImage() -> UIImage? {
        return UIImage(systemName: self)
    }
    /// 转换为Int类型
    /// - Returns: 转换结果
    public func toInt() -> Int? {
        return Int(self)
    }
    /// 转换为Bool类型
    /// - Returns: 转换结果
    public func toBool() -> Bool {
        return self == "1" ? true : false
    }
    /// 转换为CGFloat类型
    /// - Returns: 转换结果
    public func toCGFloat() -> CGFloat {
        if let number = Double(self) {
            return CGFloat(number)
        } else {
            return 0.0
        }
    }
    /// 转换为double类型
    /// - Returns: 转换结果
    public func toDouble() -> Double {
        if let number = Double(self) {
            return number
        } else {
            return 0.0
        }
    }
    /// 判断传入的参数是否为空，如果不为空的话，则赋值给该String
    /// - Parameter string: 待判断的String
    public mutating func a_isValid(_ string: String) {
        if string != "" {
            self = string
        }
    }
    
    public func toAttributedString(_ styleDictionary: [NSAttributedString.Key : Any]) -> NSAttributedString {
        let attrStr: NSMutableAttributedString = NSMutableAttributedString(string: self)
        let range: NSRange = NSRange(location: 0, length: self.count)
        attrStr.addAttributes(styleDictionary, range: range)
        return attrStr
    }
    
    /// 计算字符串的尺寸
    ///
    /// - Parameters:
    ///   - rectSize: 容器的尺寸
    ///   - font: 字体
    /// - Returns: 尺寸
    ///
    public func getStringSize(rectSize: CGSize,font: UIFont) -> CGSize {
        let str: NSString = self as NSString
        let rect = str.boundingRect(with: rectSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
    
    public func getStringWidth(rectSize: CGSize,font: UIFont) -> CGFloat {
        self.getStringSize(rectSize: rectSize, font: font).width
    }
    
    public func getStringWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        return self.getStringSize(rectSize: CGSizeMake(screenWidth-height, height), font: font).width
    }
    
    public func getStringHeight(rectSize: CGSize,font: UIFont) -> CGFloat {
        self.getStringSize(rectSize: rectSize, font: font).height
    }
    
    public func getStringHeight(width: CGFloat,font: UIFont) -> CGFloat {
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        return self.getStringSize(rectSize: CGSizeMake(width, screenHeight-width), font: font).height
    }
}
