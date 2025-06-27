//
//  UILabel++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/20.
//

import UIKit
import Foundation

public enum LabelEqualProperty {
    case text
    case attributedText
    case textColor
    case textAlignment
    case font
    case isEnabled
    case none
}

extension UILabel {
    internal struct UILabelTemp {
        public static var fontBold: Bool = false
        public static var fontItalic: Bool = false
        public static var fontUnderline: Bool = false
        public static var fontDeleteline: Bool = false
        
        public static var equalProperty: LabelEqualProperty = .none
        public static var equalToProperty: LabelEqualProperty = .none
        public static var equalTarget: UIView? = nil
    }
    
    public func equal(_ property: LabelEqualProperty) {
        if UILabelTemp.equalTarget == nil {
            UILabelTemp.equalProperty = property
        } else {
            if UILabelTemp.equalTarget is UILabel {
                let label: UILabel = UILabelTemp.equalTarget as! UILabel
                switch UILabelTemp.equalToProperty {
                case .text:
                    label.text = self.text
                    break
                case .attributedText:
                    label.attributedText = self.attributedText
                    break
                case .textColor:
                    label.textColor = self.textColor
                    break
                case .textAlignment:
                    label.textAlignment = self.textAlignment
                    break
                case .font:
                    label.font = self.font
                    break
                case .isEnabled:
                    label.isEnabled = self.isEnabled
                    break
                default:
                    break
                }
            } else if UILabelTemp.equalTarget is UITextField {
                let textField: UITextField = UILabelTemp.equalTarget as! UITextField
                switch UILabelTemp.equalToProperty {
                case .text:
                    textField.text = self.text
                    break
                case .attributedText:
                    textField.attributedText = self.attributedText
                    break
                case .textColor:
                    textField.textColor = self.textColor
                    break
                case .textAlignment:
                    textField.textAlignment = self.textAlignment
                    break
                case .font:
                    textField.font = self.font
                    break
                case .isEnabled:
                    textField.isEnabled = self.isEnabled
                    break
                default:
                    break
                }
            } else if UILabelTemp.equalTarget is UITextView {
                let textView: UITextView = UILabelTemp.equalTarget as! UITextView
                switch UILabelTemp.equalToProperty {
                case .text:
                    textView.text = self.text
                    break
                case .attributedText:
                    textView.attributedText = self.attributedText
                    break
                case .textColor:
                    textView.textColor = self.textColor
                    break
                case .textAlignment:
                    textView.textAlignment = self.textAlignment
                    break
                case .font:
                    textView.font = self.font
                    break
                default:
                    break
                }
            }
            UILabelTemp.equalTarget = nil
        }
    }
    public func equals(_ properties: Array<LabelEqualProperty>) {
        if UILabelTemp.equalTarget == nil {
            return
        }
        for currentProperty: LabelEqualProperty in properties {
            if UILabelTemp.equalTarget is UILabel {
                let label: UILabel = UILabelTemp.equalTarget as! UILabel
                switch currentProperty {
                case .text:
                    label.text = self.text
                    break
                case .attributedText:
                    label.attributedText = self.attributedText
                    break
                case .textColor:
                    label.textColor = self.textColor
                    break
                case .textAlignment:
                    label.textAlignment = self.textAlignment
                    break
                case .font:
                    label.font = self.font
                    break
                case .isEnabled:
                    label.isEnabled = self.isEnabled
                    break
                default:
                    break
                }
            } else if UILabelTemp.equalTarget is UITextField {
                let textField: UITextField = UILabelTemp.equalTarget as! UITextField
                switch currentProperty {
                case .text:
                    textField.text = self.text
                    break
                case .attributedText:
                    textField.attributedText = self.attributedText
                    break
                case .textColor:
                    textField.textColor = self.textColor
                    break
                case .textAlignment:
                    textField.textAlignment = self.textAlignment
                    break
                case .font:
                    textField.font = self.font
                    break
                case .isEnabled:
                    textField.isEnabled = self.isEnabled
                    break
                default:
                    break
                }
            } else if UILabelTemp.equalTarget is UITextView {
                let textView: UITextView = UILabelTemp.equalTarget as! UITextView
                switch currentProperty {
                case .text:
                    textView.text = self.text
                    break
                case .attributedText:
                    textView.attributedText = self.attributedText
                    break
                case .textColor:
                    textView.textColor = self.textColor
                    break
                case .textAlignment:
                    textView.textAlignment = self.textAlignment
                    break
                case .font:
                    textView.font = self.font
                    break
                default:
                    break
                }
            }
        }
        
        UILabelTemp.equalTarget = nil
    }
    
    public func equalTo(_ property: LabelEqualProperty) {
        UILabelTemp.equalToProperty = property
    }
    
