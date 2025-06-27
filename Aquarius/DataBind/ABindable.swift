//
//  ABindable.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/2/27.
//

import UIKit
import Foundation

//ABindableFrom:单个key的单项传递
//ABindableFromMuitiple:多个key的单项传递
//ABindableTo:单个key的单项传递
//ABindableToMuitiple:多个key的单项传递
//ABindable:单个key的双向传递
//ABindableFromTo:key1为from，key2为to的单项传递

class ABindable: NSObject {
    public static func checkBind(_ bindObject: Any) -> Bool {
        if bindObject is ABindableAny ||
            bindObject is ABindableInt ||
            bindObject is ABindableBool ||
            bindObject is ABindableDate ||
            //bindObject is ABindableFrom ||
            bindObject is ABindableArray ||
            bindObject is ABindableColor ||
            bindObject is ABindableImage ||
            bindObject is ABindableDouble ||
            bindObject is ABindableString ||
            bindObject is ABindableDictionary ||
            bindObject is ABindableCGFloat ||
            bindObject is ABindableFromAny ||
            bindObject is ABindableFromInt ||
            bindObject is ABindableFromBool ||
            bindObject is ABindableFromDate ||
            bindObject is ABindableFromArray ||
            bindObject is ABindableFromColor ||
            bindObject is ABindableFromImage ||
            bindObject is ABindableFromDouble ||
            bindObject is ABindableFromString ||
            bindObject is ABindableFromDictionary ||
            bindObject is ABindableFromCGFloat ||
            bindObject is ABindableToAny ||
            bindObject is ABindableToInt ||
            bindObject is ABindableToBool ||
            bindObject is ABindableToDate ||
            bindObject is ABindableToArray ||
            bindObject is ABindableToColor ||
            bindObject is ABindableToImage ||
            bindObject is ABindableToDouble ||
            bindObject is ABindableToString ||
            bindObject is ABindableToDictionary ||
            bindObject is ABindableToCGFloat ||
            bindObject is ABindableFromToAny ||
            bindObject is ABindableFromToInt ||
            bindObject is ABindableFromToBool ||
            bindObject is ABindableFromToDate ||
            bindObject is ABindableFromToArray ||
            bindObject is ABindableFromToColor ||
            bindObject is ABindableFromToImage ||
            bindObject is ABindableFromToDouble ||
            bindObject is ABindableFromToString ||
            bindObject is ABindableFromToDictionary ||
            bindObject is ABindableFromToCGFloat ||
            bindObject is ABindableFromMultipleAny ||
            bindObject is ABindableFromMultipleInt ||
            bindObject is ABindableFromMultipleBool ||
            bindObject is ABindableFromMultipleDate ||
            bindObject is ABindableFromMultipleArray ||
            bindObject is ABindableFromMultipleColor ||
            bindObject is ABindableFromMultipleImage ||
            bindObject is ABindableFromMultipleDouble ||
            bindObject is ABindableFromMultipleString ||
            bindObject is ABindableFromMultipleDictionary ||
            bindObject is ABindableFromMultipleCGFloat ||
            bindObject is ABindableToMultipleAny ||
            bindObject is ABindableToMultipleInt ||
            bindObject is ABindableToMultipleBool ||
            bindObject is ABindableToMultipleDate ||
            bindObject is ABindableToMultipleArray ||
            bindObject is ABindableToMultipleColor ||
            bindObject is ABindableToMultipleImage ||
            bindObject is ABindableToMultipleDouble ||
            bindObject is ABindableToMultipleString ||
            bindObject is ABindableToMultipleDictionary ||
            bindObject is ABindableToMultipleCGFloat
        {
            return true
        }
        return false
    }
}

