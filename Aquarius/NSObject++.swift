//
//  NSObject++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/8/12.
//

import UIKit
import Foundation

extension NSObject {
    private struct NSObjectData {
        static var key: String?
    }
    
    public var kNotificationUpdateTheme: String {
        get {
            return "notification_updateTime"
        }
    }
    
    public var key: String? {
        get {
            return NSObjectData.key
        }
        set {
            NSObjectData.key = newValue
        }
    }
    
    //将类的实例中带"."的去掉，然后返回
    public func keyPathString(_ string: String) -> String {
        let lastIndex: Int = string.findLast(".")
        if lastIndex != -1 {
            return string.substring(from: lastIndex+1)
        } else {
            return string
        }
    }
    
    public func setValue(_ dict: Dictionary<String, Any>) {
        for (dictKey, dictValue) in dict {
            setValue(dictValue, forKey: dictKey)
        }
    }
    /*
    public func print<N>(message: N) {
        #if DEBUG
        print(message)
        #endif
    }
     */
    private func getMemoryAddress(object: AnyObject) -> String {
        let str = Unmanaged<AnyObject>.passUnretained(object).toOpaque()
        return String(describing: str)
    }
    
    public func isEqualObject(_ object: AnyObject) -> Bool {
        let str1 = getMemoryAddress(object: self)
        let str2 = getMemoryAddress(object: object)
        
        return str1 == str2 ? true : false
    }
}
//MARK: - Bind
extension NSObject {
    private struct NSObjectData2 {
        static var keys: Array<String> = Array()
        static let jzxsBind: ABind = ABind.shared
    }
    
    public var o_bind: ABind {
        get {
            return NSObjectData2.jzxsBind
        }
    }
    
    public var o_bindKeys: Array<String> {
        get {
            return NSObjectData2.keys
        }
        
        set {
            NSObjectData2.keys = newValue
        }
    }

    public func clearBind() {
        self.o_bind.removeBindForKeys(bindKeys: self.o_bindKeys)
    }
    
    public func clearBind(bindKey: String) {
        self.o_bind.removeBindForKey(bindKey: bindKey)
    }
    
    public func clearBind(object: Any) {
        self.o_bind.removeBindForObject(object: object)
    }
    
    public func clearBinds(objects: [Any]) {
        for currentObject: Any in objects {
            clearBind(object: currentObject)
        }
    }
    
    public func clearBinds(bindKeys: Array<String>) {
        for currentBindKey: String in bindKeys {
            clearBind(bindKey: currentBindKey)
        }
    }
    
    public func bindFrom(bindKey: String, attribute: String) {
        self.o_bind.bindObject(bindKey: bindKey, object: self, bindAttribute: attribute, bindType: .From)
        
        if !self.checkBindKeys(key: bindKey) {
            self.o_bindKeys.append(bindKey)
        }
    }
    
    @discardableResult public
    func bindsFrom(dict: Dictionary<String, String>) -> Array<String> {
        var array: Array<String> = []
        let keys = dict.keys
        for currentKey in keys {
            let key: String = currentKey
            array.append(key)
            let attribute: String = dict[currentKey]!
            bindFrom(bindKey: key, attribute: attribute)
        }
        
        return array
    }
    
    public func bindTo(bindKey: String, attribute: String) {
        self.o_bind.bindObject(bindKey: bindKey, object: self, bindAttribute: attribute, bindType: .To)
        
        if !self.checkBindKeys(key: bindKey) {
            self.o_bindKeys.append(bindKey)
        }
    }
    
    @discardableResult public
    func bindsTo(dict: Dictionary<String, String>) -> Array<String> {
        var array: Array<String> = []
        let keys = dict.keys
        for currentKey in keys {
            let key: String = currentKey
            array.append(key)
            let attribute: String = dict[currentKey]!
            bindTo(bindKey: key, attribute: attribute)
        }
        
        return array
    }
    
    public func bind(bindKey: String, attribute: String) {
        self.o_bind.bindObject(bindKey: bindKey, object: self, bindAttribute: attribute, bindType: .All)
        
        if !self.checkBindKeys(key: bindKey) {
            self.o_bindKeys.append(bindKey)
        }
    }
    
    @discardableResult public
    func binds(dict: Dictionary<String, String>) -> Array<String> {
        var array: Array<String> = []
        let keys = dict.keys
        for currentKey in keys {
            let key: String = currentKey
            array.append(key)
            let attribute: String = dict[currentKey]!
            bind(bindKey: key, attribute: attribute)
        }
        
        return array
    }
    
    public func bindAttribute(attribute: String, executeBlock: ((Any) -> Void)? = nil) {
        o_bind.bindAttribute(object: self, bindAttribute: attribute, executeBlock: executeBlock)
    }
    
