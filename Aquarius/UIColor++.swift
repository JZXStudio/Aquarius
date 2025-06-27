//
//  UIColor++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/8/31.
//

import UIKit
import Foundation

extension UIColor {
    public static var theme: AThemeStyleProtocol? {
        get {
            let themeStyle: AThemeStyle = AThemeStyle.shared
            return themeStyle.current
        }
    }
    
    public static func subTheme(_ name: String) -> AThemeStyleBaseProtocol? {
        var _protocol: AThemeStyleBaseProtocol?
        let themeStyle: AThemeStyle = AThemeStyle.shared
        let theme: AThemeStyleProtocol = themeStyle.current!
        let mirror = Mirror(reflecting: theme.self)
        for child in mirror.children {
            if child.label == name {
                _protocol = child.value as? AThemeStyleBaseProtocol
                break
            }
        }
        
        return _protocol
    }
    //随机颜色，不能修改alpha值
    public static var randomColor: UIColor {
        get {
            let red = CGFloat.random(in: 0...1)
            let green = CGFloat.random(in: 0...1)
            let blue = CGFloat.random(in: 0...1)
                
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    //随机颜色，可以修改alpha值
    public static func randomColor(alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
            
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public static func customThemeColor(_ name: String) -> UIColor {
        let custom: AThemeStyleBaseProtocol = UIColor.subTheme("custom")!
        return custom.color!![name]!
    }
    
    public static func hex(_ val: UInt) -> UIColor {
        var r: UInt = 0, g: UInt = 0, b: UInt = 0;
        var a: UInt = 0xFF
        var rgb = val

        if (val & 0xFFFF0000) == 0 {
            a = 0xF

            if val & 0xF000 > 0 {
                a = val & 0xF
                rgb = val >> 4
            }

            r = (rgb & 0xF00) >> 8
            r = (r << 4) | r

            g = (rgb & 0xF0) >> 4
            g = (g << 4) | g

            b = rgb & 0xF
            b = (b << 4) | b

            a = (a << 4) | a

        } else {
            if val & 0xFF000000 > 0 {
                a = val & 0xFF
                rgb = val >> 8
            }

            r = (rgb & 0xFF0000) >> 16
            g = (rgb & 0xFF00) >> 8
            b = rgb & 0xFF
        }

        return UIColor(red: CGFloat(r) / 255.0,
                        green: CGFloat(g) / 255.0,
                        blue: CGFloat(b) / 255.0,
                        alpha: CGFloat(a) / 255.0)
    }
    
    public static func hex(_ hex: String) -> UIColor {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1 //'scanLocation' was deprecated in iOS 13.0
            //scanner.currentIndex = hex.startIndex
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color) //'scanHexInt32' was deprecated in iOS 13.0
         
         let mask = 0x000000FF
         let r = Int(color >> 16) & mask
         let g = Int(color >> 8) & mask
         let b = Int(color) & mask
        
        /*
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let mask = 0x000000FF
        let r = Int(rgbValue >> 16) & mask
        let g = Int(rgbValue >> 8) & mask
        let b = Int(rgbValue) & mask
        */
        let red    = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue   = CGFloat(b) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    public func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }
    
    public static func userInterfaceStyleColor(colors: Array<UIColor>) -> UIColor {
        let style: UIUserInterfaceStyle = AThemeStyle.shared.userInterfaceStyle
        return style == .dark ? colors[1] : colors[0]
    }
    
    public static func userInterfaceStyleColor(normal: UIColor, dark: UIColor) -> UIColor {
        return AThemeStyle.shared.userInterfaceStyle == .dark ? dark : normal
    }
    
    public static func userInterfaceStyleColor(normal: UInt, dark: UInt) -> UIColor {
        return AThemeStyle.shared.userInterfaceStyle == .dark ? UIColor.hex(dark) : UIColor.hex(normal)
    }
}
