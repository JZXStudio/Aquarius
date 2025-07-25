//
//  Double++.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/2/28.
//

import UIKit
import Foundation

extension Double {
    public var toFont: UIFont {
        UIFont.systemFont(ofSize: self)
    }
    
    public var toBoldFont: UIFont {
        UIFont.boldSystemFont(ofSize: self)
    }
    
    public var toInt: Int {
        Int(self)
    }
    
    public var toCGFloat: CGFloat {
        CGFloat(self)
    }
    
    public func toString(_ format: String="%.02f") -> String {
        String(format: format, self)
    }
    public var toTimeInterval: TimeInterval {
        TimeInterval(self)
    }
    //生成带有价格的 String 字符串
    public func toPrice(currency: String) -> String {
        let nf = NumberFormatter()
        nf.decimalSeparator = ","
        nf.groupingSeparator = "."
        nf.groupingSize = 3
        nf.usesGroupingSeparator = true
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return (nf.string(from: NSNumber(value: self)) ?? "?") + currency
    }
}
