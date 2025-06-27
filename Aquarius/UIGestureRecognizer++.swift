//
//  UIGestureRecognizer++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/10/3.
//

import UIKit
import Foundation

extension UIGestureRecognizer {
    internal struct UIGestureRecognizerTemp {
        public static var block: ((UIGestureRecognizer) -> Void)?
    }
    
    public func addEventBlock(_ block: ((UIGestureRecognizer) -> Void)?) {
        UIGestureRecognizerTemp.block = block
        addTarget(self, action: #selector(executeBlock))
    }
    
    public func removeEventBlock() {
        removeTarget(self, action: #selector(executeBlock))
    }
    
    @objc internal func executeBlock() {
        UIGestureRecognizerTemp.block?(self)
    }
}
