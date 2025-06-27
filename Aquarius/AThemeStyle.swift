//
//  AThemeStyle.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/8/31.
//

import UIKit
import Foundation

public enum AThemeStyleDarkModeType: Int {
    case Light = 1
    case Dark = 2
    case Auto = 0
}

open class AThemeStyle: NSObject {
    public static let shared = AThemeStyle()
    public static let kDefaultThemeStyle: String = "default"
    public static let kNotification_UpdateThemeStyle: String = "ATheme_notification_updateTimeStyle"
    public static let buttonProtocolKey: String = "AThemeStyle_UIButtonProtocol_buttonProtocolKey"
    public static let buttonProtocolState: String = "AThemeStyle_UIButtonProtocol_buttonProtocolState"
    
    public var userInterfaceStyle: UIUserInterfaceStyle {
        get {
            UITraitCollection.current.userInterfaceStyle
        }
        set {
            osUserInterfaceEnabled = (newValue == UITraitCollection.current.userInterfaceStyle)
            NotificationCenter.default.post(name: Notification.Name(AThemeStyle.kNotification_UpdateThemeStyle), object: nil)
        }
    }
    //是否同步系统的模式
    //true：userInterface的值将和系统的一样。默认
    //false：将自定义
    public var osUserInterfaceEnabled: Bool = true
    
    public let systemUserInterfaceStyle: UIUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
    
    internal var themeStyleData: Array <AThemeStyleProtocol> = Array()
    public var current: AThemeStyleProtocol? {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(AThemeStyle.kNotification_UpdateThemeStyle), object: nil)
        }
    }
    
    @discardableResult
    open func current(name: String) -> Bool {
        var result: Bool = false
        for themeStyle: AThemeStyleProtocol in self.themeStyleData {
            if themeStyle.themeStyleName == name {
                self.current = themeStyle
                result = true
                break
            }
        }
        
        return result
    }
    
    public func register(themeStyles: Array<AThemeStyleProtocol>) {
        for themeStyle: AThemeStyleProtocol in themeStyles {
            var flag: Bool = false
            for cacheStyleTheme: AThemeStyleProtocol in self.themeStyleData {
                if cacheStyleTheme.themeStyleName == themeStyle.themeStyleName {
                    flag = true
                    break
                }
            }
            if !flag {
                self.themeStyleData.append(themeStyle)
            }
        }
    }
    
    public static let AThemeStyleDarkMode: String = "AThemeStyleDarkMode"
    //获取当前设置的类型
    public static func getDarkModeType() -> AThemeStyleDarkModeType {
        let value: Int = A.userDefaults.getIntValue(AThemeStyleDarkMode)
            
        if value == AThemeStyleDarkModeType.Light.rawValue {
            return .Light
        } else if value == AThemeStyleDarkModeType.Dark.rawValue {
            return .Dark
        } else {
            return .Auto
        }
    }
    //判断是否设置了深色模式
    public static func isSetDarkMode() -> Bool {
        return (A.userDefaults.getValue(AThemeStyle.AThemeStyleDarkMode) != nil)
    }
    //设置当前类型
    public static func setDarkModeType(_ isDark: Bool) {
        A
            .userDefaults
            .forKey(AThemeStyleDarkMode)
        
        A
            .userDefaults
            .setValue(isDark ? AThemeStyleDarkModeType.Dark.rawValue : AThemeStyleDarkModeType.Light.rawValue)
        AThemeStyle.shared.userInterfaceStyle = isDark ? .dark : .light
    }
    //设置跟随系统
    public static func setDarkModeAutoType() {
        A
            .userDefaults
            .forKey(AThemeStyleDarkMode)
        
        A
            .userDefaults
            .setValue(AThemeStyleDarkModeType.Auto.rawValue)
            
        AThemeStyle.shared.userInterfaceStyle = .unspecified
    }
    //获取当前的主题
    //不包含Auto，只有Dark或Light
    public static func getTheme() -> AThemeStyleDarkModeType {
        var currentTheme: AThemeStyleDarkModeType = AThemeStyle.getDarkModeType()
        if currentTheme == .Auto {
            currentTheme = (AThemeStyle.shared.userInterfaceStyle == .dark) ? .Dark : .Light
        }
        return currentTheme
    }
    
    public static func getThemeColor(_ lightColor: UIColor, _ darkColor: UIColor) -> UIColor {
        let currentTheme: AThemeStyleDarkModeType = AThemeStyle.getTheme()
        
        return currentTheme == .Dark ? darkColor : lightColor
    }
    
    public static func getThemeColor(_ themeColors: Array<UIColor>) -> UIColor {
        let currentTheme: AThemeStyleDarkModeType = AThemeStyle.getTheme()
        return currentTheme == .Dark ? themeColors.getColor(1) : themeColors.getColor(0)
    }
    
    
    public static func getThemeColor(_ themeColorDict: [AThemeStyleDarkModeType : UIColor]) -> UIColor {
        let currentTheme: AThemeStyleDarkModeType = AThemeStyle.getTheme()
        let color: UIColor = themeColorDict[currentTheme == .Dark ? .Dark : .Light]!
        return color
    }
    
    public static func getThemeColorDict(_ themeColorDict: Dictionary<AThemeStyleDarkModeType, Array<UIColor>>) -> Array<UIColor> {
        let currentTheme: AThemeStyleDarkModeType = AThemeStyle.getTheme()
        let colors: Array<UIColor> = themeColorDict[currentTheme == .Dark ? .Dark : .Light]!
        return colors
    }
}

