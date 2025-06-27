//
//  Int.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/1/26.
//

import UIKit
import Foundation

public typealias Color = UIColor

extension Int {
    public var toColor: UIColor {
        let red = CGFloat(self as Int >> 16 & 0xff) / 255
        let green = CGFloat(self >> 8 & 0xff) / 255
        let blue  = CGFloat(self & 0xff) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    //时间戳转date
    public func timestampToDate() -> Date {
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timeInterval)
         /*
        //格式话输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print("对应的日期时间：\(dformatter.string(from: date))")
          */
        return date
    }
    //替代++操作
    public mutating func add(_ value: Int=1) {
        self = self + value
    }
    
    public func toDouble() -> Double {
        Double(self)
    }
    
    public func toString() -> String {
        return String(describing: self)
    }
    
    public var toFont: UIFont {
        UIFont.systemFont(ofSize: CGFloat(self))
    }
    
    public var toBoldFont: UIFont {
        UIFont.boldSystemFont(ofSize: CGFloat(self))
    }
    
    public var toCGFloat: CGFloat {
        CGFloat(self)
    }
    
    public var toNumber: NSNumber {
        NSNumber(integerLiteral: self)
    }
}

precedencegroup AlphaPrecedence {
  associativity: left
  higherThan: RangeFormationPrecedence
  lowerThan: AdditionPrecedence
}

infix operator ~ : AlphaPrecedence

public func ~ (color: Color, alpha: Int) -> Color {
  return color ~ CGFloat(alpha)
}
public func ~ (color: Color, alpha: Float) -> Color {
  return color ~ CGFloat(alpha)
}
public func ~ (color: Color, alpha: CGFloat) -> Color {
  return color.withAlphaComponent(alpha)
}

/// e.g. `50%`
postfix operator %
public postfix func % (percent: Int) -> CGFloat {
  return CGFloat(percent)%
}
public postfix func % (percent: Float) -> CGFloat {
  return CGFloat(percent)%
}
public postfix func % (percent: CGFloat) -> CGFloat {
  return percent / 100
}

postfix operator ++
@discardableResult
public postfix func ++ (value: inout Int) -> Int {
    value = value + 1
    return value
}

postfix operator --
@discardableResult
public postfix func -- (value: inout Int) -> Int {
    value = value - 1
    return value
}
