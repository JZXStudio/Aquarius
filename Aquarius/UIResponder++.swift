//
//  UIResponder++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/7.
//

import UIKit
import Foundation

extension UIResponder {
    private struct UIResponderTemp {
        public static var tagString: String = ""
    }
    
    public var tagString: String {
        get {
            return UIResponderTemp.tagString
        }
        set {
            UIResponderTemp.tagString = newValue
        }
    }
    
    public func currentUserInterfaceStyle() -> UIUserInterfaceStyle {
        return UITraitCollection.current.userInterfaceStyle
    }
}