open class ATheme: NSObject, ANotificationDelegate {
    private let j_notification: ANotification = ANotification(notifications: [AThemeStyle.kNotification_UpdateThemeStyle])
    
    deinit {
        j_notification.removeNotification(notificationName: AThemeStyle.kNotification_UpdateThemeStyle)
        j_notification.delegate = nil
    }
    
    public override init() {
        super.init()
        
        j_notification.delegate = self
        updateThemeStyle()
    }
    
    open func updateThemeStyle() {}
    
    public func ANotificationReceive(notification: Notification) {
        updateThemeStyle()
    }
}

@objc public protocol AThemeStyleProtocol {
    var themeStyleName: String { get set }
    
    /* 自定义获取主题方式
     let cardViewTheme:      = UIColor.subTheme("cardView") as! AThemeStyle_UIViewProtocol
     */
    
    @objc optional var view: AThemeStyle_UIViewProtocol? { get set }
    @objc optional var textLayer: AThemeStyle_CATextLayerProtocol? { get set }
    @objc optional var layer: AThemeStyle_CALayerProtocol? { get set }
    @objc optional var label: AThemeStyle_UILabelProtocol? { get set }
    @objc optional var textField: AThemeStyle_UITextFieldProtocol? { get set }
    @objc optional var textView: AThemeStyle_UITextViewProtocol? { get set }
    @objc optional var button: AThemeStyle_UIButtonProtocol? { get set }
    @objc optional var barButtonItem: AThemeStyle_UIBarButtonItemProtocol? { get set }
    @objc optional var imageView: AThemeStyle_UIImageViewProtocol? { get set }
    @objc optional var navigationBar: AThemeStyle_UINavigationBarProtocol? { get set }
    @objc optional var searchBar: AThemeStyle_UISearchBarProtocol? { get set }
    @objc optional var tabBar: AThemeStyle_UITabBarProtocol? { get set }
    @objc optional var _switch: AThemeStyle_UISwitchProtocol? { get set }
    @objc optional var pageControl: AThemeStyle_UIPageControlProtocol? { get set }
    @objc optional var progressView: AThemeStyle_UIProgressViewProtocol? { get set }
    @objc optional var slider: AThemeStyle_UISliderProtocol? { get set }
    @objc optional var tableView: AThemeStyle_UITableViewProtocol? { get set }
    @objc optional var tableViewCell: AThemeStyle_UITableViewCellProtocol? { get set }
    @objc optional var collectionView: AThemeStyle_UICollectionViewProtocol? { get set }
    @objc optional var collectionViewCell: AThemeStyle_UICollectionViewCellProtocol? { get set }
    @objc optional var scrollView: AThemeStyle_UIScrollViewProtocol? { get set }
    @objc optional var webView: AThemeStyle_WKWebViewProtocol? { get set }
    @objc optional var activityIndicatorView: AThemeStyle_UIActivityIndicatorViewProtocol? { get set }
    /* 获取自定义的方式
     let custom: AThemeStyleBaseProtocol = UIColor.subTheme("custom")!
     iconImageView.image = UIImage(systemName: imageName)?.imageWithColor(tintColor: custom.color!!["iconColor"]!)
     或使用
     UIColor.customThemeColor("iconColor")
     */
    @objc optional var custom: AThemeStyleBaseProtocol? { get set }
}

@objc public protocol AThemeStyleBaseProtocol {
    @objc optional var color: Dictionary<String, UIColor>? { get set }
}

@objc public protocol AThemeStyle_UIViewProtocol: AThemeStyleBaseProtocol {
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
}

@objc public protocol AThemeStyle_CATextLayerProtocol: AThemeStyleBaseProtocol {
    @objc optional var foregroundColor: UIColor? { get set }
    
    @objc optional var font: CFTypeRef? { get set }
}

@objc public protocol AThemeStyle_CALayerProtocol: AThemeStyleBaseProtocol {
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var shadowColor: UIColor? { get set }
    @objc optional var borderColor: UIColor? { get set }
}

@objc public protocol AThemeStyle_UILabelProtocol: AThemeStyleBaseProtocol {
    @objc optional var textColor: UIColor? { get set }
    @objc optional var highlightedTextColor: UIColor? { get set }
    @objc optional var shadowColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
    
    @objc optional var font: UIFont? { get set }
}

