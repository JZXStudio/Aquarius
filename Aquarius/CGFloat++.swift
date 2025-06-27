//
//  CGFloat++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/23.
//

import UIKit
import Foundation

extension CGFloat {
    public var toFont: UIFont {
        UIFont.systemFont(ofSize: self)
    }
    
    public var toBoldFont: UIFont {
        return UIFont.boldSystemFont(ofSize: self)
    }
    
    public func toString() -> String {
        return "\(self)"
    }
    
    public static func between(postion1: CGFloat, postion2: CGFloat) -> CGFloat {
        if postion1 > postion2 {
            return postion1 - postion2
        } else if postion2 > postion1 {
            return postion2 - postion1
        }
        return 0
    }
    
    public mutating func add(_ value: CGFloat) {
        self = self + value
    }
    
    public mutating func subtract(_ value: CGFloat) {
        self = self - value
    }
    
    public mutating func multiply(_ value: CGFloat) {
        self = self * value
    }
    
    public mutating func divide(_ value: CGFloat) {
        self = self / value
    }
}
