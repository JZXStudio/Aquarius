//
//  UIView++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/8/26.
//

import UIKit
import Foundation

public enum GradientDirection {
    case Horizontal
    case Vertial
}

public enum ViewEqualProperty {
    case width
    case height
    case left
    case top
    case right
    case bottom
    case point
    case size
    case rect
    case backgroundColor
    case isHidden
    case alpha
    case none
}

extension UIView {
    public struct UIViewTemp {
        static var previewTemp: Bool = false
        public static var equalProperty: ViewEqualProperty = .none
        public static var equalToProperty: ViewEqualProperty = .none
        public static var equalTarget: UIView? = nil
    }
    public static let a_duration: TimeInterval = 0.3
    
    public func equal(_ property: ViewEqualProperty) {
        if UIViewTemp.equalTarget == nil {
            UIViewTemp.equalProperty = property
        } else {
            let view: UIView = UIViewTemp.equalTarget!
            switch UIViewTemp.equalToProperty {
            case .backgroundColor:
                view.backgroundColor = self.backgroundColor
                break
            case .isHidden:
                view.isHidden = self.isHidden
                break
            case .alpha:
                view.alpha = self.alpha
                break
            case .width:
                view.width(width: self.width())
                break
            case .height:
                view.height(height: self.height())
                break
            case .left:
                view.left(left: self.left())
                break
            case .top:
                view.top(top: self.top())
                break
            case .right:
                view.right(right: self.right())
                break
            case .bottom:
                view.bottom(bottom: self.bottom())
                break
            case .point:
                view.point(point: self.point())
                break
            case .size:
                view.size(size: self.size())
                break
            case .rect:
                view.frame(frame: self.frame())
                break
            default:
                break
            }
            
            UIViewTemp.equalTarget = nil
        }
    }
    
    public func equals(_ properties: Array<ViewEqualProperty>) {
        if UIViewTemp.equalTarget == nil {
            return
        }
        for currentProperty: ViewEqualProperty in properties {
            let view: UIView = UIViewTemp.equalTarget!
            
            switch currentProperty {
            case .backgroundColor:
                view.backgroundColor = self.backgroundColor
                break
            case .isHidden:
                view.isHidden = self.isHidden
                break
            case .alpha:
                view.alpha = self.alpha
                break
            case .width:
                view.width(width: self.width())
                break
            case .height:
                view.height(height: self.height())
                break
            case .left:
                view.left(left: self.left())
                break
            case .top:
                view.top(top: self.top())
                break
            case .right:
                view.right(right: self.right())
                break
            case .bottom:
                view.bottom(bottom: self.bottom())
                break
            case .point:
                view.point(point: self.point())
                break
            case .size:
                view.size(size: self.size())
                break
            case .rect:
                view.frame(frame: self.frame())
                break
            default:
                break
            }
        }
        
        UIViewTemp.equalTarget = nil
    }
    
    public func equalTo(_ property: ViewEqualProperty) {
        UIViewTemp.equalToProperty = property
    }
    
    public func target(_ view: UIView) {
        if UIViewTemp.equalProperty != .none {
            switch UIViewTemp.equalProperty {
            case .backgroundColor:
                self.backgroundColor = view.backgroundColor
                break
            case .isHidden:
                self.isHidden = view.isHidden
                break
            case .alpha:
                self.alpha = view.alpha
                break
            case .width:
                self.width(width: view.width())
                break
            case .height:
                self.height(height: view.height())
                break
            case .left:
                self.left(left: view.left())
                break
            case .top:
                self.top(top: view.top())
                break
            case .right:
                self.right(right: view.right())
                break
            case .bottom:
                self.bottom(bottom: view.bottom())
                break
            case .point:
                self.point(point: view.point())
                break
            case .size:
                self.size(size: view.size())
                break
            case .rect:
                self.frame(frame: view.frame())
                break
            default:
                break
            }
            UIViewTemp.equalProperty = .none
        } else {
            UIViewTemp.equalTarget = view
        }
        
        if UIViewTemp.equalToProperty != .none {
            switch UIViewTemp.equalToProperty {
            case .backgroundColor:
                view.backgroundColor = self.backgroundColor
                break
            case .isHidden:
                view.isHidden = self.isHidden
                break
            case .alpha:
                view.alpha = self.alpha
                break
            case .width:
                view.width(width: self.width())
                break
            case .height:
                view.height(height: self.height())
                break
            case .left:
                view.left(left: self.left())
                break
            case .top:
                view.top(top: self.top())
                break
            case .right:
                view.right(right: self.right())
                break
            case .bottom:
                view.bottom(bottom: self.bottom())
                break
            case .point:
                view.point(point: self.point())
                break
            case .size:
                view.size(size: self.size())
                break
            case .rect:
                view.frame(frame: self.frame())
                break
            default:
                break
            }
            UIViewTemp.equalToProperty = .none
        }
    }
    
