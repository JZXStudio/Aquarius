//
//  UIEdgeInsets+aLayout.swift
//  Aquarius
//
//  Created by SONG JIN on 2025/4/24.
//
import UIKit
import Foundation

extension UIEdgeInsets {
    public static var a_zero: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    @discardableResult
    public func a_top(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: self.left, bottom: self.bottom, right: self.right)
    }
    
    @discardableResult
    public func a_left(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top, left: value, bottom: self.bottom, right: self.right)
    }
    
    @discardableResult
    public func a_bottom(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top, left: self.left, bottom: value, right: self.right)
    }
    
    @discardableResult
    public func a_right(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: value)
    }
}
