//
//  UITextField++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/14.
//

import UIKit
import Foundation

public enum TextFieldEqualProperty {
    case text
    case attributedText
    case textColor
    case textAlignment
    case font
    case isEnabled
    case placeHolder
    case attributedPlaceholder
    case none
}

extension UITextField {
    internal struct UITextFieldTemp {
        static var color: UIColor?
        
        public static var equalProperty: TextFieldEqualProperty = .none
        public static var equalToProperty: TextFieldEqualProperty = .none
        public static var equalTarget: UIView? = nil
    }
    
    public func equal(_ property: TextFieldEqualProperty) {
        if UITextFieldTemp.equalTarget == nil {
            UITextFieldTemp.equalProperty = property
        } else {
            if UITextFieldTemp.equalTarget is UILabel {
                let label: UILabel = UITextFieldTemp.equalTarget as! UILabel
                switch UITextFieldTemp.equalToProperty {
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
            } else if UITextFieldTemp.equalTarget is UITextField {
                let textField: UITextField = UITextFieldTemp.equalTarget as! UITextField
                switch UITextFieldTemp.equalToProperty {
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
                case .placeHolder:
                    textField.placeholder = self.placeholder
                    break
                default:
                    break
                }
            } else if UITextFieldTemp.equalTarget is UITextView {
                let textView: UITextView = UITextFieldTemp.equalTarget as! UITextView
                switch UITextFieldTemp.equalToProperty {
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
            UITextFieldTemp.equalTarget = nil
        }
    }
    
    public func equals(_ properties: Array<TextFieldEqualProperty>) {
        if UITextFieldTemp.equalTarget == nil {
            return
        }
        for currentProperty: TextFieldEqualProperty in properties {
            if UITextFieldTemp.equalTarget is UILabel {
                let label: UILabel = UITextFieldTemp.equalTarget as! UILabel
                
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
            } else if UITextFieldTemp.equalTarget is UITextField {
                let textField: UITextField = UITextFieldTemp.equalTarget as! UITextField
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
                case .placeHolder:
                    textField.placeholder = self.placeholder
                    break
                default:
                    break
                }
            } else if UITextFieldTemp.equalTarget is UITextView {
                let textView: UITextView = UITextFieldTemp.equalTarget as! UITextView
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
        
        UITextFieldTemp.equalTarget = nil
    }
    
    public func equalTo(_ property: TextFieldEqualProperty) {
        UITextFieldTemp.equalToProperty = property
    }
    
    public func textFieldTarget(_ view: UIView) {
        if view is UILabel {
            targetLabel(view: view)
            
            UITextFieldTemp.equalProperty = .none
            UITextFieldTemp.equalToProperty = .none
        } else if view is UITextField {
            targetTextField(view: view)
            
            UITextFieldTemp.equalProperty = .none
            UITextFieldTemp.equalToProperty = .none
        } else if view is UITextView {
            targetTextView(view: view)
            
            UITextFieldTemp.equalProperty = .none
            UITextFieldTemp.equalToProperty = .none
        }
        
        if UITextFieldTemp.equalProperty == .none {
            UITextFieldTemp.equalTarget = view
       }
    }
    
    internal func targetLabel(view: UIView) -> Void {
        let label: UILabel = view as! UILabel
        
        if UITextFieldTemp.equalProperty != .none {
            switch UITextFieldTemp.equalProperty {
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
        
        if UITextFieldTemp.equalToProperty != .none {
            switch UITextFieldTemp.equalToProperty {
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
    
    internal func targetTextField(view: UIView) -> Void {
        let textField: UITextField = view as! UITextField
        
        if UITextFieldTemp.equalProperty != .none {
            switch UITextFieldTemp.equalProperty {
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
            case .placeHolder:
                self.placeholder = textField.placeholder
                break
            case .attributedPlaceholder:
                self.attributedPlaceholder = textField.attributedPlaceholder
                break
            default:
                break
            }
        }
        
        if UITextFieldTemp.equalToProperty != .none {
            switch UITextFieldTemp.equalToProperty {
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
            case .placeHolder:
                textField.placeholder = self.placeholder
                break
            default:
                break
            }
        }
    }
    
    internal func targetTextView(view: UIView) -> Void {
        let textView: UITextView = view as! UITextView
        
        if UITextFieldTemp.equalProperty != .none {
            switch UITextFieldTemp.equalProperty {
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
        
        if UITextFieldTemp.equalToProperty != .none {
            switch UITextFieldTemp.equalToProperty {
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
    
    public func textFieldTargets(_ views: Array<UIView>) {
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
            UITextFieldTemp.equalProperty = .none
            UITextFieldTemp.equalToProperty = .none
        }
    }
    
    public var placeHolderColor: UIColor? {
       get {
           return UITextFieldTemp.color
       }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
            UITextFieldTemp.color = newValue!
        }
    }
    
    override public
    func styleDesign(_ design: DesignStyleProtocol) {
        super.styleDesign(design)
        
        if design.placeholder != nil {
            placeholder = design.placeholder as? String
        }
    }
    
    public func clearText() {
        self.text = ""
    }
    
    public func getTextSize() -> CGSize {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.frame.height)
        return self.sizeThatFits(maxSize)
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
    
    public func getTextWidth() -> CGFloat {
        return self.getTextSize().width
    }
    
    public func getTextHeight() -> CGFloat {
        return self.getTextSize().height
    }
    
    public func equalTextWidth() {
        self.width(width: self.getTextWidth())
    }
    
    public func equalTextHeight() {
        self.height(height: self.getTextHeight())
    }
    
    public func equalTextSize(_ widthOffset: CGFloat=0.0, _ heightOffset: CGFloat=0.0) {
        let size: CGSize = CGSizeMake(self.getTextSize().width+widthOffset, self.getTextSize().height+heightOffset)
        self.size(size: size)
    }
}