    public func targets(_ views: Array<UIView>) {
        for currentView: UIView in views {
            if UIViewTemp.equalToProperty != .none {
                switch UIViewTemp.equalToProperty {
                case .backgroundColor:
                    currentView.backgroundColor = self.backgroundColor
                    break
                case .isHidden:
                    currentView.isHidden = self.isHidden
                    break
                case .alpha:
                    currentView.alpha = self.alpha
                    break
                case .width:
                    currentView.width(width: self.width())
                    break
                case .height:
                    currentView.height(height: self.height())
                    break
                case .left:
                    currentView.left(left: self.left())
                    break
                case .top:
                    currentView.top(top: self.top())
                    break
                case .right:
                    currentView.right(right: self.right())
                    break
                case .bottom:
                    currentView.bottom(bottom: self.bottom())
                    break
                case .point:
                    currentView.point(point: self.point())
                    break
                case .size:
                    currentView.size(size: self.size())
                    break
                case .rect:
                    currentView.frame(frame: self.frame())
                    break
                default:
                    break
                }
            }
        }
        
        UIViewTemp.equalToProperty = .none
    }
    //将值设置为true，则默认加一些快速设置，可以快速画出页面原型
    public var preview: Bool {
       get {
           return UIViewTemp.previewTemp
       }
        set {
            if newValue {
                self.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    public var EMPTY: CGFloat {
        get {
            return -65535
        }
    }
    
    public var noNavigationAndTabBarFrame: CGRect {
        get {
            return CGRect(origin: CGPoint(x: 0, y: navigationBarMaxY()), size: CGSize(width: screenWidth(), height: screenHeight()-tabBarHeight()-navigationBarMaxY()-safeAreaFooterHeight()))
        }
    }
    
    public func debugMode(enabled: Bool=true) {
        #if DEBUG
        if enabled {
            self.backgroundColor = .randomColor ~ 20%
            self.layer.borderWidth = 1.0
            self.layer.borderColor = (UIColor.darkGray ~ 50%).cgColor
        }
        #endif
    }
    
    public func getViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    public func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.0) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    public func switchTheme(style: UIUserInterfaceStyle) {
        self.overrideUserInterfaceStyle = style
    }
    
    public func updateAllThemeStyle(_ themeStyle: String = AThemeStyle.kDefaultThemeStyle) {
        var currentThemeStyle: AnyObject?
        var isButton: Bool = false
        
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
            
            switch objectClassNameString {
            case NSStringFromClass(UIView.self):
                currentThemeStyle = UIColor.theme!.view!!
                flag = true
                break
            case NSStringFromClass(UIButton.self):
                currentThemeStyle = UIColor.theme!.button!!
                isButton = true
                flag = true
                break
            case NSStringFromClass(UILabel.self):
                currentThemeStyle = UIColor.theme!.label!!
                flag = true
                break
            case NSStringFromClass(UITextField.self):
                currentThemeStyle = UIColor.theme!.textField!!
                flag = true
                break
            case NSStringFromClass(UITextView.self):
                currentThemeStyle = UIColor.theme!.textView!!
                flag = true
                break
            case NSStringFromClass(UIImageView.self):
                currentThemeStyle = UIColor.theme!.imageView!!
                flag = true
                break
            case NSStringFromClass(UINavigationBar.self):
                currentThemeStyle = UIColor.theme!.navigationBar!!
                flag = true
                break
            case NSStringFromClass(UISearchBar.self):
                currentThemeStyle = UIColor.theme!.searchBar!!
                flag = true
                break
            case NSStringFromClass(UITabBar.self):
                currentThemeStyle = UIColor.theme!.tabBar!!
                flag = true
                break
            case NSStringFromClass(UIProgressView.self):
                currentThemeStyle = UIColor.theme!.progressView!!
                flag = true
                break
            case NSStringFromClass(UITableView.self):
                currentThemeStyle = UIColor.theme!.tableView!!
                flag = true
                break
            case NSStringFromClass(UISwitch.self):
                currentThemeStyle = UIColor.theme!._switch!!
                flag = true
                break
            case NSStringFromClass(UIPageControl.self):
                currentThemeStyle = UIColor.theme!.pageControl!!
                flag = true
                break
            case NSStringFromClass(UISlider.self):
                currentThemeStyle = UIColor.theme!.slider!!
                flag = true
                break
            case NSStringFromClass(UIScrollView.self):
                currentThemeStyle = UIColor.theme!.scrollView!!
                flag = true
                break
            default:
                break
            }
            
            if !flag {
                objectClassName = String(describing: type(of: self.superview))
                objectClassNameString = objectClassName.substring("Optional<", ">") ?? objectClassName
                if objectClassNameString == NSStringFromClass(UIView.self) {
                    currentThemeStyle = UIColor.theme!.view!!
                    flag = true
                }
            }
        }
        
        let mirror = Mirror(reflecting: currentThemeStyle!.self)
        
        if isButton {
            for mirrorChild in mirror.children {
                if mirrorChild.label == "titleColor" {
                    let array: Array<Dictionary<String, Any>> = mirrorChild.value as! Array<Dictionary<String, Any>>
                    for dict in array {
                        let color: UIColor = dict[AThemeStyle.buttonProtocolKey] as! UIColor
                        let state: UIControl.State = dict[AThemeStyle.buttonProtocolState] as! UIControl.State
                        (self as! UIButton).setTitleColor(color, for: state)
                    }
                } else if mirrorChild.label == "titleShadowColor" {
                    let array: Array<Dictionary<String, Any>> = mirrorChild.value as! Array<Dictionary<String, Any>>
                    for dict in array {
                        let color: UIColor = dict[AThemeStyle.buttonProtocolKey] as! UIColor
                        let state: UIControl.State = dict[AThemeStyle.buttonProtocolState] as! UIControl.State
                        (self as! UIButton).setTitleShadowColor(color, for: state)
                    }
                } else if mirrorChild.label == "image" {
                    let array: Array<Dictionary<String, Any>> = mirrorChild.value as! Array<Dictionary<String, Any>>
                    for dict in array {
                        let image: UIImage = dict[AThemeStyle.buttonProtocolKey] as! UIImage
                        let state: UIControl.State = dict[AThemeStyle.buttonProtocolState] as! UIControl.State
                        (self as! UIButton).setImage(image, for: state)
                    }
                } else if mirrorChild.label == "backgroundImage" {
                    let array: Array<Dictionary<String, Any>> = mirrorChild.value as! Array<Dictionary<String, Any>>
                    for dict in array {
                        let image: UIImage = dict[AThemeStyle.buttonProtocolKey] as! UIImage
                        let state: UIControl.State = dict[AThemeStyle.buttonProtocolState] as! UIControl.State
                        (self as! UIButton).setBackgroundImage(image, for: state)
                    }
                } else {
                    for mirrorChild in mirror.children {
                        if mirrorChild.value is UIImage {
                            self.setValue(mirrorChild.value as! UIImage, forKey: mirrorChild.label!)
                        } else if mirrorChild.value is UIColor {
                            self.setValue(mirrorChild.value as! UIColor, forKey: mirrorChild.label!)
                        } else if mirrorChild.value is CGFloat {
                            self.setValue(mirrorChild.value as! CGFloat, forKey: mirrorChild.label!)
                        }
                    }
                }
            }
            
            return
        }
        
        for mirrorChild in mirror.children {
            if mirrorChild.value is UIImage {
                self.setValue(mirrorChild.value as! UIImage, forKey: mirrorChild.label!)
            } else if mirrorChild.value is UIColor {
                self.setValue(mirrorChild.value as! UIColor, forKey: mirrorChild.label!)
            } else if mirrorChild.value is CGFloat {
                self.setValue(mirrorChild.value as! CGFloat, forKey: mirrorChild.label!)
            }
        }
    }
    /// 渐变色
    /// - Parameters:
    ///   - colors: 渐变色的数组
    ///   - direction: 渐变色方向，默认为横向
    ///   - endHPoint: 终点H值，默认为CGPoint(x: 1.0, y: 0)
    ///   - endVPoint: 终点V值，默认为CGPoint(x: 0, y: 1.0)
    public func gradientColor(_ colors: [UIColor], endHPoint: CGPoint?=nil, endVPoint: CGPoint?=nil, direction: GradientDirection = .Horizontal) {
        var cgColors: [CGColor] = []
        for currentColor: UIColor in colors {
            cgColors.append(currentColor.cgColor)
        }
        
        var point_H = CGPoint(x: 1.0, y: 0)
        var point_V = CGPoint(x: 0, y: 1.0)
        
        if endHPoint == nil {
            point_H = CGPoint(x: 1.0, y: 0)
        } else {
            point_H = endHPoint!
        }
        
        if endVPoint == nil {
            point_V = CGPoint(x: 1.0, y: 0)
        } else {
            point_V = endVPoint!
        }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.width(), height: self.height())
        gradient.colors = cgColors
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = (direction == .Horizontal) ? point_H : point_V
        gradient.drawsAsynchronously = true
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    /*
    //渐变色（废弃）
    public func gradientColor(colors: [UIColor], locations: [NSNumber], direction: GradientDirection = .Horizontal, shadow: Bool = false, targetView: UIView) {
        let exColor = colors.compactMap{ $0.cgColor }
        
        let point_H = CGPoint(x: 1.0, y: 0)
        let point_V = CGPoint(x: 0, y: 1.0)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = (direction == .Horizontal) ? point_H : point_V
        
        gradientLayer.colors = exColor
        gradientLayer.locations = locations
        gradientLayer.cornerRadius = targetView.layer.cornerRadius
        
        if shadow {
            gradientLayer.shadowColor = colors[0].cgColor
            gradientLayer.shadowOffset = CGSize(width: 0, height: 4)
            gradientLayer.shadowOpacity = 1
            gradientLayer.shadowRadius = 5
        }
        
        gradientLayer.frame = targetView.frame
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
     */
    //UI组件创建之后，一般在setupUI函数里执行这个函数，来一次性加载所有页面上的元素
    public func addSubviews(views: Array<UIView>) {
        for currentView: UIView in views {
            self.addSubview(currentView)
        }
    }
    
    public func removeSubviews(views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.removeFromSuperview()
        }
    }
    
