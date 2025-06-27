//
//  ABind.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/8/12.
//

import Foundation

public enum BindType {
    case All
    case From
    case To
}

open class ABind: NSObject {
    private var fromBindables: Array<Dictionary<String, BindData>> = Array()
    private var toBindables: Array<Dictionary<String, BindData>> = Array()
    
    public static let shared = ABind()
    
    var ob: NSKeyValueObservation?
    var blocks: Array<Dictionary<String, ((Any) -> Void)?>>? = Array()
    
    public func bind(bindKey: String, from: AnyObject, fromAttribute: String, to: AnyObject, toAttribute: String) {
        bindFrom(object: from, bindAttribute: fromAttribute, bindKey: bindKey)
        bindTo(object: to, bindAttribute: toAttribute, bindKey: bindKey)
    }
    
    func bindObject(bindKey: String, object: AnyObject, bindAttribute: String, bindType:BindType) {
        switch bindType {
        case .All:
            self.bindAll(object: object, bindAttribute: bindAttribute, bindKey: bindKey)
            break
        case .From:
            self.bindFrom(object: object, bindAttribute: bindAttribute, bindKey: bindKey)
            break
        case .To:
            self.bindTo(object: object, bindAttribute: bindAttribute, bindKey: bindKey)
            break
        }
    }
    
    func bindAttribute(object: AnyObject, bindAttribute: String, executeBlock: ((Any) -> Void)? = nil) {
        object.addObserver(self, forKeyPath: bindAttribute, options: [.new], context: nil)

        let dict: Dictionary<String, ((Any) -> Void)?> = [bindAttribute : executeBlock]
        blocks?.append(dict)
    }
    
    private func bindFrom(object: AnyObject, bindAttribute: String, bindKey: String) {
        
        let dict: Dictionary<String, BindData> = [bindKey : BindData(object: object, attribute: bindAttribute, bindKey: bindKey)]
        self.fromBindables.append(dict)
        object.addObserver(self, forKeyPath: bindAttribute, options: [.new], context: nil)
    }
    
    private func bindTo(object: AnyObject, bindAttribute: String, bindKey: String) {
        let dict: Dictionary<String, BindData> = [bindKey : BindData(object: object, attribute: bindAttribute, bindKey: bindKey)]
        self.toBindables.append(dict)
        object.addObserver(self, forKeyPath: bindAttribute, options: [.new], context: nil)
    }
    
    private func bindAll(object: AnyObject, bindAttribute: String, bindKey: String) {
        let dict: Dictionary<String, BindData> = [bindKey : BindData(object: object, attribute: bindAttribute, bindKey: bindKey)]
        self.fromBindables.append(dict)
        self.toBindables.append(dict)
        object.addObserver(self, forKeyPath: bindAttribute, options: [.new], context: nil)
    }
    
    public func removeBindForKey(bindKey: String) {
        var i: Int = 0
        for dict: Dictionary<String, BindData> in self.fromBindables {
            if Array(dict.keys)[0] == bindKey {
                self.removeBindForData(data: Array(dict.values)[0])
                self.fromBindables.remove(at: i)
                break
            }
            i++
        }
        var j: Int = 0
        for dict: Dictionary<String, BindData> in self.toBindables {
            if Array(dict.keys)[0] == bindKey {
                self.removeBindForData(data: Array(dict.values)[0])
                self.toBindables.remove(at: j)
                break
            }
            j++
        }
    }
    
    public func removeBindForKeys(bindKeys: Array<String>) {
        for key: String in bindKeys {
            self.removeBindForKey(bindKey: key)
        }
    }
    
    private func removeBindForData(data: BindData) {
        let o: AnyObject = data.object
        let attribute:String = data.attribute
        o.removeObserver(self, forKeyPath: attribute)
    }
    
