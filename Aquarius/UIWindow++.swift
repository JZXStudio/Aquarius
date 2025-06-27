//
//  UIWindow++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/10/3.
//

import UIKit
import Foundation

extension UIWindow {
    static public var keyWindow: UIWindow? {
        var keyWindow: UIWindow?
        if #available(iOS 13, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        return keyWindow
    }
    
    public var ARootViewController: UIViewController? {
        get {
            return self.rootViewController
        }
    }
    
    public var AWindowLevel: UIWindow.Level {
        get {
            return self.windowLevel
        }
    }
}