    public func layerCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
    
    public static func layerCornerRadius(_ cornerRadius: CGFloat, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layerCornerRadius(cornerRadius)
        }
    }
    
    public func layerCornerCurve(_ cornerCurve: CALayerCornerCurve) {
        self.layer.cornerCurve = cornerCurve
    }
    
    public static func layerCornerCurve(_ cornerCurve: CALayerCornerCurve, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layerCornerCurve(cornerCurve)
        }
    }
    
    public func layerMasksToBounds(_ masksToBounds: Bool=true) {
        self.layer.masksToBounds = masksToBounds
    }
    
    public static func layerMasksToBounds(_ masksToBounds: Bool, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layerMasksToBounds(masksToBounds)
        }
    }
    
    public func layerBorderWidth(_ borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
    }
    
    public static func layerBorderWidth(_ borderWidth: CGFloat, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layerBorderWidth(borderWidth)
        }
    }
    
    public func layerBorderColor(_ borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
    }
    
    public static func layerBorderColor(_ borderColor: UIColor, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layerBorderColor(borderColor)
        }
    }
    
    public func layout(_ layout: LayoutProtocol) {
        if layout.x != nil {
            x(x: layout.x!)
        }
        
        if layout.y != nil {
            y(y: layout.y!)
        }
        
        if layout.width != nil {
            width(width: layout.width!)
        }
        
        if layout.height != nil {
            height(height: layout.height!)
        }
        
        if layout.point != nil {
            point(point: layout.point!)
        }
        
        if layout.size != nil {
            size(size: layout.size!)
        }
        
        if layout.frame != nil {
            frame(frame: layout.frame!)
        }
    }
    
    @discardableResult public
    func getLayoutSize() -> CGSize{
        self.setNeedsLayout()
        // 立马布局子视图
        self.layoutIfNeeded()
        return self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    @objc public func styleDesign(_ design: DesignStyleProtocol) {
        if design.radius != nil {
            layerCornerRadius(design.radius as! CGFloat)
        }
        
        if design.shadow != nil {
            shadow(design.shadow as! UIColor)
        }
        
        if design.borderWidth != nil {
            layerBorderWidth(design.borderWidth as! CGFloat)
        }
        
        if design.tintColor != nil {
            tintColor = design.tintColor as? UIColor
        }
        
        if design.backgroundColor != nil {
            backgroundColor = design.backgroundColor as? UIColor
        }
        
        if design.borderColor != nil {
            layerBorderColor(design.borderColor as! UIColor)
        }
        
        if design.maskToBounds != nil {
            layerMasksToBounds(design.maskToBounds as! Bool)
        }
        
        if design.layoutMargins != nil {
            layoutMargins = design.layoutMargins as! UIEdgeInsets
        }
        
        if design.gradientColor != nil {
            gradientColor(design.gradientColor as! Array<UIColor>)
        }

        if design.isHidden != nil {
            isHidden(design.isHidden as! Bool)
        }
    }
    
    public func clearBackgroundColor() {
        self.backgroundColor = .clear
    }
    
    public func whiteBackgroundColor() {
        self.backgroundColor = .white
    }
    
    public func blackBackgroundColor() {
        self.backgroundColor = .black
    }
    
    public func darkGrayBackgroundColor() {
        self.backgroundColor = .darkGray
    }
    
    public func lightGrayBackgroundColor() {
        self.backgroundColor = .lightGray
    }
    
    public func grayBackgroundColor() {
        self.backgroundColor = .gray
    }
    
    public func redBackgroundColor() {
        self.backgroundColor = .red
    }
    
    public func greenBackgroundColor() {
        self.backgroundColor = .green
    }
    
    public func blueBackgroundColor() {
        self.backgroundColor = .blue
    }
    
    public func cyanBackgroundColor() {
        self.backgroundColor = .cyan
    }
    
    public func yellowBackgroundColor() {
        self.backgroundColor = .yellow
    }
    
    public func magentaBackgroundColor() {
        self.backgroundColor = .magenta
    }
    
    public func orangeBackgroundColor() {
        self.backgroundColor = .orange
    }
    
    public func purpleBackgroundColor() {
        self.backgroundColor = .purple
    }
    
    public func brownBackgroundColor() {
        self.backgroundColor = .brown
    }
    
    public func testBackgroundColor() {
        self.backgroundColor = UIColor.randomColor
    }
    
    public static func backgroundColor(_ backgroundColor: UIColor?, views: Array<UIView>) {
        for view: UIView in views {
            view.backgroundColor = backgroundColor
        }
    }
    
    public var ABackgroundColor: UIColor? {
        get {
            return self.backgroundColor
        }
    }
    
    public func isHidden(_ isHidden: Bool=true) {
        self.isHidden = !isHidden
    }
    
    public static func isHidden(_ isHidden: Bool=true, views: Array<UIView>) {
        for view: UIView in views {
            view.isHidden = isHidden
        }
    }
    
    public var AIsHidden: Bool {
        get {
            return self.isHidden
        }
    }
    
    public func isShow(_ isShow: Bool=true) {
        self.isHidden = !isShow
    }
    
    public static func isShow(_ isShow: Bool=true, views: Array<UIView>) {
        for view: UIView in views {
            view.isHidden = !isShow
        }
    }
    
    public var AIsShow: Bool {
        get {
            return !self.isHidden
        }
    }
    
    public func alpha(_ alpha: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.alpha = alpha
            }
        } else {
            self.alpha = alpha
        }
    }
    
    public static func alpha(_ alpha: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for view: UIView in views {
            view.alpha(alpha, animate: animate, duration: duration)
        }
    }
    
    public var AAlpha: CGFloat {
        get {
            return self.alpha
        }
    }
    
    public static func isOpaque(_ isOpaque: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.isOpaque = isOpaque
        }
    }
    
    public var AIsOpaque: Bool {
        get {
            return self.isOpaque
        }
    }
    
    public static func tintColor(_ tintColor: UIColor!, views: Array<UIView>) {
        for view: UIView in views {
            view.tintColor = tintColor
        }
    }
    
    public var ATintColor: UIColor {
        get {
            return self.tintColor
        }
    }
    
    public static func tintAdjustmentMode(_ tintAdjustmentMode: UIView.TintAdjustmentMode, views: Array<UIView>) {
        for view: UIView in views {
            view.tintAdjustmentMode = tintAdjustmentMode
        }
    }
    
    public var ATintAdjustmentMode: UIView.TintAdjustmentMode {
        get {
            return self.tintAdjustmentMode
        }
    }
    
    public static func clipsToBounds(_ clipsToBounds: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.clipsToBounds = clipsToBounds
        }
    }
    
    public var AClipsToBounds: Bool {
        get {
            return self.clipsToBounds
        }
    }
    
    public static func clearsContextBeforeDrawing(_ clearsContextBeforeDrawing: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.clearsContextBeforeDrawing = clearsContextBeforeDrawing
        }
    }
    
    public static func mask(_ mask: UIView?, views: Array<UIView>) {
        for view: UIView in views {
            view.mask = mask
        }
    }
    
    public var AMask: UIView? {
        get {
            return self.mask
        }
    }
    
    public static func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    public var AIsUserInteractionEnabled: Bool {
        get {
            return self.isUserInteractionEnabled
        }
    }
    
    public static func isMultipleTouchEnabled(_ isMultipleTouchEnabled: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.isMultipleTouchEnabled = isMultipleTouchEnabled
        }
    }
    
    public var AIsMultipleTouchEnabled: Bool {
        get {
            return self.isMultipleTouchEnabled
        }
    }
    
    public static func isExclusiveTouch(_ isExclusiveTouch: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.isExclusiveTouch = isExclusiveTouch
        }
    }
    
    public static func frame(_ frame: CGRect, views: Array<UIView>) {
        for view: UIView in views {
            view.frame = frame
        }
    }
    
    public var AFrame: CGRect {
        get {
            return self.frame
        }
    }
    
    public static func bounds(_ bounds: CGRect, views: Array<UIView>) {
        for view: UIView in views {
            view.bounds = bounds
        }
    }
    
    public var ABounds: CGRect {
        get {
            return self.bounds
        }
    }
    
    public static func center(_ center: CGPoint, views: Array<UIView>) {
        for view: UIView in views {
            view.center = center
        }
    }
    
    public var ACenter: CGPoint {
        get {
            return self.center
        }
    }
    
    public static func transform(_ transform: CGAffineTransform, views: Array<UIView>) {
        for view: UIView in views {
            view.transform = transform
        }
    }
    
    public var ATransform: CGAffineTransform {
        get {
            return self.transform
        }
    }
    
    public static func transform3D(_ transform3D: CATransform3D, views: Array<UIView>) {
        for view: UIView in views {
            view.transform3D = transform3D
        }
    }
    
    public var ATransform3D: CATransform3D {
        get {
            return self.transform3D
        }
    }
    
    @available(iOS 16.0, *)
    public static func anchorPoint(_ anchorPoint: CGPoint, views: Array<UIView>) {
        for view: UIView in views {
            view.anchorPoint = anchorPoint
        }
    }
    
    @available(iOS 16.0, *)
    public var AAnchorPoint: CGPoint {
        get {
            return self.anchorPoint
        }
    }
    
    public static func directionalLayoutMargins(_ directionalLayoutMargins: NSDirectionalEdgeInsets, views: Array<UIView>) {
        for view: UIView in views {
            view.directionalLayoutMargins = directionalLayoutMargins
        }
    }
    
    public func layoutMargins(_ layoutMargins: [CGFloat]) {
        self.layoutMargins = UIEdgeInsets(
            top: layoutMargins[0],
            left: layoutMargins[1],
            bottom: layoutMargins[2],
            right: layoutMargins[3]
        )
    }
    
    public static func layoutMargins(_ layoutMargins: UIEdgeInsets, views: Array<UIView>) {
        for view: UIView in views {
            view.layoutMargins = layoutMargins
        }
    }
    
    public var ALayoutMargins: UIEdgeInsets {
        get {
            return self.layoutMargins
        }
    }
    
    public static func preservesSuperviewLayoutMargins(_ preservesSuperviewLayoutMargins: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.preservesSuperviewLayoutMargins = preservesSuperviewLayoutMargins
        }
    }
    
    public static func insetsLayoutMarginsFromSafeArea(_ insetsLayoutMarginsFromSafeArea: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.insetsLayoutMarginsFromSafeArea = insetsLayoutMarginsFromSafeArea
        }
    }
    
    public static func contentMode(_ contentMode: UIView.ContentMode, views: Array<UIView>) {
        for view: UIView in views {
            view.contentMode = contentMode
        }
    }
    
    public var AContentMode: UIView.ContentMode {
        get {
            return self.contentMode
        }
    }
    
    public static func autoresizesSubviews(_ autoresizesSubviews: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.autoresizesSubviews = autoresizesSubviews
        }
    }
    
    public static func autoresizingMask(_ autoresizingMask: UIView.AutoresizingMask, views: Array<UIView>) {
        for view: UIView in views {
            view.autoresizingMask = autoresizingMask
        }
    }
    
    public static func translatesAutoresizingMaskIntoConstraints(_ translatesAutoresizingMaskIntoConstraints: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        }
    }
    
    public static func overrideUserInterfaceStyle(_ overrideUserInterfaceStyle: UIUserInterfaceStyle, views: Array<UIView>) {
        for view: UIView in views {
            view.overrideUserInterfaceStyle = overrideUserInterfaceStyle
        }
    }
    
    public var AOverrideUserInterfaceStyle: UIUserInterfaceStyle {
        get {
            return self.overrideUserInterfaceStyle
        }
    }
    
    public static func semanticContentAttribute(_ semanticContentAttribute: UISemanticContentAttribute, views: Array<UIView>) {
        for view: UIView in views {
            view.semanticContentAttribute = semanticContentAttribute
        }
    }
    
    public static func interactions(_ interactions: [UIInteraction], views: Array<UIView>) {
        for view: UIView in views {
            view.interactions = interactions
        }
    }
    
    public static func contentScaleFactor(_ contentScaleFactor: CGFloat, views: Array<UIView>) {
        for view: UIView in views {
            view.contentScaleFactor = contentScaleFactor
        }
    }
    
    public static func gestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]?, views: Array<UIView>) {
        for view: UIView in views {
            view.gestureRecognizers = gestureRecognizers
        }
    }
    
    @available(iOS 14.0, *)
    public static func focusGroupIdentifier(_ focusGroupIdentifier: String?, views: Array<UIView>) {
        for view: UIView in views {
            view.focusGroupIdentifier = focusGroupIdentifier
        }
    }
    
    @available(iOS 15.0, *)
    public static func focusEffect(_ focusEffect: UIFocusEffect?, views: Array<UIView>) {
        for view: UIView in views {
            view.focusEffect = focusEffect
        }
    }
    
    @available(iOS 15.0, *)
    public static func focusGroupPriority(_ focusGroupPriority: UIFocusGroupPriority, views: Array<UIView>) {
        for view: UIView in views {
            view.focusGroupPriority = focusGroupPriority
        }
    }
    
    public static func motionEffects(_ motionEffects: [UIMotionEffect], views: Array<UIView>) {
        for view: UIView in views {
            view.motionEffects = motionEffects
        }
    }
    
    @available(iOS 15.0, *)
    public static func maximumContentSizeCategory(_ maximumContentSizeCategory: UIContentSizeCategory?, views: Array<UIView>) {
        for view: UIView in views {
            view.maximumContentSizeCategory = maximumContentSizeCategory
        }
    }
    
    @available(iOS 15.0, *)
    public static func minimumContentSizeCategory(_ minimumContentSizeCategory: UIContentSizeCategory?, views: Array<UIView>) {
        for view: UIView in views {
            view.minimumContentSizeCategory = minimumContentSizeCategory
        }
    }
    
    public static func restorationIdentifier(_ restorationIdentifier: String?, views: Array<UIView>) {
        for view: UIView in views {
            view.restorationIdentifier = restorationIdentifier
        }
    }
    
    public static func tag(_ tag: Int, views: Array<UIView>) {
        for view: UIView in views {
            view.tag = tag
        }
    }
    
    public var ATag: Int {
        get {
            return self.tag
        }
    }
    
    public static func accessibilityIgnoresInvertColors(_ accessibilityIgnoresInvertColors: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.accessibilityIgnoresInvertColors = accessibilityIgnoresInvertColors
        }
    }
    
    public static func largeContentImage(_ largeContentImage: UIImage?, views: Array<UIView>) {
        for view: UIView in views {
            view.largeContentImage = largeContentImage
        }
    }
    
    public static func largeContentImageInsets(_ largeContentImageInsets: UIEdgeInsets, views: Array<UIView>) {
        for view: UIView in views {
            view.largeContentImageInsets = largeContentImageInsets
        }
    }
    
    public static func largeContentTitle(_ largeContentTitle: String?, views: Array<UIView>) {
        for view: UIView in views {
            view.largeContentTitle = largeContentTitle
        }
    }
    
    public static func scalesLargeContentImage(_ scalesLargeContentImage: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.scalesLargeContentImage = scalesLargeContentImage
        }
    }
    
    public static func showsLargeContentViewer(_ showsLargeContentViewer: Bool, views: Array<UIView>) {
        for view: UIView in views {
            view.showsLargeContentViewer = showsLargeContentViewer
        }
    }
    
    public func addSubView(_ view: UIView) {
        addSubview(view)
    }
    
    public static func addSubView(_ view: UIView, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.addSubView(view)
        }
    }
    
    public static func bringSubviewToFront(_ view: UIView, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.bringSubviewToFront(view)
        }
    }
    
    public static func sendSubviewToBack(_ view: UIView, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.sendSubviewToBack(view)
        }
    }
    
    public static func removeFromSuperview(_ views: Array<UIView>) {
        for view: UIView in views {
            view.removeFromSuperview()
        }
    }
    
    public static func insertSubview(_ view: UIView, at index: Int, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.insertSubview(view, at: index)
        }
    }
    
    public static func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.insertSubview(view, aboveSubview: siblingSubview)
        }
    }
    
    public static func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.insertSubview(view, belowSubview: siblingSubview)
        }
    }
    
    public static func exchangeSubview(_ index1: Int, withSubviewAt index2: Int, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.exchangeSubview(at: index1, withSubviewAt: index2)
        }
    }
    
    public static func didAddSubview(_ subview: UIView, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.didAddSubview(subview)
        }
    }
    
    public static func willRemoveSubview(_ subview: UIView, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.willRemoveSubview(subview)
        }
    }
    
    public static func willMove(toSuperview newSuperview: UIView?, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.willMove(toSuperview: newSuperview)
        }
    }
    
    public static func didMoveToSuperview(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.didMoveToSuperview()
        }
    }
    
    public static func willMove(toWindow newWindow: UIWindow?, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.willMove(toWindow: newWindow)
        }
    }
    
    public static func didMoveToWindow(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.didMoveToWindow()
        }
    }
    
    public static func layoutMarginsDidChange(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layoutMarginsDidChange()
        }
    }
    
    public static func safeAreaInsetsDidChange(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.safeAreaInsetsDidChange()
        }
    }
    
    public static func addConstraint(_ constraint: NSLayoutConstraint, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.addConstraint(constraint)
        }
    }
    
    public static func removeConstraint(_ constraint: NSLayoutConstraint, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.removeConstraint(constraint)
        }
    }
    
    public static func removeConstraints(_ constraints: [NSLayoutConstraint], views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.removeConstraints(constraints)
        }
    }
    
    public static func addLayoutGuide(_ layoutGuide: UILayoutGuide, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.addLayoutGuide(layoutGuide)
        }
    }
    
    public static func removeLayoutGuide(_ layoutGuide: UILayoutGuide, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.removeLayoutGuide(layoutGuide)
        }
    }
    
    public static func invalidateIntrinsicContentSize(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.invalidateIntrinsicContentSize()
        }
    }
    
    public static func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.setContentCompressionResistancePriority(priority, for: axis)
        }
    }
    
    public static func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.setContentHuggingPriority(priority, for: axis)
        }
    }
    
    public static func setNeedsUpdateConstraints(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.setNeedsUpdateConstraints()
        }
    }
    
    public static func updateConstraints(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.updateConstraints()
        }
    }
    
    public static func updateConstraintsIfNeeded(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.updateConstraintsIfNeeded()
        }
    }
    
    public static func exerciseAmbiguityInLayout(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.exerciseAmbiguityInLayout()
        }
    }
    
    public static func sizeToFit(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.sizeToFit()
        }
    }
    
    public static func layoutSubviews(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layoutSubviews()
        }
    }
    
    public static func setNeedsLayout(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.setNeedsLayout()
        }
    }
    
    public static func layoutIfNeeded(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layoutIfNeeded()
        }
    }
    
    public static func addInteraction(_ interaction: UIInteraction, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.addInteraction(interaction)
        }
    }
    
    public static func removeInteraction(_ interaction: UIInteraction, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.removeInteraction(interaction)
        }
    }
    
    public static func draw(_ rect: CGRect, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.draw(rect)
        }
    }
    
    public static func setNeedsDisplay(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.setNeedsDisplay()
        }
    }
    
    public static func setNeedsDisplay(_ rect: CGRect, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.setNeedsDisplay(rect)
        }
    }
    
    public static func tintColorDidChange(_ views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.tintColorDidChange()
        }
    }
    
    public static func draw(_ rect: CGRect, for formatter: UIViewPrintFormatter, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.draw(rect, for: formatter)
        }
    }
    
    public static func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    public static func removeGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.removeGestureRecognizer(gestureRecognizer)
        }
    }
    
    public static func addMotionEffect(_ effect: UIMotionEffect, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.addMotionEffect(effect)
        }
    }
    
    public static func removeMotionEffect(_ effect: UIMotionEffect, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.removeMotionEffect(effect)
        }
    }
    
    public static func encodeRestorableState(with coder: NSCoder, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.encodeRestorableState(with: coder)
        }
    }
    
    public func shadow(_ color: UIColor, offset:CGSize = CGSize(width: 2, height: 2)) {
        layer.shadowOpacity = 2
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
    }
    /*
    public func gradientColor(_ colors:Array<UIColor>, size: CGSize = CGSizeZero, startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        var resultColors: Array<CGColor> = []
        for index in 0..<colors.count {
            resultColors.append(colors[index].cgColor)
        }
        
        let rect: CGRect = CGRect(origin: self.point(), size: (size == CGSizeZero) ? self.size() : size)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        gradientLayer.colors = resultColors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.zPosition = -1
        gradientLayer.masksToBounds = true
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    */
    // 设置圆角
    // - Parameters:
    //   - cornerRadii: 圆角幅度
    //   - roundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight]
    //   - roundingCorners:.allCorners
    public func createCorner(_ cornerRadii: CGSize, _ roundingCorners:UIRectCorner) {
        let fieldPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)
        let fieldLayer = CAShapeLayer()
        fieldLayer.frame = bounds
        fieldLayer.path = fieldPath.cgPath
        self.layer.mask = fieldLayer
    }
    
    public static func decodeRestorableState(with coder: NSCoder, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.decodeRestorableState(with: coder)
        }
    }
}