    public func removeBindForObject(object: Any) {
        var i: Int = 0
        for dict: [String : BindData] in fromBindables {
            let data: BindData = dict.getValue(0) as! BindData
            let currentObject: AnyObject = data.object
            if currentObject.isEqual(object) {
                removeBindForData(data: data)
                fromBindables.remove(at: i)
                return
            }
            i++
        }
        var j: Int = 0
        for dict: [String : BindData] in toBindables {
            let data: BindData = dict.getValue(0) as! BindData
            let currentObject: AnyObject = data.object
            if currentObject.isEqual(object) {
                removeBindForData(data: data)
                toBindables.remove(at: j)
                return
            }
            j++
        }
    }
    
    public func removeBindForObjects(objects: [Any]) {
        for currentObject: Any in objects {
            removeBindForObject(object: currentObject)
        }
    }
    
    public func removeBindAll() {
        self.removeBind(binds: &self.fromBindables)
        self.removeBind(binds: &self.toBindables)
    }
    
    public func removeBind(binds: inout Array<Dictionary<String, BindData>>) {
        for dict: Dictionary<String, BindData> in binds {
            for bindKey: String in dict.keys {
                let data: BindData = dict[bindKey]!
                self.removeBindForData(data: data)
            }
        }
        
        binds.removeAll()
    }
    
    public func removeBindAttribute(object: AnyObject, attribute: String) {
        object.removeObserver(self, forKeyPath: attribute)
        
        for flag in 0..<blocks!.count {
            let dict = blocks![flag]
            if Array(dict.keys)[0] == attribute {
                blocks!.remove(at: flag)
                break
            }
        }
    }
    
    public func removeBindAttributes(attributes: Array<Dictionary<String, AnyObject>>) {
        for dict: Dictionary<String, AnyObject> in attributes {
            removeBindAttribute(object: Array(dict.values)[0], attribute: Array(dict.keys)[0])
        }
    }
    static var first: Bool = false
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if blocks!.count > 0 {
            ABind.first = false
            for block in blocks! {
                let key: String = Array(block.keys)[0]
                if key == keyPath {
                    if ABind.first {
                        ABind.first = !ABind.first
                        continue
                    }
                    ABind.first = true
                    let blockFunc: ((Any) -> Void)? = Array(block.values)[0]
                    blockFunc!(change?[.newKey] as Any)
                }
            }
        }
        
        var toKey: String = ""
        for fromBindableDict: Dictionary<String, BindData> in self.fromBindables {
            let data: BindData = Array(fromBindableDict.values)[0]
            if data.attribute == keyPath && data.object.isEqual(object) {
                toKey = Array(fromBindableDict.keys)[0]
                break
            }
        }
        
        if toKey != "" {
            for toBindableDict: Dictionary<String, BindData> in self.toBindables {
                let key2: String = Array(toBindableDict.keys)[0]
                if key2 == toKey {
                    let data2: BindData = Array(toBindableDict.values)[0]
                    if !data2.object.isEqual(object) {
                        data2.object.removeObserver(self, forKeyPath: data2.attribute)
                        data2.object.setValue(change?[.newKey], forKey: data2.attribute)
                        data2.object.addObserver(self, forKeyPath: data2.attribute, options: [.new], context: nil)
                    }
                }
            }
        }
    }
}

public struct BindData {
    var object: AnyObject
    var attribute: String
    var bindKey: String
}

protocol ABindProcotol {
    func bindableTo(bindKey: String, attribute: String) -> Void
    func bindableTo(_ dict: Dictionary<String, String>) -> Void
    func bindablesTo(_ o: Array<Dictionary<String, String>>) -> Void
    func bindableFrom(bindKey: String, attribute: String) -> Void
    func bindableFrom(_ dict: Dictionary<String, String>) -> Void
    func bindablesFrom(_ o: Array<Dictionary<String, String>>) -> Void
    /*
    不执行绑定操作，只记录绑定的ID，方便自动释放
    一般用于绑定组件时
    Sample:
    ABind_Keys([
        bindText(ui: test2TextField, attribute: #keyPath(testString))
    ])
     */
    func ABind_Keys(_ o: Array<String>) -> Void
}