public typealias Bool_ = ABindableFromBool
@propertyWrapper open
class ABindableFromBool: NSObject {
    @objc dynamic public
    var attribute: Bool = false
    private let bindKey: String
    public var wrappedValue: Bool {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindFrom(bindKey: bindKey, attribute: #keyPath(attribute))
    }
}
public typealias MultipleBool_ = ABindableFromMultipleBool
@propertyWrapper open
class ABindableFromMultipleBool: NSObject {
    @objc dynamic public
    var attribute: Bool = false
    private var bindKeys: [String]
    public var wrappedValue: Bool {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindFrom(bindKey: currentBindKey, attribute: #keyPath(attribute))
        }
    }
}
public typealias _Bool = ABindableToBool
@propertyWrapper open
class ABindableToBool: NSObject {
    private let bindKey: String
    private var executeBlock: ((Bool) -> Void)?
    @objc dynamic public
    var wrappedValue: Bool = false {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Bool) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _MultipleBool = ABindableToMultipleBool
@propertyWrapper open
class ABindableToMultipleBool: NSObject {
    private var bindKeys: [String]
    private var executeBlock: ((Bool) -> Void)?
    @objc dynamic public
    var wrappedValue: Bool = false {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindTo(bindKey: currentBindKey, attribute: #keyPath(wrappedValue))
        }
    }
    