@objc public protocol AThemeStyle_UITextFieldProtocol: AThemeStyleBaseProtocol {
    @objc optional var textColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
    
    @objc optional var background: UIImage? { get set }
    @objc optional var disabledBackground: UIImage? { get set }
    
    @objc optional var font: UIFont? { get set }
}

@objc public protocol AThemeStyle_UITextViewProtocol: AThemeStyleBaseProtocol {
    @objc optional var textColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
    
    @objc optional var font: UIFont? { get set }
}

@objc public protocol AThemeStyle_UIButtonProtocol: AThemeStyleBaseProtocol {
    @objc optional var titleColor: Array<Dictionary<String, Any>>? { get set }
    @objc optional var titleShadowColor: Array<Dictionary<String, Any>>? { get set }
    @objc optional var tintColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    
    @objc optional var image: Array<Dictionary<String, Any>>? { get set }
    @objc optional var backgroundImage: Array<Dictionary<String, Any>>? { get set }
}

@objc public protocol AThemeStyle_UIBarButtonItemProtocol: AThemeStyleBaseProtocol {
    @objc optional var tintColor: UIColor? { get set }
}

@objc public protocol AThemeStyle_UIImageViewProtocol: AThemeStyleBaseProtocol {
    @objc optional var tintColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    
    @objc optional var image: UIImage? { get set }
    @objc optional var highlightedImage: UIImage? { get set }
}

@objc public protocol AThemeStyle_UINavigationBarProtocol: AThemeStyleBaseProtocol {
    @objc optional var tintColor: UIColor? { get set }
    @objc optional var barTintColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
}

@objc public protocol AThemeStyle_UISearchBarProtocol: AThemeStyleBaseProtocol {
    @objc optional var tintColor: UIColor? { get set }
    @objc optional var barTintColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
}

@objc public protocol AThemeStyle_UITabBarProtocol: AThemeStyleBaseProtocol {
    @objc optional var tintColor: UIColor? { get set }
    @objc optional var barTintColor: UIColor? { get set }
    @objc optional var selectedImageTintColor: UIColor? { get set }
    @objc optional var unselectedItemTintColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    
    @objc optional var selectionIndicatorImage: UIImage? { get set }
    @objc optional var backgroundImage: UIImage? { get set }
    @objc optional var shadowImage: UIImage? { get set }
}

@objc public protocol AThemeStyle_UISwitchProtocol: AThemeStyleBaseProtocol {
    @objc optional var onTintColor: UIColor? { get set }
    @objc optional var thumbTintColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
    
    @objc optional var onImage: UIImage? { get set }
    @objc optional var offImage: UIImage? { get set }
}

@objc public protocol AThemeStyle_UIPageControlProtocol: AThemeStyleBaseProtocol {
    @objc optional var pageIndicatorTintColor: UIColor? { get set }
    @objc optional var currentPageIndicatorTintColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
    
    @objc optional var preferredIndicatorImage: UIImage? { get set }
}

@objc public protocol AThemeStyle_UIProgressViewProtocol: AThemeStyleBaseProtocol {
    @objc optional var progressTintColor: UIColor? { get set }
    @objc optional var trackTintColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
    
    @objc optional var progressImage: UIImage? { get set }
    @objc optional var trackImage: UIImage? { get set }
}

@objc public protocol AThemeStyle_UISliderProtocol: AThemeStyleBaseProtocol {
    @objc optional var minimumTrackTintColor: UIColor? { get set }
    @objc optional var maximumTrackTintColor: UIColor? { get set }
    @objc optional var thumbTintColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
    
    @objc optional var minimumValueImage: UIImage? { get set }
    @objc optional var maximumValueImage: UIImage? { get set }
}

@objc public protocol AThemeStyle_UITableViewProtocol: AThemeStyleBaseProtocol {
    @objc optional var separatorColor: UIColor? { get set }
    @objc optional var sectionIndexColor: UIColor? { get set }
    @objc optional var sectionIndexBackgroundColor: UIColor? { get set }
    @objc optional var sectionIndexTrackingBackgroundColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
}

@objc public protocol AThemeStyle_UITableViewCellProtocol: AThemeStyleBaseProtocol {
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
}

@objc public protocol AThemeStyle_UICollectionViewProtocol: AThemeStyleBaseProtocol {
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
}

@objc public protocol AThemeStyle_UICollectionViewCellProtocol: AThemeStyleBaseProtocol {
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
}

@objc public protocol AThemeStyle_UIScrollViewProtocol: AThemeStyleBaseProtocol {
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
}

@objc public protocol AThemeStyle_UIActivityIndicatorViewProtocol: AThemeStyleBaseProtocol {
    @objc optional var color: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
}

@objc public protocol AThemeStyle_WKWebViewProtocol: AThemeStyleBaseProtocol {
    @objc optional var themeColor: UIColor? { get set }
    
    @objc optional var backgroundColor: UIColor? { get set }
    @objc optional var tintColor: UIColor? { get set }
}


