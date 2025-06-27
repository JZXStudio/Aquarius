//
//  Bool++.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/10/8.
//

import Foundation

extension Bool {
    /// 判断传入的flag是否为true，如果为true，则赋值给当前bool
    /// - Parameter flag: 传入值
    public mutating func a_isValid(_ flag: Bool) {
        if flag {
            self = flag
        }
    }
    /// 转换为true
    public mutating func toTrue() {
        self = true
    }
    /// 转换为false
    public mutating func toFalse() {
        self = false
    }
    /// 转换为Int类型
    /// - Returns: 转换后结果
    public func toInt() -> Int {
        return self ? 1 : 0
    }
    
    public func toString() -> String {
        return self ? "1" : "0"
    }
}

public struct A_true {
    @discardableResult
    public init(_ flag: inout Bool) {
        flag = true
    }
}

public struct A_false {
    @discardableResult
    public init(_ flag: inout Bool) {
        flag = false
    }
}

public struct A_reversal {
    @discardableResult
    public init(_ flag: inout Bool) {
        flag = !flag
    }
}
