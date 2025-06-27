//
//  AViewBase.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/6/18.
//

import UIKit
import Foundation

open class AViewBase: NSObject, ABindProcotol {
    internal var bindKeyArray: Array<String> = Array()
    
    deinit {
        a_InternalClear()
        a_Clear()
    }
    
    override public init() {
        super.init()
        
        self.a_Preview()
        self.a_Begin()
    }
    
    open func a_Preview() {}
    open func a_Begin() {}
    private func a_InternalClear() {
        var bindObjects: [Any] = []
        let mirror = Mirror(reflecting: self)
        for children in mirror.children {
            if ABindable.checkBind(children.value) {
                bindObjects.append(children.value)
            }
            
            if children.value is UIControl {
                (children.value as! UIControl).checkAndRemoveAllEventBlock()
            }
        }
        clearBinds(objects: bindObjects)
    }
    open func a_Clear() {}
    //MARK: - ABindProcotol
    internal func bindableTo(bindKey: String, attribute: String) {
        bindKeyArray.append(bindKey)
        bindTo(bindKey: bindKey, attribute: attribute)
    }
    
    public func bindableTo(_ dict: Dictionary<String, String>) {
        let bindKey: String = Array(dict.keys)[0]
        let attribute: String = Array(dict.values)[0]
        
        bindableTo(bindKey: bindKey, attribute: attribute)
    }
    
    public func bindablesTo(_ o: Array<Dictionary<String, String>>) {
        for current: Dictionary<String, String> in o {
            let bindKey: String = Array(current.keys)[0]
            let attribute: String = Array(current.values)[0]
            
            bindableTo(bindKey: bindKey, attribute: attribute)
        }
    }
    
    internal func bindableFrom(bindKey: String, attribute: String) {
        bindKeyArray.append(bindKey)
        bindFrom(bindKey: bindKey, attribute: attribute)
    }
    
    public func bindableFrom(_ dict: Dictionary<String, String>) {
        let bindKey: String = Array(dict.keys)[0]
        let attribute: String = Array(dict.values)[0]
        
        bindableFrom(bindKey: bindKey, attribute: attribute)
    }
    
    public func bindablesFrom(_ o: Array<Dictionary<String, String>>) {
        for current: Dictionary<String, String> in o {
            let bindKey: String = Array(current.keys)[0]
            let attribute: String = Array(current.values)[0]
            
            bindableFrom(bindKey: bindKey, attribute: attribute)
        }
    }
    
    public func ABind_Keys(_ o: Array<String>) {
        for currentKey: String in o {
            bindKeyArray.append(currentKey)
        }
    }
}
