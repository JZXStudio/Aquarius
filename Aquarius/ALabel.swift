//
//  ALabel.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/16.
//

import UIKit
import Foundation

public enum VerticalAlignment {
    case top
    case middle
    case bottom
}

open class ALabel: UILabel {
    
    public var verticalAlignment: VerticalAlignment?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.verticalAlignment = .middle
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect: CGRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        switch self.verticalAlignment {
        case .top?:
            textRect.origin.y = bounds.origin.y
            break
        case .bottom?:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
            break
        case .middle?:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0
            break
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0
        }
        
        return textRect
    }
    
    open override func draw(_ rect: CGRect) {
        let rect: CGRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: rect)
    }
}
