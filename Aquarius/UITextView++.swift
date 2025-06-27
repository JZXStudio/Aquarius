//
//  UITextView++.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/4/22.
//

import UIKit
import Foundation

extension UITextView {
    private struct UITextViewTemp {
        public static var fontBold: Bool = false
        public static var fontItalic: Bool = false
        public static var fontUnderline: Bool = false
        public static var fontDeleteline: Bool = false
        public static var fontBGColor: UIColor = .clear
        public static var font: UIFont?
    }
    
    public var a_font: UIFont? {
        get {
            return UITextViewTemp.font
        }
        set {
            UITextViewTemp.font = newValue
        }
    }
    
    public var fontBold: Bool {
        get {
            return UITextViewTemp.fontBold
        }
        set {
            UITextViewTemp.fontBold = newValue
        }
    }
    
    public var fontItalic: Bool {
        get {
            return UITextViewTemp.fontItalic
        }
        set {
            UITextViewTemp.fontItalic = newValue
        }
    }
    
    public var fontUnderline: Bool {
        get {
            return UITextViewTemp.fontUnderline
        }
        set {
            UITextViewTemp.fontUnderline = newValue
        }
    }
    
    public var fontDeleteline: Bool {
        get {
            return UITextViewTemp.fontDeleteline
        }
        set {
            UITextViewTemp.fontDeleteline = newValue
        }
    }
    
    public var fontBGColor: UIColor {
        get {
            return UITextViewTemp.fontBGColor
        }
        set {
            UITextViewTemp.fontBGColor = newValue
        }
    }
    
    public func font(_ font: UIFont?) {
        self.font = font
    }
    
    public func fontName(_ fontName: String) {
        self.font = UIFont(name: fontName, size: self.font!.pointSize)
    }
    
    public func fontBold(_ enabled: Bool=true) {
        if enabled {
            self.font = self.font!.with(.traitBold)
        } else {
            self.font = self.font!.without(.traitBold)
        }
        self.fontBold = enabled
    }
    //MARK: 暂时弃用（多行文本时，整个文本组件偏移）
    public func fontItalic(_ enabled: Bool=true) {
        let matrix = CGAffineTransformMake(1, 0, CGFloat(tanf(Float(enabled ? -20 : 0 * Double.pi) / 180)), 1, 0, 0)
        transform = matrix
        self.fontItalic = enabled
    }
    
    public func font(_ font: UIFont) {
        fontStyles(enabled: [font, fontUnderline, fontDeleteline, fontBGColor], styles: [.font, .underlineStyle, .strikethroughStyle, .backgroundColor])
        a_font = font
    }
    
    public func fontBoldItalic(_ enabled: Bool) {
        fontBold(enabled)
        fontItalic(enabled)
        
        self.fontBold = enabled
        self.fontItalic = enabled
    }
    
    public func fontUnderline(_ enabled: Bool=true) {
        if a_font != nil {
            fontStyles(enabled: [enabled, a_font!, fontDeleteline, fontBGColor], styles: [.underlineStyle, .font, .strikethroughStyle, .backgroundColor])
        } else {
            fontStyles(enabled: [enabled, fontDeleteline, fontBGColor], styles: [.underlineStyle, .strikethroughStyle, .backgroundColor])
        }
        
        fontUnderline = enabled
    }
    
    public func fontDeleteline(_ enabled: Bool=true) {
        if a_font != nil {
            fontStyles(enabled: [a_font!, fontUnderline, enabled, fontBGColor], styles: [.font, .underlineStyle, .strikethroughStyle, .backgroundColor])
        } else {
            fontStyles(enabled: [fontUnderline, enabled, fontBGColor], styles: [.underlineStyle, .strikethroughStyle, .backgroundColor])
        }
        
        fontDeleteline = enabled
    }
    
    public func fontBGColor(_ color: UIColor) {
        if a_font != nil {
            fontStyles(enabled: [a_font!, fontUnderline, fontDeleteline, color], styles: [.font, .underlineStyle, .strikethroughStyle, .backgroundColor])
        } else {
            fontStyles(enabled: [fontUnderline, fontDeleteline, color], styles: [.underlineStyle, .strikethroughStyle, .backgroundColor])
        }
        
        fontBGColor = color
    }
    
    public func fontUnderAndDeleteline(_ enabled: Bool) {
        if a_font != nil {
            fontStyles(enabled: [a_font!, enabled, enabled, fontBGColor], styles: [.font, .underlineStyle, .strikethroughStyle, .backgroundColor])
        } else {
            fontStyles(enabled: [enabled, enabled, fontBGColor], styles: [.underlineStyle, .strikethroughStyle, .backgroundColor])
        }
        
        fontUnderline = enabled
        fontDeleteline = enabled
    }
    
    private func fontStyle(enabled: Bool, style: NSAttributedString.Key) {
        let attrStr: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
        let range: NSRange = NSRange(location: 0, length: self.text!.count)
        if enabled {
            attrStr.addAttribute(style, value: 1, range: range)
        } else {
            attrStr.addAttribute(style, value: 0, range: range)
        }
        self.attributedText = attrStr
    }
    
    internal func fontStyles(enabled: [Any], styles:[NSAttributedString.Key]) {
        //[.underlineStyle, .strikethroughStyle, .foregroundColor])
        var styleDict: Dictionary<NSAttributedString.Key, Any> = [:]
        var i: Int = 0
        for style: NSAttributedString.Key in styles {
            if style == .underlineStyle || style == .strikethroughStyle {
                styleDict[style] = enabled[i] as! Bool ? 1 : 0
            } else if style == .underlineColor || style == .strikethroughColor || style == .backgroundColor {
                styleDict[style] = enabled[i] as! UIColor
            } else if style == .font {
                styleDict[style] = enabled[i] as! UIFont
            }
            
            i++
        }
        
        let attrStr: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
        let range: NSRange = NSRange(location: 0, length: self.text!.count)
        attrStr.addAttributes(styleDict, range: range)
        self.attributedText = attrStr
    }
    
    public func font(_ size: CGFloat) {
        self.font = UIFont.systemFont(ofSize: size)
    }
    
    public func boldFont(_ size: CGFloat) {
        self.font = UIFont.boldSystemFont(ofSize: size)
    }
    
    public func textLeftAlignment() {
        self.textAlignment = .left
    }
    
    public func textCenterAlignment() {
        self.textAlignment = .center
    }
    
    public func textRightAlignment() {
        self.textAlignment = .right
    }
    
    public func textJustifiedAlignment() {
        self.textAlignment = .justified
    }
    
    public func textNaturalAlignment() {
        self.textAlignment = .natural
    }
    
    public func getTextSize() -> CGSize {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.frame.height)
        return self.sizeThatFits(maxSize)
    }
    
    public func getTextWidth() -> CGFloat {
        return self.getTextSize().width
    }
    
    public func getTextHeight() -> CGFloat {
        let size = CGSize(width: self.width(), height: CGFloat.greatestFiniteMagnitude)
        let constraint = self.sizeThatFits(size)
        return constraint.height
    }
    
    public func equalTextWidth() {
        self.width(width: self.getTextWidth())
    }
    
    public func equalTextHeight() {
        self.height(height: self.getTextHeight())
    }
    
    public func equalTextSize() {
        self.size(size: self.getTextSize())
    }
}