    public func labelTarget(_ view: UIView) {
        if view is UILabel {
            targetLabel(view: view)
            
            UILabelTemp.equalProperty = .none
            UILabelTemp.equalToProperty = .none
        } else if view is UITextField {
            targetTextField(view: view)
            
            UILabelTemp.equalProperty = .none
            UILabelTemp.equalToProperty = .none
        } else if view is UITextView {
            targetTextView(view: view)
            
            UILabelTemp.equalProperty = .none
            UILabelTemp.equalToProperty = .none
        }
        
        if UILabelTemp.equalProperty == .none {
           UILabelTemp.equalTarget = view
       }
    }
    
    internal func targetLabel(view: UIView) {
        let label: UILabel = view as! UILabel
        
        if UILabelTemp.equalProperty != .none {
            switch UILabelTemp.equalProperty {
            case .text:
                self.text = label.text
                break
            case .attributedText:
                self.attributedText = label.attributedText
                break
            case .textColor:
                self.textColor = label.textColor
                break
            case .textAlignment:
                self.textAlignment = label.textAlignment
                break
            case .font:
                self.font = label.font
                break
            case .isEnabled:
                self.isEnabled = label.isEnabled
                break
            default:
                break
            }
        }
        
        if UILabelTemp.equalToProperty != .none {
            switch UILabelTemp.equalToProperty {
            case .text:
                label.text = self.text
                break
            case .attributedText:
                label.attributedText = self.attributedText
                break
            case .textColor:
                label.textColor = self.textColor
                break
            case .textAlignment:
                label.textAlignment = self.textAlignment
                break
            case .font:
                label.font = self.font
                break
            case .isEnabled:
                label.isEnabled = self.isEnabled
                break
            default:
                break
            }
        }
    }
    
    internal func targetTextField(view: UIView) {
        let textField: UITextField = view as! UITextField
        
        if UILabelTemp.equalProperty != .none {
            switch UILabelTemp.equalProperty {
            case .text:
                self.text = textField.text
                break
            case .attributedText:
                self.attributedText = textField.attributedText
                break
            case .textColor:
                self.textColor = textField.textColor
                break
            case .textAlignment:
                self.textAlignment = textField.textAlignment
                break
            case .font:
                self.font = textField.font
                break
            case .isEnabled:
                self.isEnabled = textField.isEnabled
                break
            default:
                break
            }
        }
        
        if UILabelTemp.equalToProperty != .none {
            switch UILabelTemp.equalToProperty {
            case .text:
                textField.text = self.text
                break
            case .attributedText:
                textField.attributedText = self.attributedText
                break
            case .textColor:
                textField.textColor = self.textColor
                break
            case .textAlignment:
                textField.textAlignment = self.textAlignment
                break
            case .font:
                textField.font = self.font
                break
            case .isEnabled:
                textField.isEnabled = self.isEnabled
                break
            default:
                break
            }
        }
    }
    
    internal func targetTextView(view: UIView) {
        let textView: UITextView = view as! UITextView
        
        if UILabelTemp.equalProperty != .none {
            switch UILabelTemp.equalProperty {
            case .text:
                self.text = textView.text
                break
            case .attributedText:
                self.attributedText = textView.attributedText
                break
            case .textColor:
                self.textColor = textView.textColor
                break
            case .textAlignment:
                self.textAlignment = textView.textAlignment
                break
            case .font:
                self.font = textView.font
                break
            default:
                break
            }
        }
        
        if UILabelTemp.equalToProperty != .none {
            switch UILabelTemp.equalToProperty {
            case .text:
                textView.text = self.text
                break
            case .attributedText:
                textView.attributedText = self.attributedText
                break
            case .textColor:
                textView.textColor = self.textColor
                break
            case .textAlignment:
                textView.textAlignment = self.textAlignment
                break
            case .font:
                textView.font = self.font
                break
            default:
                break
            }
        }
    }
    
    public func labelTargets(_ views: Array<UIView>) {
        var flag: Bool = false
        for currentView: UIView in views {
            if currentView is UILabel {
                targetLabel(view: currentView)
                flag = true
            } else if currentView is UITextField {
                targetTextField(view: currentView)
                flag = true
            } else if currentView is UITextView {
                targetTextView(view: currentView)
                flag = true
            }
        }
        
        if flag {
            UILabelTemp.equalProperty = .none
            UILabelTemp.equalToProperty = .none
        }
    }
    
    public var fontBold: Bool {
        get {
            return UILabelTemp.fontBold
        }
        set {
            UILabelTemp.fontBold = newValue
        }
    }
    
    public var fontItalic: Bool {
        get {
            return UILabelTemp.fontItalic
        }
        set {
            UILabelTemp.fontItalic = newValue
        }
    }
    
    public var fontUnderline: Bool {
        get {
            return UILabelTemp.fontUnderline
        }
        set {
            UILabelTemp.fontUnderline = newValue
        }
    }
    
    public var fontDeleteline: Bool {
        get {
            return UILabelTemp.fontDeleteline
        }
        set {
            UILabelTemp.fontDeleteline = newValue
        }
    }
    
    public func fontName(_ fontName: String) {
        self.font = UIFont(name: fontName, size: self.font!.pointSize)
    }
    
