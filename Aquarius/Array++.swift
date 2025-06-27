//
//  Array++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/10/26.
//

import UIKit
import Foundation
import CoreLocation

public enum ViewArrayEqualProperty {
    case alpha
}

extension Array {
    public func get(_ at: Int) -> Element {
        return self[at]
    }
    
    public func getInt(_ at: Int) -> Int {
        return get(at) as! Int
    }
    
    public func getFloat(_ at: Int) -> Float {
        return get(at) as! Float
    }
    
    public func getCGFloat(_ at: Int) -> CGFloat {
        return get(at) as! CGFloat
    }
    
    public func getDouble(_ at: Int) -> Double {
        return get(at) as! Double
    }
    
    public func getString(_ at: Int) -> String {
        return get(at) as! String
    }
    
    public func getBool(_ at: Int) -> Bool {
        return get(at) as! Bool
    }
    
    public func getColor(_ at: Int) -> UIColor {
        return get(at) as! UIColor
    }
    
    public func getDate(_ at: Int) -> Date {
        return get(at) as! Date
    }
    
    public func getFont(_ at: Int) -> UIFont {
        return get(at) as! UIFont
    }
    
    public func getImage(_ at: Int) -> UIImage {
        return get(at) as! UIImage
    }
    
    public func getView(_ at: Int) -> UIView {
        return get(at) as! UIView
    }
    
    public func getButton(_ at: Int) -> UIButton {
        return get(at) as! UIButton
    }
    
    public func getImageView(_ at: Int) -> UIImageView {
        return get(at) as! UIImageView
    }
    
    public func getLocationDegrees(_ at: Int) -> CLLocationDegrees {
        return get(at) as! CLLocationDegrees
    }
    
    public func setAttribute(attributeKey: String, attributeValue: Any) {
        for index: Int in 0..<self.count {
            let object: AnyObject = self[index] as AnyObject
            object.setValue(attributeValue, forKey: attributeKey)
        }
    }
    
    public func isHidden(attributeKey: String, attributeValue: Any, index: Int) {
        let object: AnyObject = self[index] as AnyObject
        object.setValue(attributeValue, forKey: attributeKey)
    }
}

extension Array<UIView> {
    public func alpha(_ alpha: CGFloat) {
        for currentView: UIView in self {
            currentView.alpha = alpha
        }
    }
    
    public func alpha(_ alpha: CGFloat, _ index: Int) {
        let view: UIView = self.getView(index)
        view.alpha = alpha
    }
    
    public func hidden() {
        for currentView: UIView in self {
            currentView.isHidden = true
        }
    }
    
    public func isHidden(_ hidden: Bool) {
        for currentView: UIView in self {
            currentView.isHidden = hidden
        }
    }
    
    public func isHidden(_ hidden: Bool, _ index: Int) {
        let view: UIView = self.getView(index)
        view.isHidden = hidden
    }
    
    public func show() {
        for currentView: UIView in self {
            currentView.isHidden = false
        }
    }
    
    public func isShow(_ show: Bool) {
        for currentView: UIView in self {
            currentView.isHidden = !show
        }
    }
    
    public func isShow(_ show: Bool, _ index: Int) {
        let view: UIView = self.getView(index)
        view.isHidden = !show
    }
    
    public func backgroundColor(_ color: UIColor) {
        for currentView: UIView in self {
            currentView.backgroundColor = color
        }
    }
    
    public func backgroundColor(_ color: UIColor, _ index: Int) {
        let view: UIView = self.getView(index)
        view.backgroundColor = color
    }
    
    public func layerMasksToBounds(_ masksToBounds: Bool) {
        for currentView: UIView in self {
            currentView.layerMasksToBounds(masksToBounds)
        }
    }
    
    public func layerCornerRadius(_ cornerRadius: CGFloat) {
        for currentView: UIView in self {
            currentView.layerCornerRadius(cornerRadius)
        }
    }
    
    public func debugMode(enabled: Bool=true) {
        for currentView: UIView in self {
            currentView.debugMode(enabled: enabled)
        }
    }
    
    public func debugMode(enabled: Bool, index: Int) {
        let view: UIView = self.getView(index)
        view.debugMode(enabled: enabled)
    }
    
    public func styleDesign(_ design: DesignStyleProtocol) {
        for currentView: UIView in self {
            currentView.styleDesign(design)
        }
    }
    
    public func styleDesign(_ design: DesignStyleProtocol, index: Int) {
        let view: UIView = self.getView(index)
        view.styleDesign(design)
    }
    
    public func removeFromSuperview() {
        for currentView: UIView in self {
            currentView.removeFromSuperview()
        }
    }
}

extension Array<UIImageView> {
    /// 设置数组中UIImageView的图片
    /// - Parameter images: 图片数组（当此处数组为空时，则image=nil）。默认为空
    public func image(_ images: Array<UIImage>=[]) {
        let imagesCount: Int = images.count
        var index: Int = 0
        for imageView: UIImageView in self {
            if imagesCount == 0 {
                imageView.image = nil
            } else {
                imageView.image = images.getImage(index)
            }
            index = index + 1
        }
    }
    
    public func hidden() {
        var index: Int = 0
        for imageView: UIImageView in self {
            imageView.isHidden()
            index = index + 1
        }
    }
    
    public func isHidden(_ isHidden: Bool=true) {
        var index: Int = 0
        for imageView: UIImageView in self {
            imageView.isHidden(isHidden)
            index = index + 1
        }
    }
    
    public func show() {
        var index: Int = 0
        for imageView: UIImageView in self {
            imageView.isShow()
            index = index + 1
        }
    }
    
    public func isShow(_ isShow: Bool=true) {
        var index: Int = 0
        for imageView: UIImageView in self {
            imageView.isShow(isShow)
            index = index + 1
        }
    }
}

extension Array<UILabel> {
    public func text(_ texts: Array<String>) {
        var index: Int = 0
        for label: UILabel in self {
            label.text = texts.getString(index)
            index = index + 1
        }
    }
    
    public func textColor(_ textColor: UIColor) {
        for label: UILabel in self {
            label.textColor = textColor
        }
    }
    
    public func textColor(_ textColors: [UIColor]) {
        var i: Int = 0
        for label: UILabel in self {
            label.textColor = textColors[i]
            i++
        }
    }
    
    public func textAligment(_ textAligment: NSTextAlignment) {
        for label: UILabel in self {
            label.textAlignment = textAligment
        }
    }
    
    public func textLeftAlignment() {
        for label: UILabel in self {
            label.textAlignment = .left
        }
    }
    
    public func textCenterAlignment() {
        for label: UILabel in self {
            label.textAlignment = .center
        }
    }
    
    public func textRightAlignment() {
        for label: UILabel in self {
            label.textAlignment = .right
        }
    }
    
    public func textNaturalAlignment() {
        for label: UILabel in self {
            label.textAlignment = .natural
        }
    }
    
    public func textJustifiedAlignment() {
        for label: UILabel in self {
            label.textAlignment = .justified
        }
    }
    
    public func font(_ font: UIFont) {
        for label: UILabel in self {
            label.font = font
        }
    }
}