    public func removeBindAttribute(attribute: String) {
        o_bind.removeBindAttribute(object: self, attribute: attribute)
    }
    
    public func removeBindAttributes(attributes: Array<String>) {
        var array: Array<Dictionary<String, AnyObject>> = Array()
        for attribute: String in attributes {
            array.append([attribute : self])
        }
        o_bind.removeBindAttributes(attributes: array)
    }
    
    public func bindUI(bindKey: String, ui:AnyObject, attribute: String, bindType: BindType = .All) {
        self.o_bind.bindObject(bindKey: bindKey, object: ui, bindAttribute: attribute, bindType: bindType)
        
        if !self.checkBindKeys(key: bindKey) {
            self.o_bindKeys.append(bindKey)
        }
    }
    
    internal func checkBindKeys(key: String) -> Bool {
        var result: Bool = false
        for keyFromArray: String in self.o_bindKeys {
            if key == keyFromArray {
                result = true
                break
            }
        }
        
        return result
    }
}
//MARK: - BindUI
extension NSObject {
    private func bindUIBase(bindKey: BindType, attribute: String, bindType: BindType = .All) -> Dictionary<String, BindType> {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        
        var bindUIType: BindType
        
        switch bindType {
        case .All:
            bindUIType = .All
            
            bind(bindKey: bindKey, attribute: attribute)
            break
        case .From:
            bindUIType = .From
            
            bindTo(bindKey: bindKey, attribute: attribute)
            break
        case .To:
            bindUIType = .To
            
            bindFrom(bindKey: bindKey, attribute: attribute)
            break
        }
        
        return [bindKey : bindUIType]
    }
    //MARK: - UControl
    public func bindEnabled(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isEnabled", bindType: bindType)
    }
    
