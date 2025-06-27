//
//  UISwitch++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/11/23.
//

import UIKit
import Foundation

extension UISwitch {
    override public func styleDesign(_ design: DesignStyleProtocol) {
        super.styleDesign(design)
        
        if design.setOn != nil {
            setOn(design.setOn as! Bool, animated: false)
        }
        
        if design.setAnimatedOn != nil {
            setOn(design.setOn as! Bool, animated: true)
        }
        
        if design.onTintColor != nil {
            onTintColor = design.onTintColor as? UIColor
        }
        
        if design.thumbTintColor != nil {
            thumbTintColor = design.thumbTintColor as? UIColor
        }
    }
}
