//
//  ATextView.swift
//  Aquarius
//
//  Created by SONG JIN on 2023/12/19.
//

import UIKit
import Foundation

open class ATextView: UITextView {
    /// setNeedsDisplay调用drawRect
    var placeholder: String = ""{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var placeholderColor: UIColor = UIColor.gray {
        didSet{
            self.setNeedsDisplay()
        }
    }
    open override var font: UIFont? {
        didSet{
            self.setNeedsDisplay()
        }
    }
    open override var text: String! {
        didSet{
            self.setNeedsDisplay()
        }
    }
    open override var attributedText: NSAttributedString! {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        /// default字号
        self.font = UIFont.systemFont(ofSize: 14)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged(noti:)), name: UITextView.textDidChangeNotification, object: self)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func textDidChanged(noti: NSNotification)  {
        self.setNeedsDisplay()
    }
    open override func draw(_ rect: CGRect) {
        if self.hasText {
            return
        }
        var newRect = CGRect()
        newRect.origin.x = 5
        newRect.origin.y = 7
        let size = self.placeholder.getStringSize(rectSize: rect.size, font: self.font ?? UIFont.systemFont(ofSize: 14))
        newRect.size.width = size.width
        newRect.size.height = size.height
        /// 将placeHolder画在textView上
        (self.placeholder as NSString).draw(in: newRect, withAttributes: [NSAttributedString.Key.font: self.font ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: self.placeholderColor])
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
    
    override public
    func styleDesign(_ design: DesignStyleProtocol) {
        super.styleDesign(design)
        
        if design.placeholder != nil {
            placeholder = design.placeholder as! String
        }
        
        if design.placeholderColor != nil {
            placeholderColor = design.placeholderColor as! UIColor
        }
        
        if design.font != nil {
            font(design.font as? UIFont)
        }
    }
}
