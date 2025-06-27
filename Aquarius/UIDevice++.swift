//
//  UIDevice++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/8/29.
//

import UIKit
import Foundation
import LocalAuthentication

extension UIDevice {
    public func isPhone() -> Bool {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        //模拟器x86-64
        return identifier.contains("iPhone")
    }
    
    public func isPad() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .pad) ? true : false;
    }
    
    public func isTouchID() -> Bool {
        //创建上下文
        let context = LAContext()
        var error : NSError?
        //判断设备是否支持指纹识别
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            return false
        }
    }
    
    public func isPhoneXOrLater() -> Bool {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        let safeAreaBottom = keyWindow?.safeAreaInsets.bottom
        
        return safeAreaBottom == 0 ? false : true
    }
}
