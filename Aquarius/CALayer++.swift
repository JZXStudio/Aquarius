//
//  CATextLayer++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/1.
//

import UIKit
import Foundation
import QuartzCore

extension CALayer {
    public func updateAllThemeStyle(themeStyle: String = AThemeStyle.kDefaultThemeStyle) {
        var currentThemeStyle: AnyObject?
        
        if themeStyle != AThemeStyle.kDefaultThemeStyle {
            let mirrorTemp = Mirror(reflecting: UIColor.theme!.self)
            for mirrorChildTemp in mirrorTemp.children {
                if mirrorChildTemp.label == themeStyle {
                    currentThemeStyle = mirrorChildTemp.value as AnyObject
                    break
                }
            }
        } else {
            var objectClassName: String = String(describing: type(of: self))
            var objectClassNameString: String = objectClassName.substring("Optional<", ">") ?? objectClassName
            
            var flag: Bool = false
            
            if objectClassNameString == NSStringFromClass(CATextLayer.self) {
                currentThemeStyle = UIColor.theme!.textLayer!!
                flag = true
            }
            
            if !flag {
                objectClassName = String(describing: type(of: self.superlayer))
                objectClassNameString = objectClassName.substring("Optional<", ">") ?? objectClassName
                if objectClassNameString == NSStringFromClass(CALayer.self) {
                    currentThemeStyle = UIColor.theme!.layer!!
                    flag = true
                }
            }
        }
        
        let mirror = Mirror(reflecting: currentThemeStyle!.self)
        for mirrorChild in mirror.children {
            if mirrorChild.value is UIImage {
                self.setValue(mirrorChild.value as! UIImage, forKey: mirrorChild.label!)
            } else if mirrorChild.value is UIColor {
                self.setValue((mirrorChild.value as! UIColor).cgColor, forKey: mirrorChild.label!)
            } else if mirrorChild.value is CGFloat {
                self.setValue(mirrorChild.value as! CGFloat, forKey: mirrorChild.label!)
            }
        }
    }
}
