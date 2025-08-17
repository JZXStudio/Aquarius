//
//  Dictionary++.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/2/11.
//
import UIKit
import Foundation

extension Dictionary {
    //获取第一个key，一般用在字典里只有一个的时候
    public var firstKey: Any? {
        get {
            return getKey()
        }
    }
    //获取第一个value，一般用在字典里只有一个的时候
    public var firstValue: Any? {
        get {
            return getValue()
        }
    }
    //获取指定位置的key，一般用在字典里有多个key和value的时候
    public func getKey(_ at: Int = 0) -> Any {
        return Array(self.keys)[at]
    }
    
    public func getBoolKey(_ at: Int = 0) -> Bool {
        return getKey(at) as! Bool
    }
    
    public func getElementKey(_ at: Int = 0) -> Element {
        return getKey(at) as! Element
    }
    
    public func getStringKey(_ at: Int = 0) -> String {
        return getKey(at) as! String
    }
    
    public func getIntKey(_ at: Int = 0) -> Int {
        return getKey(at) as! Int
    }
    
    public func getDoubleKey(_ at: Int = 0) -> Double {
        return getKey(at) as! Double
    }
    
    public func getUIntKey(_ at: Int = 0) -> UInt {
        return getKey(at) as! UInt
    }
    //获取指定位置的value，一般用在字典里有多个key和value的时候
    public func getValue(_ at: Int = 0) -> Any {
        return Array(self.values)[at]
    }
    
    public func getStringValue(_ at: Int = 0) -> String {
        return getValue(at) as! String
    }
    
    public func getStringValue(_ keyString: String) -> String {
        let obj = self as? [String : Any]
        return obj![keyString] as! String
    }
    
    public func getBoolValue(_ at: Int = 0) -> Bool {
        return getValue(at) as! Bool
    }
    
    public func getBoolValue(_ keyString: String) -> Bool {
        let obj = self as? [String : Any]
        return obj![keyString] as! Bool
    }
    
    public func getIntValue(_ at: Int = 0) -> Int {
        return getValue(at) as! Int
    }
    
    public func getIntValue(_ keyString: String) -> Int {
        let obj = self as? [String : Any]
        return obj![keyString] as! Int
    }
    
    public func getDoubleValue(_ at: Int = 0) -> Double {
        return getValue(at) as! Double
    }
    
    public func getDoubleValue(_ keyString: String) -> Double {
        let obj = self as? [String : Any]
        return obj![keyString] as! Double
    }
    
    public func getFloatValue(_ at: Int = 0) -> CGFloat {
        return getValue(at) as! CGFloat
    }
    
    public func getFloatValue(_ keyString: String) -> Float {
        let obj = self as? [String : Any]
        return obj![keyString] as! Float
    }
    
    public func getDateValue(_ at: Int = 0) -> Date {
        return getValue(at) as! Date
    }
    
    public func getDateValue(_ keyString: String) -> Date {
        let obj = self as? [String : Any]
        return obj![keyString] as! Date
    }
    
    public func getDataValue(_ at: Int = 0) -> Data {
        return getValue(at) as! Data
    }
    
    public func getUIntValue(_ at: Int = 0) -> UInt {
        return getValue(at) as! UInt
    }
    
    public func getDataValue(_ keyString: String) -> Data {
        let obj = self as? [String : Any]
        return obj![keyString] as! Data
    }
    
    public func getImageValue(_ at: Int = 0) -> UIImage {
        return getValue(at) as! UIImage
    }
    
    public func getImageValue(_ keyString: String) -> UIImage {
        let obj = self as? [String : Any]
        return obj![keyString] as! UIImage
    }
}
