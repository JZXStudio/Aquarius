//
//  AMacro.swift
//  Aquarius
//
//  Created by SONG JIN on 2021/10/2.
//

import UIKit

open class AMacro: NSObject {
    public static func getAllPropertys(clsName: Any?) -> [String] {
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyPropertyList(object_getClass(clsName), count)
        let countInt = Int(count[0])
        for i in 0..<countInt {
            if let temp = buff?[i] {
                let cname = property_getName(temp)
                let proper = String(cString: cname)
                result.append(proper)
            }
        }
        return result
    }
    
    public static func getAllIvarList(clsName: Any?) -> [String] {
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyIvarList(object_getClass(clsName), count)
        let countInt = Int(count[0])
        for i in 0..<countInt {
            if let temp = buff?[i], let cname = ivar_getName(temp) {
                let proper = String(cString: cname)
                result.append(proper)
            }
        }
        return result
    }
    
    public static func delayRun(second: Int, repeats: Bool = false, block: (@escaping() -> Void)) {
        let time: TimeInterval = TimeInterval(second)
        Timer.scheduledTimer(withTimeInterval: time, repeats: repeats) { timer in
            block()
        }
    }
}