    public func fontBold(_ enabled: Bool=true) {
        if enabled {
            self.font = self.font.with(.traitBold)
        } else {
            self.font = self.font.without(.traitBold)
        }
        self.fontBold = enabled
    }
    
    public func fontItalic(_ enabled: Bool=true) {
        let matrix = CGAffineTransformMake(1, 0, CGFloat(tanf(Float(enabled ? -20 : 0 * Double.pi) / 180)), 1, 0, 0)
        transform = matrix
    }
    
    public func fontBoldItalic(_ enabled: Bool) {
        fontBold(enabled)
        fontItalic(enabled)
        
        self.fontBold = enabled
        self.fontItalic = enabled
    }
    
    public func fontUnderline(_ enabled: Bool=true) {
        fontStyles(enabled: [enabled, fontDeleteline], styles: [.underlineStyle, .strikethroughStyle])
        fontUnderline = enabled
    }
    
    public func fontDeleteline(_ enabled: Bool=true) {
        fontStyles(enabled: [fontUnderline, enabled], styles: [.underlineStyle, .strikethroughStyle])
        fontDeleteline = enabled
    }
    
    public func fontUnderAndDeleteline(_ enabled: Bool) {
        fontStyles(enabled: [enabled, enabled], styles: [.underlineStyle, .strikethroughStyle])
        
        fontUnderline = enabled
        fontDeleteline = enabled
    }
    
    internal func fontStyle(enabled: Bool, style: NSAttributedString.Key) {
        let attrStr: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
        let range: NSRange = NSRange(location: 0, length: self.text!.count)
        if enabled {
            attrStr.addAttribute(style, value: 1, range: range)
        } else {
            attrStr.addAttribute(style, value: 0, range: range)
        }
        self.attributedText = attrStr
    }
    
    internal func fontStyles(enabled: [Bool], styles:[NSAttributedString.Key]) {
        var styleDict: Dictionary<NSAttributedString.Key, Any> = [:]
        var i: Int = 0
        for style: NSAttributedString.Key in styles {
            styleDict[style] = enabled[i] ? 1 : 0
            i++
        }
        
        let attrStr: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
        let range: NSRange = NSRange(location: 0, length: self.text!.count)
        attrStr.addAttributes(styleDict, range: range)
        self.attributedText = attrStr
    }
    
    public func getTextSize() -> CGSize {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.frame.height)
        return self.sizeThatFits(maxSize)
    }
    
    public func getTextWidth() -> CGFloat {
        return self.getTextSize().width
    }
    
    public func getTextHeight() -> CGFloat {
        return self.getTextSize().height
    }
    /// 设置宽度等于文本宽度
    ///
    /// **Note：**此处执行的是加法，若要宽度比文本宽度小，请传入负值
    ///
    /// - Parameter offset: 左右边距，默认为0
    public func equalTextWidth(offset: CGFloat=0.0) {
        self.width(width: self.getTextWidth()+offset)
    }
    /// 设置高度等于文本高度
    ///
    /// **Note：**此处执行的是加法，若要高度比文本高度小，请传入负值
    ///
    /// - Parameter offset: 上下边距，默认为0
    public func equalTextHeight(offset: CGFloat=0.0) {
        self.height(height: self.getTextHeight()+offset)
    }
    
    public func equalTextSize(_ widthOffset: CGFloat=0.0, _ heightOffset: CGFloat=0.0) {
        let size: CGSize = CGSizeMake(self.getTextSize().width+widthOffset, self.getTextSize().height+heightOffset)
        self.size(size: size)
    }
    
    override public
    func styleDesign(_ design: DesignStyleProtocol) {
        super.styleDesign(design)
        
        if design.font != nil {
            font = design.font as? UIFont
        }
        
        if design.text != nil {
            text = design.text as? String
        }
        
        if design.textColor != nil {
            textColor = design.textColor as? UIColor
        }
        
        if design.textAlignment != nil {
            textAlignment = design.textAlignment as! NSTextAlignment
        }
        
        if design.bold != nil {
            fontBold = design.bold as! Bool
        }
        
        if design.italic != nil {
            fontItalic = design.italic as! Bool
        }
        
        if design.underline != nil {
            fontUnderline = design.underline as! Bool
        }
        
        if design.deleteline != nil {
            fontDeleteline = design.deleteline as! Bool
        }
        
        if design.isEnabled != nil {
            isEnabled = design.isEnabled as! Bool
        }
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
    
    public func textNaturalAlignment() {
        self.textAlignment = .natural
    }
    
    public func textJustifiedAlignment() {
        self.textAlignment = .justified
    }
    
    public func font(_ font: UIFont!) {
        self.font = font
    }
    
    public func font(_ size: CGFloat) {
        self.font = UIFont.systemFont(ofSize: size)
    }
    
    public func boldFont(_ size: CGFloat) {
        self.font = UIFont.boldSystemFont(ofSize: size)
    }
}