    public func change(_ block: ((Bool) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _Bool_ = ABindableBool
@propertyWrapper open
class ABindableBool: NSObject {
    private let bindKey: String
    private var executeBlock: ((Bool) -> Void)?
    @objc dynamic public
    var wrappedValue: Bool = false {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        self.bindFrom(bindKey: bindKey, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Bool) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias AB_Bool = ABindableFromToBool
@propertyWrapper open
class ABindableFromToBool: NSObject {
    private var bindKeys: [String] = []
    private var executeBlock: ((Bool) -> Void)?
    @objc dynamic public
    var wrappedValue: Bool = false {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey1: String, _ bindKey2: String) {
        self.bindKeys = [bindKey1, bindKey2]
        super.init()
        
        self.bindFrom(bindKey: bindKey1, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey2, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Bool) -> Void)?) {
        self.executeBlock = block
    }
}
//MARK: String
public typealias String_ = ABindableFromString
@propertyWrapper open
class ABindableFromString: NSObject {
    private let bindKey: String
    @objc dynamic public
    var attribute: String = ""
    
    public var wrappedValue: String {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindFrom(bindKey: bindKey, attribute: #keyPath(attribute))
    }
}
public typealias MultipleString_ = ABindableFromMultipleString
@propertyWrapper open
class ABindableFromMultipleString: NSObject {
    private var bindKeys: [String]
    @objc dynamic public
    var attribute: String = ""
    
    public var wrappedValue: String {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindFrom(bindKey: currentBindKey, attribute: #keyPath(attribute))
        }
    }
}
public typealias _String_ = ABindableString
@propertyWrapper open
class ABindableString: NSObject {
    private let bindKey: String
    private var executeBlock: ((String) -> Void)?
    @objc dynamic public
    var wrappedValue: String = "" {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        self.bindFrom(bindKey: bindKey, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((String) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _String = ABindableToString
@propertyWrapper open
class ABindableToString: NSObject {
    private let bindKey: String
    private var executeBlock: ((String) -> Void)?
    @objc dynamic public
    var wrappedValue: String = "" {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((String) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _MultipleString = ABindableToMultipleString
@propertyWrapper open
class ABindableToMultipleString: NSObject {
    private var bindKeys: [String]
    private var executeBlock: ((String) -> Void)?
    @objc dynamic public
    var wrappedValue: String = "" {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindTo(bindKey: currentBindKey, attribute: #keyPath(wrappedValue))
        }
    }
    
    public func change(_ block: ((String) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias AB_String = ABindableFromToString
@propertyWrapper open
class ABindableFromToString: NSObject {
    private var bindKeys: [String] = []
    private var executeBlock: ((String) -> Void)?
    @objc dynamic public
    var wrappedValue: String = "" {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey1: String, _ bindKey2: String) {
        self.bindKeys = [bindKey1, bindKey2]
        super.init()
        
        self.bindFrom(bindKey: bindKey1, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey2, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((String) -> Void)?) {
        self.executeBlock = block
    }
}
//MARK: Int
public typealias Int_ = ABindableFromInt
@propertyWrapper open
class ABindableFromInt: NSObject {
    private let bindKey: String
    @objc dynamic public
    var attribute: Int = -1
    
    public var wrappedValue: Int {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindFrom(bindKey: bindKey, attribute: #keyPath(attribute))
    }
}
public typealias MultipleInt_ = ABindableFromMultipleInt
@propertyWrapper open
class ABindableFromMultipleInt: NSObject {
    private var bindKeys: [String]
    @objc dynamic public
    var attribute: Int = -1
    
    public var wrappedValue: Int {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindFrom(bindKey: currentBindKey, attribute: #keyPath(attribute))
        }
    }
}
public typealias _Int = ABindableToInt
@propertyWrapper open
class ABindableToInt: NSObject {
    private let bindKey: String
    private var executeBlock: ((Int) -> Void)?
    @objc dynamic public
    var wrappedValue: Int = 0 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Int) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _MultipleInt = ABindableToMultipleInt
@propertyWrapper open
class ABindableToMultipleInt: NSObject {
    private var bindKeys: [String]
    private var executeBlock: ((Int) -> Void)?
    @objc dynamic public
    var wrappedValue: Int = -1 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindTo(bindKey: currentBindKey, attribute: #keyPath(wrappedValue))
        }
    }
    
    public func change(_ block: ((Int) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _Int_ = ABindableInt
@propertyWrapper open
class ABindableInt: NSObject {
    private let bindKey: String
    private var executeBlock: ((Int) -> Void)?
    @objc dynamic public
    var wrappedValue: Int = 0 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        self.bindFrom(bindKey: bindKey, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Int) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias AB_Int = ABindableFromToInt
@propertyWrapper open
class ABindableFromToInt: NSObject {
    private var bindKeys: [String] = []
    private var executeBlock: ((Int) -> Void)?
    @objc dynamic public
    var wrappedValue: Int = -1 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey1: String, _ bindKey2: String) {
        self.bindKeys = [bindKey1, bindKey2]
        super.init()
        
        self.bindFrom(bindKey: bindKey1, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey2, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Int) -> Void)?) {
        self.executeBlock = block
    }
}
//MARK: Double
public typealias Double_ = ABindableFromDouble
@propertyWrapper open
class ABindableFromDouble: NSObject {
    private let bindKey: String
    @objc dynamic public
    var attribute: Double = 0.0
    
    public var wrappedValue: Double {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindFrom(bindKey: bindKey, attribute: #keyPath(attribute))
    }
}
public typealias MultipleDouble_ = ABindableFromMultipleDouble
@propertyWrapper open
class ABindableFromMultipleDouble: NSObject {
    private var bindKeys: [String]
    @objc dynamic public
    var attribute: Double = 0.0
    
    public var wrappedValue: Double {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindFrom(bindKey: currentBindKey, attribute: #keyPath(attribute))
        }
    }
}
public typealias _Double = ABindableToDouble
@propertyWrapper open
class ABindableToDouble: NSObject {
    private let bindKey: String
    private var executeBlock: ((Double) -> Void)?
    @objc dynamic public
    var wrappedValue: Double = 0.0 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Double) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _MultipleDouble = ABindableToMultipleDouble
@propertyWrapper open
class ABindableToMultipleDouble: NSObject {
    private var bindKeys: [String]
    private var executeBlock: ((Double) -> Void)?
    @objc dynamic public
    var wrappedValue: Double = 0.0 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindTo(bindKey: currentBindKey, attribute: #keyPath(wrappedValue))
        }
    }
    
    public func change(_ block: ((Double) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _Double_ = ABindableDouble
@propertyWrapper open
class ABindableDouble: NSObject {
    private let bindKey: String
    private var executeBlock: ((Double) -> Void)?
    @objc dynamic public
    var wrappedValue: Double = 0.0 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        self.bindFrom(bindKey: bindKey, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Double) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias AB_Double = ABindableFromToDouble
@propertyWrapper open
class ABindableFromToDouble: NSObject {
    private var bindKey: [String] = []
    private var executeBlock: ((Double) -> Void)?
    @objc dynamic public
    var wrappedValue: Double = 0.0 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey1: String, _ bindKey2: String) {
        self.bindKey = [bindKey1, bindKey2]
        super.init()
        
        self.bindFrom(bindKey: bindKey1, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey2, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Double) -> Void)?) {
        self.executeBlock = block
    }
}
//MARK: Color
public typealias Color_ = ABindableFromColor
@propertyWrapper open
class ABindableFromColor: NSObject {
    private let bindKey: String
    @objc dynamic public
    var attribute: UIColor = .clear
    
    public var wrappedValue: UIColor {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindFrom(bindKey: bindKey, attribute: #keyPath(attribute))
    }
}
public typealias MultipleColor_ = ABindableFromMultipleColor
@propertyWrapper open
class ABindableFromMultipleColor: NSObject {
    private var bindKeys: [String]
    @objc dynamic public
    var attribute: UIColor = .clear
    
    public var wrappedValue: UIColor {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindFrom(bindKey: currentBindKey, attribute: #keyPath(attribute))
        }
    }
}
public typealias _Color = ABindableToColor
@propertyWrapper open
class ABindableToColor: NSObject {
    private let bindKey: String
    private var executeBlock: ((UIColor) -> Void)?
    @objc dynamic public
    var wrappedValue: UIColor = .clear {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((UIColor) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _MultipleColor = ABindableToMultipleColor
@propertyWrapper open
class ABindableToMultipleColor: NSObject {
    private var bindKeys: [String]
    private var executeBlock: ((UIColor) -> Void)?
    @objc dynamic public
    var wrappedValue: UIColor = .clear {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindTo(bindKey: currentBindKey, attribute: #keyPath(wrappedValue))
        }
    }
    
    public func change(_ block: ((UIColor) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _Color_ = ABindableColor
@propertyWrapper open
class ABindableColor: NSObject {
    private let bindKey: String
    private var executeBlock: ((UIColor) -> Void)?
    @objc dynamic public
    var wrappedValue: UIColor = .clear {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        self.bindFrom(bindKey: bindKey, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((UIColor) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias AB_Color = ABindableFromToColor
@propertyWrapper open
class ABindableFromToColor: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((UIColor) -> Void)?
    @objc dynamic public
    var wrappedValue: UIColor = .clear {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey1: String, _ bindKey2: String) {
        self.bindKeys = [bindKey1, bindKey2]
        super.init()
        
        self.bindFrom(bindKey: bindKey1, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey2, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((UIColor) -> Void)?) {
        self.executeBlock = block
    }
}
//MARK: Date
public typealias Date_ = ABindableFromDate
@propertyWrapper open
class ABindableFromDate: NSObject {
    private let bindKey: String
    @objc dynamic public
    var attribute: Date?
    
    public var wrappedValue: Date {
        get {
            return attribute!
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindFrom(bindKey: bindKey, attribute: #keyPath(attribute))
    }
}
public typealias MultipleDate_ = ABindableFromMultipleDate
@propertyWrapper open
class ABindableFromMultipleDate: NSObject {
    private var bindKeys: [String]
    @objc dynamic public
    var attribute: Date?
    
    public var wrappedValue: Date? {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindFrom(bindKey: currentBindKey, attribute: #keyPath(attribute))
        }
    }
}
public typealias _Date = ABindableToDate
@propertyWrapper open
class ABindableToDate: NSObject {
    private let bindKey: String
    private var executeBlock: ((Date) -> Void)?
    @objc dynamic public
    var wrappedValue: Date? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Date) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _MultipleDate = ABindableToMultipleDate
@propertyWrapper open
class ABindableToMultipleDate: NSObject {
    private var bindKeys: [String]
    private var executeBlock: ((Date) -> Void)?
    @objc dynamic public
    var wrappedValue: Date? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindTo(bindKey: currentBindKey, attribute: #keyPath(wrappedValue))
        }
    }
    
    public func change(_ block: ((Date) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _Date_ = ABindableDate
@propertyWrapper open
class ABindableDate: NSObject {
    private let bindKey: String
    private var executeBlock: ((Date) -> Void)?
    @objc dynamic public
    var wrappedValue: Date? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        self.bindFrom(bindKey: bindKey, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Date) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias AB_Date = ABindableFromToDate
@propertyWrapper open
class ABindableFromToDate: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((Date) -> Void)?
    @objc dynamic public
    var wrappedValue: Date? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey1: String, _ bindKey2: String) {
        self.bindKeys = [bindKey1, bindKey2]
        super.init()
        
        self.bindFrom(bindKey: bindKey1, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey2, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Date) -> Void)?) {
        self.executeBlock = block
    }
}

//MARK: Array
public typealias Array_ = ABindableFromArray
@propertyWrapper open
class ABindableFromArray: NSObject {
    private let bindKey: String
    @objc dynamic public
    var attribute: Array<Any>?
    
    public var wrappedValue: Array<Any> {
        get {
            return attribute!
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindFrom(bindKey: bindKey, attribute: #keyPath(attribute))
    }
}
public typealias MultipleArray_ = ABindableFromMultipleArray
@propertyWrapper open
class ABindableFromMultipleArray: NSObject {
    private let bindKeys: [String]
    @objc dynamic public
    var attribute: Array<Any>?
    
    public var wrappedValue: Array<Any>? {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindFrom(bindKey: currentBindKey, attribute: #keyPath(attribute))
        }
    }
}
public typealias _Array = ABindableToArray
@propertyWrapper open
class ABindableToArray: NSObject {
    private let bindKey: String
    private var executeBlock: ((Array<Any>) -> Void)?
    @objc dynamic public
    var wrappedValue: Array<Any>? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Array<Any>) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _MultipleArray = ABindableToMultipleArray
@propertyWrapper open
class ABindableToMultipleArray: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((Array<Any>) -> Void)?
    @objc dynamic public
    var wrappedValue: Array<Any>? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindTo(bindKey: currentBindKey, attribute: #keyPath(wrappedValue))
        }
    }
    
    public func change(_ block: ((Array<Any>) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _Array_ = ABindableArray
@propertyWrapper open
class ABindableArray: NSObject {
    private let bindKey: String
    private var executeBlock: ((Array<Any>) -> Void)?
    @objc dynamic public
    var wrappedValue: Array<Any>? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        self.bindFrom(bindKey: bindKey, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Array<Any>) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias AB_Array = ABindableFromToArray
@propertyWrapper open
class ABindableFromToArray: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((Array<Any>) -> Void)?
    @objc dynamic public
    var wrappedValue: Array<Any>? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey1: String, _ bindKey2: String) {
        self.bindKeys = [bindKey1, bindKey2]
        super.init()
        
        self.bindFrom(bindKey: bindKey1, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey2, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Array<Any>) -> Void)?) {
        self.executeBlock = block
    }
}

//MARK: Dictionary
public typealias Dictionary_ = ABindableFromDictionary
@propertyWrapper open
class ABindableFromDictionary: NSObject {
    private let bindKey: String
    @objc dynamic public
    var attribute: Dictionary<String, Any>?
    
    public var wrappedValue: Dictionary<String, Any> {
        get {
            return attribute!
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindFrom(bindKey: bindKey, attribute: #keyPath(attribute))
    }
}
public typealias MultipleDictionary_ = ABindableFromMultipleDictionary
@propertyWrapper open
class ABindableFromMultipleDictionary: NSObject {
    private let bindKeys: [String]
    @objc dynamic public
    var attribute: Dictionary<String, Any>?
    
    public var wrappedValue: Dictionary<String, Any>? {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindFrom(bindKey: currentBindKey, attribute: #keyPath(attribute))
        }
    }
}
public typealias _Dictionary = ABindableToDictionary
@propertyWrapper open
class ABindableToDictionary: NSObject {
    private let bindKey: String
    private var executeBlock: ((Dictionary<String, Any>) -> Void)?
    @objc dynamic public
    var wrappedValue: Dictionary<String, Any>? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Dictionary<String, Any>) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _MultipleDictionary = ABindableToMultipleDictionary
@propertyWrapper open
class ABindableToMultipleDictionary: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((Dictionary<String, Any>) -> Void)?
    @objc dynamic public
    var wrappedValue: Dictionary<String, Any>? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindTo(bindKey: currentBindKey, attribute: #keyPath(wrappedValue))
        }
    }
    
    public func change(_ block: ((Dictionary<String, Any>) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _Dictionary_ = ABindableDictionary
@propertyWrapper open
class ABindableDictionary: NSObject {
    private let bindKey: String
    private var executeBlock: ((Dictionary<String, Any>) -> Void)?
    @objc dynamic public
    var wrappedValue: Dictionary<String, Any>? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        self.bindFrom(bindKey: bindKey, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Dictionary<String, Any>) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias AB_Dictionary = ABindableFromToDictionary
@propertyWrapper open
class ABindableFromToDictionary: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((Dictionary<String, Any>) -> Void)?
    @objc dynamic public
    var wrappedValue: Dictionary<String, Any>? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey1: String, _ bindKey2: String) {
        self.bindKeys = [bindKey1, bindKey2]
        super.init()
        
        self.bindFrom(bindKey: bindKey1, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey2, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Dictionary<String, Any>) -> Void)?) {
        self.executeBlock = block
    }
}

//MARK: Image
public typealias Image_ = ABindableFromImage
@propertyWrapper open
class ABindableFromImage: NSObject {
    private let bindKey: String
    @objc dynamic public
    var attribute: UIImage?
    
    public var wrappedValue: UIImage? {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindFrom(bindKey: bindKey, attribute: #keyPath(attribute))
    }
}
public typealias MultipleImage_ = ABindableFromMultipleImage
@propertyWrapper open
class ABindableFromMultipleImage: NSObject {
    private let bindKeys: [String]
    @objc dynamic public
    var attribute: UIImage?
    
    public var wrappedValue: UIImage? {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindFrom(bindKey: currentBindKey, attribute: #keyPath(attribute))
        }
    }
}
public typealias _Image = ABindableToImage
@propertyWrapper open
class ABindableToImage: NSObject {
    private let bindKey: String
    private var executeBlock: ((UIImage) -> Void)?
    @objc dynamic public
    var wrappedValue: UIImage? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((UIImage) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _MultipleImage = ABindableToMultipleImage
@propertyWrapper open
class ABindableToMultipleImage: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((UIImage) -> Void)?
    @objc dynamic public
    var wrappedValue: UIImage? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindTo(bindKey: currentBindKey, attribute: #keyPath(wrappedValue))
        }
    }
    
    public func change(_ block: ((UIImage) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _Image_ = ABindableImage
@propertyWrapper open
class ABindableImage: NSObject {
    private let bindKey: String
    private var executeBlock: ((UIImage) -> Void)?
    @objc dynamic public
    var wrappedValue: UIImage? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        self.bindFrom(bindKey: bindKey, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((UIImage) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias AB_Image = ABindableFromToImage
@propertyWrapper open
class ABindableFromToImage: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((UIImage) -> Void)?
    @objc dynamic public
    var wrappedValue: UIImage? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey1: String, _ bindKey2: String) {
        self.bindKeys = [bindKey1, bindKey2]
        super.init()
        
        self.bindFrom(bindKey: bindKey1, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey2, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((UIImage) -> Void)?) {
        self.executeBlock = block
    }
}
//MARK: Any
public typealias Any_ = ABindableFromAny
@propertyWrapper open
class ABindableFromAny: NSObject {
    private let bindKey: String
    @objc dynamic public
    var attribute: Any?
    
    public var wrappedValue: Any? {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindFrom(bindKey: bindKey, attribute: #keyPath(attribute))
    }
}
public typealias MultipleAny_ = ABindableFromMultipleAny
@propertyWrapper open
class ABindableFromMultipleAny: NSObject {
    private let bindKeys: [String]
    @objc dynamic public
    var attribute: Any?
    
    public var wrappedValue: Any? {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindFrom(bindKey: currentBindKey, attribute: #keyPath(attribute))
        }
    }
}
public typealias _Any = ABindableToAny
@propertyWrapper open
class ABindableToAny: NSObject {
    private let bindKey: String
    private var executeBlock: ((Any) -> Void)?
    @objc dynamic public
    var wrappedValue: Any? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Any) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _MultipleAny = ABindableToMultipleAny
@propertyWrapper open
class ABindableToMultipleAny: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((Any) -> Void)?
    @objc dynamic public
    var wrappedValue: Any? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindTo(bindKey: currentBindKey, attribute: #keyPath(wrappedValue))
        }
    }
    
    public func change(_ block: ((Any) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _Any_ = ABindableAny
@propertyWrapper open
class ABindableAny: NSObject {
    private let bindKey: String
    private var executeBlock: ((Any) -> Void)?
    @objc dynamic public
    var wrappedValue: Any? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        self.bindFrom(bindKey: bindKey, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Any) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias AB_Any = ABindableFromToAny
@propertyWrapper open
class ABindableFromToAny: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((Any) -> Void)?
    @objc dynamic public
    var wrappedValue: Any? {
        willSet {
            executeBlock!(newValue!)
        }
    }
    
    public init(_ bindKey1: String, _ bindKey2: String) {
        self.bindKeys = [bindKey1, bindKey2]
        super.init()
        
        self.bindFrom(bindKey: bindKey1, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey2, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((Any) -> Void)?) {
        self.executeBlock = block
    }
}
//MARK: CGFloat
public typealias CGFloat_ = ABindableFromCGFloat
@propertyWrapper open
class ABindableFromCGFloat: NSObject {
    private let bindKey: String
    @objc dynamic public
    var attribute: CGFloat = 0.0
    
    public var wrappedValue: CGFloat {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindFrom(bindKey: bindKey, attribute: #keyPath(attribute))
    }
}
public typealias MultipleCGFloat_ = ABindableFromMultipleCGFloat
@propertyWrapper open
class ABindableFromMultipleCGFloat: NSObject {
    private let bindKeys: [String]
    @objc dynamic public
    var attribute: CGFloat = 0.0
    
    public var wrappedValue: CGFloat {
        get {
            return attribute
        }
        set {
            attribute  = newValue
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindFrom(bindKey: currentBindKey, attribute: #keyPath(attribute))
        }
    }
}
public typealias _CGFloat = ABindableToCGFloat
@propertyWrapper open
class ABindableToCGFloat: NSObject {
    private let bindKey: String
    private var executeBlock: ((CGFloat) -> Void)?
    @objc dynamic public
    var wrappedValue: CGFloat = 0.0 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((CGFloat) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _MultipleCGFloat = ABindableToMultipleCGFloat
@propertyWrapper open
class ABindableToMultipleCGFloat: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((CGFloat) -> Void)?
    @objc dynamic public
    var wrappedValue: CGFloat = 0.0 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKeys: String...) {
        self.bindKeys = bindKeys
        super.init()
        
        for currentBindKey in bindKeys {
            bindTo(bindKey: currentBindKey, attribute: #keyPath(wrappedValue))
        }
    }
    
    public func change(_ block: ((CGFloat) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias _CGFloat_ = ABindableCGFloat
@propertyWrapper open
class ABindableCGFloat: NSObject {
    private let bindKey: String
    private var executeBlock: ((CGFloat) -> Void)?
    @objc dynamic public
    var wrappedValue: CGFloat = 0.0 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey: String) {
        self.bindKey = bindKey
        super.init()
        
        self.bindFrom(bindKey: bindKey, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((CGFloat) -> Void)?) {
        self.executeBlock = block
    }
}
public typealias AB_CGFloat = ABindableFromToCGFloat
@propertyWrapper open
class ABindableFromToCGFloat: NSObject {
    private let bindKeys: [String]
    private var executeBlock: ((CGFloat) -> Void)?
    @objc dynamic public
    var wrappedValue: CGFloat = 0.0 {
        willSet {
            executeBlock!(newValue)
        }
    }
    
    public init(_ bindKey1: String, _ bindKey2: String) {
        self.bindKeys = [bindKey1, bindKey2]
        super.init()
        
        self.bindFrom(bindKey: bindKey1, attribute: #keyPath(wrappedValue))
        self.bindTo(bindKey: bindKey2, attribute: #keyPath(wrappedValue))
    }
    
    public func change(_ block: ((CGFloat) -> Void)?) {
        self.executeBlock = block
    }
}