    public func bindEnabled(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindEnabled(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindEnabled(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindEnabled(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindEnabled(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindEnabled(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSelected(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isSelected", bindType: bindType)
    }
    
    public func bindSelected(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSelected(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSelected(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSelected(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSelected(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSelected(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindHighlighted(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isHighlighted", bindType: bindType)
    }
    
    public func bindHighlighted(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindHighlighted(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindHighlighted(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindHighlighted(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindHighlighted(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindHighlighted(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindContentVerticalAlignment(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "contentVerticalAlignment", bindType: bindType)
    }
    
    public func bindContentVerticalAlignment(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindContentVerticalAlignment(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindContentVerticalAlignment(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindContentVerticalAlignment(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindContentVerticalAlignment(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindContentVerticalAlignment(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindContentHorizontalAlignment(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "contentHorizontalAlignment", bindType: bindType)
    }
    
    public func bindContentHorizontalAlignment(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindContentHorizontalAlignment(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindContentHorizontalAlignment(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindContentHorizontalAlignment(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindContentHorizontalAlignment(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindContentHorizontalAlignment(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindToolTip(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "toolTip", bindType: bindType)
    }
    
    public func bindToolTip(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindToolTip(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindToolTip(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindToolTip(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindToolTip(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindToolTip(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    //MARK: -  UIView
    public func bindBackgroundColor(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "backgroundColor", bindType: bindType)
    }
    
    public func bindBackgroundColor(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindBackgroundColor(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindBackgroundColor(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindBackgroundColor(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindBackgroundColor(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindBackgroundColor(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAlpha(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "alpha", bindType: bindType)
    }
    
    public func bindAlpha(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAlpha(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAlpha(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAlpha(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAlpha(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAlpha(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindOpaque(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isOpaque", bindType: bindType)
    }
    
    public func bindOpaque(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindOpaque(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindOpaque(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindOpaque(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindOpaque(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindOpaque(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindTintColor(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "tintColor", bindType: bindType)
    }
    
    public func bindTintColor(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindTintColor(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindTintColor(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindTintColor(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindTintColor(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindTintColor(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindTintAdjustmentMode(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "tintAdjustmentMode", bindType: bindType)
    }
    
    public func bindTintAdjustmentMode(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindTintAdjustmentMode(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindTintAdjustmentMode(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindTintAdjustmentMode(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindTintAdjustmentMode(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindTintAdjustmentMode(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindClipsToBounds(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "clipsToBounds", bindType: bindType)
    }
    
    public func bindClipsToBounds(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindClipsToBounds(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindClipsToBounds(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindClipsToBounds(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindClipsToBounds(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindClipsToBounds(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindUserInteractionEnabled(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isUserInteractionEnabled", bindType: bindType)
    }
    
    public func bindUserInteractionEnabled(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindUserInteractionEnabled(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindUserInteractionEnabled(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindUserInteractionEnabled(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindUserInteractionEnabled(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindUserInteractionEnabled(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindFrame(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "frame", bindType: bindType)
    }
    
    public func bindFrame(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindFrame(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindFrame(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindFrame(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindFrame(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindFrame(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindBounds(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "bounds", bindType: bindType)
    }
    
    public func bindBounds(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindBounds(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindBounds(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindBounds(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindBounds(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindBounds(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindCenter(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "center", bindType: bindType)
    }
    
    public func bindCenter(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindCenter(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindCenter(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindCenter(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindCenter(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindCenter(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindTransform(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "transform", bindType: bindType)
    }
    
    public func bindTransform(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindTransform(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindTransform(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindTransform(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindTransform(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindTransform(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindLayoutMargins(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "layoutMargins", bindType: bindType)
    }
    
    public func bindLayoutMargins(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindLayoutMargins(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindLayoutMargins(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindLayoutMargins(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindLayoutMargins(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindLayoutMargins(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindContentMode(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "contentMode", bindType: bindType)
    }
    
    public func bindContentMode(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindContentMode(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindContentMode(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindContentMode(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindContentMode(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindContentMode(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindTag(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "tag", bindType: bindType)
    }
    
    public func bindTag(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindTag(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindTag(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindTag(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindTag(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindTag(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    //MARK: -  UITextField
    /* available */
    public func bindText(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "text", bindType: bindType)
    }
    
    public func bindText(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindText(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindText(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindText(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindText(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindText(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    /* available */
    public func bindAttributedText(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "attributedText", bindType: bindType)
    }
    
    public func bindAttributedText(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAttributedText(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAttributedText(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAttributedText(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAttributedText(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAttributedText(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    /* available */
    public func bindPlaceholder(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "placeholder", bindType: bindType)
    }
    
    public func bindPlaceholder(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindPlaceholder(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindPlaceholder(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindPlaceholder(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindPlaceholder(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindPlaceholder(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    /* available */
    public func bindAttributedPlaceholder(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "attributedPlaceholder", bindType: bindType)
    }
    
    public func bindAttributedPlaceholder(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAttributedPlaceholder(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAttributedPlaceholder(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAttributedPlaceholder(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAttributedPlaceholder(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAttributedPlaceholder(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    /* available */
    public func bindFont(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "font", bindType: bindType)
    }
    
    public func bindFont(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindFont(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindFont(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindFont(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindFont(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindFont(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    /* available */
    public func bindTextColor(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "textColor", bindType: bindType)
    }
    
    public func bindTextColor(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindTextColor(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindTextColor(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindTextColor(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindTextColor(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindTextColor(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    /* available */
    public func bindTextAlignment(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "textAlignment", bindType: bindType)
    }
    
    public func bindTextAlignment(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindTextAlignment(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindTextAlignment(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindTextAlignment(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindTextAlignment(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindTextAlignment(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  UILabel
    public func bindShadowColor(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "shadowColor", bindType: bindType)
    }
    
    public func bindShadowColor(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindShadowColor(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindShadowColor(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindShadowColor(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindShadowColor(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindShadowColor(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  UIImageView
    public func bindImage(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "image", bindType: bindType)
    }
    
    public func bindImage(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindImage(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindImage(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindImage(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindImage(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindImage(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindHighlightedImage(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "highlightedImage", bindType: bindType)
    }
    
    public func bindHighlightedImage(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindHighlightedImage(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindHighlightedImage(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindHighlightedImage(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindHighlightedImage(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindHighlightedImage(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  componentscrollView
    public func bindContentSize(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "contentSize", bindType: bindType)
    }
    
    public func bindContentSize(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindContentSize(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindContentSize(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindContentSize(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindContentSize(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindContentSize(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindContentOffset(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "contentOffset", bindType: bindType)
    }
    
    public func bindContentOffset(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindContentOffset(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindContentOffset(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindContentOffset(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindContentOffset(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindContentOffset(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindContentInset(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "contentInset", bindType: bindType)
    }
    
    public func bindContentInset(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindContentInset(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindContentInset(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindContentInset(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindContentInset(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindContentInset(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindScrollEnabled(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isScrollEnabled", bindType: bindType)
    }
    
    public func bindScrollEnabled(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindScrollEnabled(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindScrollEnabled(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindScrollEnabled(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindScrollEnabled(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindScrollEnabled(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindPagingEnabled(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isPagingEnabled", bindType: bindType)
    }
    
    public func bindPagingEnabled(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindPagingEnabled(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindPagingEnabled(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindPagingEnabled(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindPagingEnabled(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindPagingEnabled(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindBounces(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "bounces", bindType: bindType)
    }
    
    public func bindBounces(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindBounces(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindBounces(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindBounces(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindBounces(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindBounces(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAlwaysBounceVertical(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "alwaysBounceVertical", bindType: bindType)
    }
    
    public func bindAlwaysBounceVertical(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAlwaysBounceVertical(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAlwaysBounceVertical(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAlwaysBounceVertical(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAlwaysBounceVertical(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAlwaysBounceVertical(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAlwaysBounceHorizontal(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "alwaysBounceHorizontal", bindType: bindType)
    }
    
    public func bindAlwaysBounceHorizontal(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAlwaysBounceHorizontal(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAlwaysBounceHorizontal(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAlwaysBounceHorizontal(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAlwaysBounceHorizontal(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAlwaysBounceHorizontal(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindShowsHorizontalScrollIndicator(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "showsHorizontalScrollIndicator", bindType: bindType)
    }
    
    public func bindShowsHorizontalScrollIndicator(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindShowsHorizontalScrollIndicator(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindShowsHorizontalScrollIndicator(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindShowsHorizontalScrollIndicator(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindShowsHorizontalScrollIndicator(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindShowsHorizontalScrollIndicator(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindShowsVerticalScrollIndicator(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "showsVerticalScrollIndicator", bindType: bindType)
    }
    
    public func bindShowsVerticalScrollIndicator(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindShowsVerticalScrollIndicator(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindShowsVerticalScrollIndicator(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindShowsVerticalScrollIndicator(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindShowsVerticalScrollIndicator(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindShowsVerticalScrollIndicator(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindZoomScale(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "zoomScale", bindType: bindType)
    }
    
    public func bindZoomScale(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindZoomScale(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindZoomScale(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindZoomScale(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindZoomScale(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindZoomScale(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindMaximumZoomScale(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "maximumZoomScale", bindType: bindType)
    }
    
    public func bindMaximumZoomScale(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindMaximumZoomScale(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindMaximumZoomScale(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindMaximumZoomScale(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindMaximumZoomScale(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindMaximumZoomScale(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindMinimumZoomScale(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "minimumZoomScale", bindType: bindType)
    }
    
    public func bindMinimumZoomScale(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindMinimumZoomScale(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindMinimumZoomScale(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindMinimumZoomScale(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindMinimumZoomScale(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindMinimumZoomScale(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindBouncesZoom(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "bouncesZoom", bindType: bindType)
    }
    
    public func bindBouncesZoom(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindBouncesZoom(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindBouncesZoom(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindBouncesZoom(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindBouncesZoom(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindBouncesZoom(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  UITableView
    public func bindTableHeaderView(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "tableHeaderView", bindType: bindType)
    }
    
    public func bindTableHeaderView(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindTableHeaderView(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindTableHeaderView(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindTableHeaderView(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindTableHeaderView(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindTableHeaderView(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindTableFooterView(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "tableFooterView", bindType: bindType)
    }
    
    public func bindTableFooterView(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindTableFooterView(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindTableFooterView(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindTableFooterView(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindTableFooterView(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindTableFooterView(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindBackgroundView(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "backgroundView", bindType: bindType)
    }
    
    public func bindBackgroundView(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindBackgroundView(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindBackgroundView(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindBackgroundView(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindBackgroundView(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindBackgroundView(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindRowHeight(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "rowHeight", bindType: bindType)
    }
    
    public func bindRowHeight(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindRowHeight(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindRowHeight(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindRowHeight(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindRowHeight(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindRowHeight(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindEstimatedRowHeight(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "estimatedRowHeight", bindType: bindType)
    }
    
    public func bindEstimatedRowHeight(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindEstimatedRowHeight(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindEstimatedRowHeight(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindEstimatedRowHeight(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindEstimatedRowHeight(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindEstimatedRowHeight(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSectionHeaderHeight(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "sectionHeaderHeight", bindType: bindType)
    }
    
    public func bindSectionHeaderHeight(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSectionHeaderHeight(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSectionHeaderHeight(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSectionHeaderHeight(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSectionHeaderHeight(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSectionHeaderHeight(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSectionFooterHeight(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "sectionFooterHeight", bindType: bindType)
    }
    
    public func bindSectionFooterHeight(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSectionFooterHeight(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSectionFooterHeight(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSectionFooterHeight(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSectionFooterHeight(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSectionFooterHeight(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindEstimatedSectionHeaderHeight(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "estimatedSectionHeaderHeight", bindType: bindType)
    }
    
    public func bindEstimatedSectionHeaderHeight(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindEstimatedSectionHeaderHeight(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindEstimatedSectionHeaderHeight(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindEstimatedSectionHeaderHeight(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindEstimatedSectionHeaderHeight(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindEstimatedSectionHeaderHeight(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindEstimatedSectionFooterHeight(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "estimatedSectionFooterHeight", bindType: bindType)
    }
    
    public func bindEstimatedSectionFooterHeight(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindEstimatedSectionFooterHeight(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindEstimatedSectionFooterHeight(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindEstimatedSectionFooterHeight(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindEstimatedSectionFooterHeight(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindEstimatedSectionFooterHeight(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSeparatorStyle(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "separatorStyle", bindType: bindType)
    }
    
    public func bindSeparatorStyle(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSeparatorStyle(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSeparatorStyle(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSeparatorStyle(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSeparatorStyle(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSeparatorStyle(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSeparatorColor(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "separatorColor", bindType: bindType)
    }
    
    public func bindSeparatorColor(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSeparatorColor(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSeparatorColor(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSeparatorColor(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSeparatorColor(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSeparatorColor(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSeparatorEffect(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "separatorEffect", bindType: bindType)
    }
    
    public func bindSeparatorEffect(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSeparatorEffect(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSeparatorEffect(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSeparatorEffect(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSeparatorEffect(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSeparatorEffect(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSeparatorInset(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "separatorInset", bindType: bindType)
    }
    
    public func bindSeparatorInset(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSeparatorInset(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSeparatorInset(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSeparatorInset(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSeparatorInset(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSeparatorInset(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAllowsSelection(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "allowsSelection", bindType: bindType)
    }
    
    public func bindAllowsSelection(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAllowsSelection(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAllowsSelection(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAllowsSelection(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAllowsSelection(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAllowsSelection(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAllowsMultipleSelection(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "allowsMultipleSelection", bindType: bindType)
    }
    
    public func bindAllowsMultipleSelection(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAllowsMultipleSelection(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAllowsMultipleSelection(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAllowsMultipleSelection(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAllowsMultipleSelection(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAllowsMultipleSelection(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAllowsSelectionDuringEditing(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "allowsSelectionDuringEditing", bindType: bindType)
    }
    
    public func bindAllowsSelectionDuringEditing(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAllowsSelectionDuringEditing(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAllowsSelectionDuringEditing(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAllowsSelectionDuringEditing(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAllowsSelectionDuringEditing(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAllowsSelectionDuringEditing(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAllowsMultipleSelectionDuringEditing(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "allowsMultipleSelectionDuringEditing", bindType: bindType)
    }
    
    public func bindAllowsMultipleSelectionDuringEditing(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAllowsMultipleSelectionDuringEditing(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAllowsMultipleSelectionDuringEditing(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAllowsMultipleSelectionDuringEditing(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAllowsMultipleSelectionDuringEditing(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAllowsMultipleSelectionDuringEditing(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindDragInteractionEnabled(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "dragInteractionEnabled", bindType: bindType)
    }
    
    public func bindDragInteractionEnabled(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindDragInteractionEnabled(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindDragInteractionEnabled(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindDragInteractionEnabled(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindDragInteractionEnabled(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindDragInteractionEnabled(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindEditing(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isEditing", bindType: bindType)
    }
    
    public func bindEditing(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindEditing(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindEditing(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindEditing(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindEditing(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindEditing(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSectionIndexMinimumDisplayRowCount(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "sectionIndexMinimumDisplayRowCount", bindType: bindType)
    }
    
    public func bindSectionIndexMinimumDisplayRowCount(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSectionIndexMinimumDisplayRowCount(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSectionIndexMinimumDisplayRowCount(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSectionIndexMinimumDisplayRowCount(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSectionIndexMinimumDisplayRowCount(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSectionIndexMinimumDisplayRowCount(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSectionIndexColor(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "sectionIndexColor", bindType: bindType)
    }
    
    public func bindSectionIndexColor(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSectionIndexColor(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSectionIndexColor(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSectionIndexColor(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSectionIndexColor(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSectionIndexColor(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSectionIndexBackgroundColor(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "sectionIndexBackgroundColor", bindType: bindType)
    }
    
    public func bindSectionIndexBackgroundColor(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSectionIndexBackgroundColor(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSectionIndexBackgroundColor(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSectionIndexBackgroundColor(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSectionIndexBackgroundColor(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSectionIndexBackgroundColor(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSectionIndexTrackingBackgroundColor(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "sectionIndexTrackingBackgroundColor", bindType: bindType)
    }
    
    public func bindSectionIndexTrackingBackgroundColor(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSectionIndexTrackingBackgroundColor(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSectionIndexTrackingBackgroundColor(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSectionIndexTrackingBackgroundColor(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSectionIndexTrackingBackgroundColor(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSectionIndexTrackingBackgroundColor(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  UITableViewCell
    public func bindSelectedBackgroundView(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "selectedBackgroundView", bindType: bindType)
    }
    
    public func bindSelectedBackgroundView(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSelectedBackgroundView(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSelectedBackgroundView(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSelectedBackgroundView(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSelectedBackgroundView(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSelectedBackgroundView(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindMultipleSelectionBackgroundView(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "multipleSelectionBackgroundView", bindType: bindType)
    }
    
    public func bindMultipleSelectionBackgroundView(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindMultipleSelectionBackgroundView(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindMultipleSelectionBackgroundView(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindMultipleSelectionBackgroundView(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindMultipleSelectionBackgroundView(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindMultipleSelectionBackgroundView(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAccessoryType(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "accessoryType", bindType: bindType)
    }
    
    public func bindAccessoryType(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAccessoryType(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAccessoryType(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAccessoryType(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAccessoryType(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAccessoryType(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAccessoryView(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "accessoryView", bindType: bindType)
    }
    
    public func bindAccessoryView(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAccessoryView(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAccessoryView(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAccessoryView(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAccessoryView(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAccessoryView(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindEditingAccessoryType(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "editingAccessoryType", bindType: bindType)
    }
    
    public func bindEditingAccessoryType(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindEditingAccessoryType(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindEditingAccessoryType(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindEditingAccessoryType(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindEditingAccessoryType(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindEditingAccessoryType(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindEditingAccessoryView(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "editingAccessoryView", bindType: bindType)
    }
    
    public func bindEditingAccessoryView(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindEditingAccessoryView(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindEditingAccessoryView(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindEditingAccessoryView(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindEditingAccessoryView(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindEditingAccessoryView(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSelectionStyle(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "selectionStyle", bindType: bindType)
    }
    
    public func bindSelectionStyle(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSelectionStyle(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSelectionStyle(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSelectionStyle(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSelectionStyle(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSelectionStyle(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindUserInteractionEnabledWhileDragging(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "userInteractionEnabledWhileDragging", bindType: bindType)
    }
    
    public func bindUserInteractionEnabledWhileDragging(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindUserInteractionEnabledWhileDragging(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindUserInteractionEnabledWhileDragging(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindUserInteractionEnabledWhileDragging(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindUserInteractionEnabledWhileDragging(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindUserInteractionEnabledWhileDragging(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindFocusStyle(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "focusStyle", bindType: bindType)
    }
    
    public func bindFocusStyle(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindFocusStyle(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindFocusStyle(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindFocusStyle(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindFocusStyle(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindFocusStyle(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  UIViewController
    public func bindView(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "view", bindType: bindType)
    }
    
    public func bindView(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindView(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindView(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindView(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindView(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindView(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindTitle(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "title", bindType: bindType)
    }
    
    public func bindTitle(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindTitle(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindTitle(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindTitle(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindTitle(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindTitle(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindPreferredContentSize(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "preferredContentSize", bindType: bindType)
    }
    
    public func bindPreferredContentSize(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindPreferredContentSize(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindPreferredContentSize(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindPreferredContentSize(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindPreferredContentSize(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindPreferredContentSize(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindHidesBottomBarWhenPushed(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "hidesBottomBarWhenPushed", bindType: bindType)
    }
    
    public func bindHidesBottomBarWhenPushed(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindHidesBottomBarWhenPushed(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindHidesBottomBarWhenPushed(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindHidesBottomBarWhenPushed(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindHidesBottomBarWhenPushed(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindHidesBottomBarWhenPushed(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  WKWebView
    public func bindMediaType(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "mediaType", bindType: bindType)
    }
    
    public func bindMediaType(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindMediaType(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindMediaType(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindMediaType(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindMediaType(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindMediaType(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindCustomUserAgent(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "customUserAgent", bindType: bindType)
    }
    
    public func bindCustomUserAgent(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindCustomUserAgent(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindCustomUserAgent(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindCustomUserAgent(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindCustomUserAgent(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindCustomUserAgent(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAllowsBackForwardNavigationGestures(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "allowsBackForwardNavigationGestures", bindType: bindType)
    }
    
    public func bindAllowsBackForwardNavigationGestures(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAllowsBackForwardNavigationGestures(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAllowsBackForwardNavigationGestures(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAllowsBackForwardNavigationGestures(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAllowsBackForwardNavigationGestures(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAllowsBackForwardNavigationGestures(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAllowsLinkPreview(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "allowsLinkPreview", bindType: bindType)
    }
    
    public func bindAllowsLinkPreview(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAllowsLinkPreview(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAllowsLinkPreview(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAllowsLinkPreview(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAllowsLinkPreview(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAllowsLinkPreview(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  CALayer
    public func bindContentsRect(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "contentsRect", bindType: bindType)
    }
    
    public func bindContentsRect(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindContentsRect(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindContentsRect(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindContentsRect(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindContentsRect(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindContentsRect(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindContentsCenter(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "contentsCenter", bindType: bindType)
    }
    
    public func bindContentsCenter(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindContentsCenter(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindContentsCenter(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindContentsCenter(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindContentsCenter(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindContentsCenter(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindOpacity(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "opacity", bindType: bindType)
    }
    
    public func bindOpacity(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindOpacity(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindOpacity(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindOpacity(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindOpacity(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindOpacity(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindMasksToBounds(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "masksToBounds", bindType: bindType)
    }
    
    public func bindMasksToBounds(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindMasksToBounds(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindMasksToBounds(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindMasksToBounds(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindMasksToBounds(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindMasksToBounds(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindDoubleSided(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isDoubleSided", bindType: bindType)
    }
    
    public func bindDoubleSided(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindDoubleSided(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindDoubleSided(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindDoubleSided(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindDoubleSided(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindDoubleSided(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindCornerRadius(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "cornerRadius", bindType: bindType)
    }
    
    public func bindCornerRadius(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindCornerRadius(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindCornerRadius(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindCornerRadius(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindCornerRadius(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindCornerRadius(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindMaskedCorners(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "maskedCorners", bindType: bindType)
    }
    
    public func bindMaskedCorners(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindMaskedCorners(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindMaskedCorners(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindMaskedCorners(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindMaskedCorners(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindMaskedCorners(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindBorderWidth(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "borderWidth", bindType: bindType)
    }
    
    public func bindBorderWidth(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindBorderWidth(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindBorderWidth(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindBorderWidth(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindBorderWidth(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindBorderWidth(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindBorderColor(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "borderColor", bindType: bindType)
    }
    
    public func bindBorderColor(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindBorderColor(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindBorderColor(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindBorderColor(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindBorderColor(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindBorderColor(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindShadowOpacity(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "shadowOpacity", bindType: bindType)
    }
    
    public func bindShadowOpacity(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindShadowOpacity(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindShadowOpacity(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindShadowOpacity(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindShadowOpacity(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindShadowOpacity(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindShadowRadius(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "shadowRadius", bindType: bindType)
    }
    
    public func bindShadowRadius(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindShadowRadius(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindShadowRadius(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindShadowRadius(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindShadowRadius(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindShadowRadius(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindShadowOffset(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "shadowOffset", bindType: bindType)
    }
    
    public func bindShadowOffset(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindShadowOffset(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindShadowOffset(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindShadowOffset(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindShadowOffset(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindShadowOffset(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindShadowPath(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "shadowPath", bindType: bindType)
    }
    
    public func bindShadowPath(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindShadowPath(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindShadowPath(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindShadowPath(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindShadowPath(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindShadowPath(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAllowsGroupOpacity(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "allowsGroupOpacity", bindType: bindType)
    }
    
    public func bindAllowsGroupOpacity(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAllowsGroupOpacity(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAllowsGroupOpacity(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAllowsGroupOpacity(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAllowsGroupOpacity(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAllowsGroupOpacity(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindPosition(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "position", bindType: bindType)
    }
    
    public func bindPosition(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindPosition(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindPosition(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindPosition(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindPosition(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindPosition(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindZPosition(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "zPosition", bindType: bindType)
    }
    
    public func bindZPosition(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindZPosition(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindZPosition(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindZPosition(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindZPosition(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindZPosition(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAnchorPointZ(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "anchorPointZ", bindType: bindType)
    }
    
    public func bindAnchorPointZ(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAnchorPointZ(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAnchorPointZ(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAnchorPointZ(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAnchorPointZ(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAnchorPointZ(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindAnchorPoint(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "anchorPoint", bindType: bindType)
    }
    
    public func bindAnchorPoint(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindAnchorPoint(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindAnchorPoint(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindAnchorPoint(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindAnchorPoint(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindAnchorPoint(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindContentsScale(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "contentsScale", bindType: bindType)
    }
    
    public func bindContentsScale(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindContentsScale(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindContentsScale(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindContentsScale(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindContentsScale(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindContentsScale(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindName(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "name", bindType: bindType)
    }
    
    public func bindName(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindName(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindName(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindName(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindName(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindName(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindCornerCurve(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "cornerCurve", bindType: bindType)
    }
    
    public func bindCornerCurve(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindCornerCurve(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindCornerCurve(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindCornerCurve(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindCornerCurve(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindCornerCurve(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  UIAlertController
    public func bindMessage(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "message", bindType: bindType)
    }
    
    public func bindMessage(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindMessage(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindMessage(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindMessage(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindMessage(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindMessage(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  UICollectionView
    public func bindPrefetchingEnabled(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isPrefetchingEnabled", bindType: bindType)
    }
    
    public func bindPrefetchingEnabled(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindPrefetchingEnabled(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindPrefetchingEnabled(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindPrefetchingEnabled(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindPrefetchingEnabled(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindPrefetchingEnabled(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindRemembersLastFocusedIndexPath(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "remembersLastFocusedIndexPath", bindType: bindType)
    }
    
    public func bindRemembersLastFocusedIndexPath(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindRemembersLastFocusedIndexPath(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindRemembersLastFocusedIndexPath(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindRemembersLastFocusedIndexPath(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindRemembersLastFocusedIndexPath(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindRemembersLastFocusedIndexPath(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  UIColorPickerViewController
    public func bindSelectedColor(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "selectedColor", bindType: bindType)
    }
    
    public func bindSelectedColor(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSelectedColor(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSelectedColor(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSelectedColor(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSelectedColor(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSelectedColor(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindSupportsAlpha(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "supportsAlpha", bindType: bindType)
    }
    
    public func bindSupportsAlpha(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindSupportsAlpha(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindSupportsAlpha(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindSupportsAlpha(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindSupportsAlpha(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindSupportsAlpha(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  UINavigationController
    public func bindToolbarHidden(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isToolbarHidden", bindType: bindType)
    }
    
    public func bindToolbarHidden(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindToolbarHidden(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindToolbarHidden(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindToolbarHidden(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindToolbarHidden(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindToolbarHidden(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindHidesBarsOnTap(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "hidesBarsOnTap", bindType: bindType)
    }
    
    public func bindHidesBarsOnTap(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindHidesBarsOnTap(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindHidesBarsOnTap(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindHidesBarsOnTap(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindHidesBarsOnTap(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindHidesBarsOnTap(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindHidesBarsOnSwipe(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "hidesBarsOnSwipe", bindType: bindType)
    }
    
    public func bindHidesBarsOnSwipe(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindHidesBarsOnSwipe(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindHidesBarsOnSwipe(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindHidesBarsOnSwipe(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindHidesBarsOnSwipe(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindHidesBarsOnSwipe(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindHidesBarsWhenVerticallyCompact(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "hidesBarsWhenVerticallyCompact", bindType: bindType)
    }
    
    public func bindHidesBarsWhenVerticallyCompact(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindHidesBarsWhenVerticallyCompact(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindHidesBarsWhenVerticallyCompact(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindHidesBarsWhenVerticallyCompact(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindHidesBarsWhenVerticallyCompact(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindHidesBarsWhenVerticallyCompact(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindHidesBarsWhenKeyboardAppears(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "hidesBarsWhenKeyboardAppears", bindType: bindType)
    }
    
    public func bindHidesBarsWhenKeyboardAppears(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindHidesBarsWhenKeyboardAppears(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindHidesBarsWhenKeyboardAppears(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindHidesBarsWhenKeyboardAppears(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindHidesBarsWhenKeyboardAppears(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindHidesBarsWhenKeyboardAppears(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindNavigationBarHidden(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "isNavigationBarHidden", bindType: bindType)
    }
    
    public func bindNavigationBarHidden(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindNavigationBarHidden(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindNavigationBarHidden(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindNavigationBarHidden(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindNavigationBarHidden(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindNavigationBarHidden(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    //MARK: -  UINavigationItem
    public func bindBackButtonTitle(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "backButtonTitle", bindType: bindType)
    }
    
    public func bindBackButtonTitle(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindBackButtonTitle(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindBackButtonTitle(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindBackButtonTitle(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindBackButtonTitle(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindBackButtonTitle(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindHidesBackButton(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "hidesBackButton", bindType: bindType)
    }
    
    public func bindHidesBackButton(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindHidesBackButton(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindHidesBackButton(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindHidesBackButton(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindHidesBackButton(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindHidesBackButton(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindTitleView(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "titleView", bindType: bindType)
    }
    
    public func bindTitleView(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindTitleView(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindTitleView(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindTitleView(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindTitleView(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindTitleView(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
    
    public func bindHidesSearchBarWhenScrolling(bindKey: String, ui:AnyObject, bindType: BindType = .All) {
        bindUI(bindKey: bindKey, ui: ui, attribute: "hidesSearchBarWhenScrolling", bindType: bindType)
    }
    
    public func bindHidesSearchBarWhenScrolling(ui: AnyObject, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        bindHidesSearchBarWhenScrolling(bindKey: bindKey, ui: ui, bindType: bindType)
        
        return bindKey
    }
    
    public func bindHidesSearchBarWhenScrolling(ui: AnyObject, attribute: String, bindType: BindType = .All) -> String {
        let dict: Dictionary<String, BindType> = bindUIBase(bindKey: bindType, attribute: attribute)
        bindHidesSearchBarWhenScrolling(bindKey: Array(dict.keys)[0], ui: ui, bindType: Array(dict.values)[0])
        
        return Array(dict.keys)[0]
    }
    
    public func bindHidesSearchBarWhenScrolling(components: Array<AnyObject>, bindType: BindType = .All) -> String {
        let bindKey: String = "bindParamertes_" + String.random(length: 30)
        for currentUI: AnyObject in components {
            bindHidesSearchBarWhenScrolling(bindKey: bindKey, ui: currentUI, bindType: bindType)
        }
        
        return bindKey
    }
}
