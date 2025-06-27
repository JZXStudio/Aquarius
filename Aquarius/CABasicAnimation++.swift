//
//  CABasicAnimation++.swift
//  Aquarius
//
//  Created by SONG JIN on 2025/5/6.
//

import Foundation
import QuartzCore

extension CABasicAnimation {
    public func toValue(_ toValue: NSNumber) {
        self.toValue = toValue
    }
    
    public func duration(_ duration: CFTimeInterval) {
        self.duration = duration
    }
    
    public func isCumulative(_ isCumulative: Bool = true) {
        self.isCumulative = isCumulative
    }
    
    public func repeatCount(_ repeatCount: Float) {
        self.repeatCount = repeatCount
    }
}
