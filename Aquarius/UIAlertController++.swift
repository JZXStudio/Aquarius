//
//  UIAlertController++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/10/1.
//

import UIKit
import Foundation

extension UIAlertController {
    public func attributedTitle(_ attributedTitle: NSMutableAttributedString) {
        self.setValue(attributedTitle, forKey: "attributedTitle")
    }
    
    public func attributedMessage(_ attributedMessage: NSMutableAttributedString) {
        self.setValue(attributedMessage, forKey: "attributedMessage")
    }
    
    public func contentViewController(_ contentViewController: UIViewController) {
        self.setValue(contentViewController, forKey: "contentViewController")
    }
    
    public func contentViewController() -> UIViewController? {
        return self.value(forKey: "contentViewController") as? UIViewController
    }
    
    public func headerContentViewController(_ headerContentViewController: UIViewController) {
        self.setValue(headerContentViewController, forKey: "headerContentViewController")
    }
    
    public func headerContentViewController() -> UIViewController? {
        return self.value(forKey: "headerContentViewController") as? UIViewController
    }
}
