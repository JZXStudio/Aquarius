//
//  CSSParser.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/3/28.
//

import UIKit
import Foundation

public enum CSSProperty {
    case left
    case top
    case width
    case height
    case opacity
    case borderRadius
    case background
    case display
    case padding
}

extension UIButton {
    public func css(_ cssStyle:Dictionary<CSSProperty, Any>) {
        for i in 0 ..< cssStyle.keys.count {
            let style: CSSProperty = cssStyle.getKey(i) as! CSSProperty
            let value: Any = cssStyle.getValue(i)
            
            if style == .left {
                if value is Double {
                    self.left(left: CGFloat(value as! Double))
                } else if value is Int {
                    self.left(left: CGFloat(value as! Int))
                }
            } else if style == .top {
                if value is Double {
                    self.top(top: CGFloat(value as! Double))
                } else if value is Int {
                    self.top(top: CGFloat(value as! Int))
                }
            } else if style == .width {
                if value is Double {
                    self.width(width: CGFloat(value as! Double))
                } else if value is Int {
                    self.width(width: CGFloat(value as! Int))
                }
            } else if style == .height {
                if value is Double {
                    self.height(height: CGFloat(value as! Double))
                } else if value is Int {
                    self.height(height: CGFloat(value as! Int))
                }
            } else if style == .borderRadius {
                var valueFloat: CGFloat = 0.0
                if value is Double {
                    valueFloat = CGFloat(value as! Double)
                } else if value is Int {
                    valueFloat = CGFloat(value as! Int)
                }
                if valueFloat > self.height()/2 {
                    valueFloat = self.height()/2
                }
                self.layer.cornerRadius = valueFloat
            }
        }
    }
}
