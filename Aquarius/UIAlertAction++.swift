//
//  UIAlertAction++.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/9/13.
//

import UIKit
import Foundation

extension UIAlertAction {
    public func titleTextColor(_ titleTextColor: UIColor) {
        self.setValue(titleTextColor, forKey: "titleTextColor")
    }
    
    public func contentViewController(_ contentViewController: UIViewController) {
        self.setValue(contentViewController, forKey: "contentViewController")
    }
    
    public func titleTextAlignment(_ titleTextAlignment: NSTextAlignment) {
        self.setValue(titleTextAlignment, forKey: "titleTextAlignment")
    }
    
    private static var propertyNames: [String] {
        var outCount: UInt32 = 0
        guard let ivars = class_copyIvarList(self, &outCount) else {
            return []
        }
        var result = [String]()
        let count = Int(outCount)
        for i in 0..<count {
            let pro: Ivar = ivars[i]
            guard let ivarName = ivar_getName(pro) else {
                continue
            }
            guard let name = String(utf8String: ivarName) else {
                continue
            }
            result.append(name)
        }
        return result
    }
    
    public func titleColor(_ titleColor: UIColor) {
        let key = "_titleTextColor"
        guard isPropertyExisted(key) else {
            return
        }
        setValue(titleColor, forKey: key)
    }
    
    internal func isPropertyExisted(_ propertyName: String) -> Bool {
        for name in UIAlertAction.propertyNames {
            if name == propertyName {
                return true
            }
        }
        return false
    }
}
