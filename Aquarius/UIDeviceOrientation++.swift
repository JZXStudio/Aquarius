//
//  UIDeviceOrientation++.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/12/30.
//
import UIKit
import Foundation

extension UIDeviceOrientation {
    // 获取当前屏幕方向
    var interfaceOrientation: UIInterfaceOrientation {
        switch self {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeRight // 注意：设备的左旋是界面的右旋
        case .landscapeRight:
            return .landscapeLeft // 注意：设备的右旋是界面的左旋
        case .faceUp, .faceDown, .unknown:
            return .unknown
        @unknown default:
            return .unknown
        }
    }
    
    // 判断当前屏幕是否是竖屏
    func isPortrait() -> Bool {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first ?? UIWindow()
        let orientation = window.windowScene?.interfaceOrientation
        switch orientation {
        case .portrait, .portraitUpsideDown:
            return true
        case .landscapeLeft, .landscapeRight:
            return false
        default:
            return true
        }
    }
    
    // 判断当前屏幕是否是竖屏
    func isLandscape() -> Bool {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first ?? UIWindow()
        let orientation = window.windowScene?.interfaceOrientation
        switch orientation {
        case .portrait, .portraitUpsideDown:
            return false
        case .landscapeLeft, .landscapeRight:
            return true
        default:
            return true
        }
    }
}
