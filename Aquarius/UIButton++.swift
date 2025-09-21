//
//  UIButton++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/30.
//
import UIKit
import Foundation

public enum ImageAndTitlePossitionStyle {
    case imageDefault  //图片在左，文字在右，整体居中。(系统,没有间距设置)
    case imageLeft    //图片在左，文字在右，整体居中
    case imageRight   //图片在右，文字在左，整体居中
    case imageTop     //图片在上，文字在下，整体居中
    case imgageBottom //图片在下，文字在上，整体居中
}

public enum ButtonEqualProperty {
    case textAlignment
    case font
    case bold
    case italic
    case none
}

public enum LiquidGlassType {
    case glass
    case clearGlass
    case prominentGlass
    case prominentClearGlass
}

public enum LiquidGlassConfig {
    case title
    case attributedTitle
    case subtitle
    case attributedSubtitle
    case titlePadding
    case titleAlignment
    case image
    case imagePadding
    case baseForegroundColor
    case baseBackgroundColor
}

extension UIButton {
    internal struct UIButtonTemp {
        public static var equalProperty: ButtonEqualProperty = .none
        public static var equalToProperty: ButtonEqualProperty = .none
        public static var equalTarget: UIView? = nil
    }
    
    public func equal(_ property: ButtonEqualProperty) {
        if UIButtonTemp.equalTarget == nil {
            UIButtonTemp.equalProperty = property
        } else {
            let button: UIButton = UIButtonTemp.equalTarget as! UIButton
            switch property {
            case .textAlignment:
                button.titleLabel?.textAlignment = self.titleLabel!.textAlignment
                break
            case .font:
                button.titleLabel?.font = self.titleLabel?.font
                break
            case .bold:
                button.titleLabel?.fontBold(self.titleLabel!.fontBold)
                break
            case .italic:
                button.titleLabel?.fontItalic(self.titleLabel!.fontItalic)
                break
            default:
                break
            }
            UIButtonTemp.equalTarget = nil
        }
    }
    
    public func equals(_ properties: Array<ButtonEqualProperty>) {
        if UIButtonTemp.equalTarget == nil {
            return
        }
        for currentProperty: ButtonEqualProperty in properties {
            let button: UIButton = UIButtonTemp.equalTarget as! UIButton
            
            switch currentProperty {
            case .textAlignment:
                button.titleLabel?.textAlignment = self.titleLabel!.textAlignment
                break
            case .font:
                button.titleLabel?.font = self.titleLabel?.font
                break
            case .bold:
                button.titleLabel?.fontBold(self.titleLabel!.fontBold)
                break
            case .italic:
                button.titleLabel?.fontItalic(self.titleLabel!.fontItalic)
                break
            default:
                break
            }
        }
        
        UIButtonTemp.equalTarget = nil
    }
    
    public func equalTo(_ property: ButtonEqualProperty) {
        UIButtonTemp.equalToProperty = property
    }
    
    public func buttonTarget(_ view: UIView) {
        let button: UIButton = view as! UIButton
        if UIButtonTemp.equalProperty != .none {
            switch UIButtonTemp.equalProperty {
            case .textAlignment:
                self.titleLabel?.textAlignment = button.titleLabel!.textAlignment
                break
            case .font:
                self.titleLabel?.font = button.titleLabel?.font
                break
            case .bold:
                self.titleLabel?.fontBold(button.titleLabel!.fontBold)
                break
            case .italic:
                self.titleLabel?.fontItalic(button.titleLabel!.fontItalic)
                break
            default:
                break
            }
            UIButtonTemp.equalProperty = .none
        } else {
            UIButtonTemp.equalTarget = view
        }
        
        if UIButtonTemp.equalToProperty != .none {
            switch UIButtonTemp.equalToProperty {
            case .textAlignment:
                button.titleLabel?.textAlignment = self.titleLabel!.textAlignment
                break
            case .font:
                button.titleLabel?.font = self.titleLabel?.font
                break
            case .bold:
                button.titleLabel?.fontBold(self.titleLabel!.fontBold)
                break
            case .italic:
                button.titleLabel?.fontItalic(self.titleLabel!.fontItalic)
                break
            default:
                break
            }
            UIButtonTemp.equalToProperty = .none
        }
    }
    
    public func buttonTargets(_ views: Array<UIView>) {
        for currentView: UIView in views {
            let button: UIButton = currentView as! UIButton
            
            if UIButtonTemp.equalToProperty != .none {
                switch UIButtonTemp.equalToProperty {
                case .textAlignment:
                    button.titleLabel?.textAlignment = self.titleLabel!.textAlignment
                    break
                case .font:
                    button.titleLabel?.font = self.titleLabel?.font
                    break
                case .bold:
                    button.titleLabel?.fontBold(self.titleLabel!.fontBold)
                    break
                case .italic:
                    button.titleLabel?.fontItalic(self.titleLabel!.fontItalic)
                    break
                default:
                    break
                }
            }
        }
        
        UIButtonTemp.equalToProperty = .none
    }
    //按枚举将 btn 的 image 和 title 之间位置处理
    public func imageAndTitlePadding(padding: CGFloat = 10, style: ImageAndTitlePossitionStyle = .imageDefault) {
        let imageRect: CGRect = self.imageView?.frame ?? CGRect.init()
        let titleRect: CGRect = self.titleLabel?.frame ?? CGRect.init()
        let selfWidth: CGFloat = self.frame.size.width
        let selfHeight: CGFloat = self.frame.size.height
        let totalHeight = titleRect.size.height + padding + imageRect.size.height
        switch style {
        case .imageLeft:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: padding / 2, bottom: 0, right: -padding / 2)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -padding / 2, bottom: 0, right: padding / 2)
        case .imageRight:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.size.width + padding/2), bottom: 0, right: (imageRect.size.width + padding/2))
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: (titleRect.size.width + padding / 2), bottom: 0, right: -(titleRect.size.width +  padding/2))
        case .imageTop :
            self.titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y), left: (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2, bottom: -((selfHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y), right: -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
            self.imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 - imageRect.origin.y), left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), bottom: -((selfHeight - totalHeight) / 2 - imageRect.origin.y), right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
        case .imgageBottom:
            self.titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 - titleRect.origin.y), left: (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2, bottom: -((selfHeight - totalHeight) / 2 - titleRect.origin.y), right: -(selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
            self.imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y), left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), bottom: -((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y), right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
        default:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    public func addTouchDown(_ target: Any?, selector: Selector) {
        addTarget(target, action: selector, for: .touchDown)
    }
    
    public func removeTouchDown(_ target: Any?, selector: Selector) {
        removeTarget(target, action: selector, for: .touchDown)
    }
    
    public func addTouchDownRepeat(_ target: Any?, selector: Selector) {
        addTarget(target, action: selector, for: .touchDownRepeat)
    }
    
    public func removeTouchDownRepeat(_ target: Any?, selector: Selector) {
        removeTarget(target, action: selector, for: .touchDownRepeat)
    }
    
    public func addTouchDragInside(_ target: Any?, selector: Selector) {
        addTarget(target, action: selector, for: .touchDragInside)
    }
    
    public func removeTouchDragInside(_ target: Any?, selector: Selector) {
        removeTarget(target, action: selector, for: .touchDragInside)
    }
    
    public func addTouchDragOutside(_ target: Any?, selector: Selector) {
        addTarget(target, action: selector, for: .touchDragOutside)
    }
    
    public func removeTouchDragOutside(_ target: Any?, selector: Selector) {
        removeTarget(target, action: selector, for: .touchDragOutside)
    }
    
    public func addTouchDragEnter(_ target: Any?, selector: Selector) {
        addTarget(target, action: selector, for: .touchDragEnter)
    }
    
    public func removeTouchDragEnter(_ target: Any?, selector: Selector) {
        removeTarget(target, action: selector, for: .touchDragEnter)
    }
    
    public func addTouchDragExit(_ target: Any?, selector: Selector) {
        addTarget(target, action: selector, for: .touchDragExit)
    }
    
    public func removeTouchDragExit(_ target: Any?, selector: Selector) {
        removeTarget(target, action: selector, for: .touchDragExit)
    }
    
    public func addTouchUpInside(_ target: Any?, selector: Selector) {
        addTarget(target, action: selector, for: .touchUpInside)
    }
    
    public func removeTouchUpInside(_ target: Any?, selector: Selector) {
        removeTarget(target, action: selector, for: .touchUpInside)
    }
    
    public func addTouchUpOutside(_ target: Any?, selector: Selector) {
        addTarget(target, action: selector, for: .touchUpOutside)
    }
    
    public func removeTouchUpOutside(_ target: Any?, selector: Selector) {
        removeTarget(target, action: selector, for: .touchUpOutside)
    }
    
    public func addTouchCancel(_ target: Any?, selector: Selector) {
        addTarget(target, action: selector, for: .touchCancel)
    }
    
    public func removeTouchCancel(_ target: Any?, selector: Selector) {
        removeTarget(target, action: selector, for: .touchCancel)
    }
    
    override public
    func styleDesign(_ design: any DesignStyleProtocol) {
        super.styleDesign(design)
        
        if design.backgroundImage != nil {
            setBackgroundImage(design.backgroundImage as? UIImage, for: .normal)
        }
        
        if design.normalImage != nil {
            setImage(design.normalImage as? UIImage, for: .normal)
        }
        
        if design.highlightedImage != nil {
            setImage(design.highlightedImage as? UIImage, for: .highlighted)
        }
        
        if design.normalTitle != nil {
            setTitle(design.normalTitle as? String, for: .normal)
        }
        
        if design.highlightedTitle != nil {
            setTitle(design.highlightedTitle as? String, for: .highlighted)
        }
        
        if design.imageEdgeInsets != nil {
            imageEdgeInsets = design.imageEdgeInsets as! UIEdgeInsets
        }
        
        if design.titleFont != nil {
            titleLabel?.font = design.titleFont as? UIFont
        }
        
        if design.imageAndTitlePadding != nil {
            imageAndTitlePadding(style: design.imageAndTitlePadding as! ImageAndTitlePossitionStyle)
        }
    }
    /// 添加液态玻璃效果
    ///
    /// __示例:__
    ///
    /// ```swift
    /// let button: UIButton = A.ui.button
    /// var config: UIButton.Configuration = UIButton.Configuration.glass()
    /// config.title = "test"
    /// button.liquid(config)
    /// ```
    ///
    /// - Parameter config: 配置
    public func liquid(_ config: UIButton.Configuration) {
        self.configuration = config
    }
    /// 添加液态玻璃效果
    ///
    /// __示例：__
    ///
    /// ```swift
    /// let button: UIButton = A.ui.button
    /// button.liguid(type: .glass, title: "test")
    /// ```
    ///
    /// - Parameters:
    ///   - type: 液态玻璃类型
    ///   - title: 标题
    ///   - attributedTitle: 富文本形式标题
    ///   - subtitle: 子标题
    ///   - attributedSubtitle: 富文本形式子标题
    ///   - titlePadding: 标题间距
    ///   - titleAlignment: 标题对齐方式
    ///   - image: 图片
    ///   - imagePadding: 图片间距
    ///   - baseForegroundColor: 前景色
    ///   - baseBackgroundColor: 背景色
    /// - Returns: UIButton
    public func liquid(
        type: LiquidGlassType,
        title: String?=nil,
        attributedTitle: AttributedString?=nil,
        subtitle: String?=nil,
        attributedSubtitle: AttributedString?=nil,
        titlePadding: CGFloat?=nil,
        titleAlignment:UIButton.Configuration.TitleAlignment?=nil,
        image: UIImage?=nil,
        imagePadding: CGFloat?=nil,
        baseForegroundColor: UIColor?=nil,
        baseBackgroundColor: UIColor?=nil) {
        if #available(iOS 26.0, *) {
            if type == .glass {
                liquid_Glass(
                    title: title,
                    attributedTitle: attributedTitle,
                    subtitle: subtitle,
                    attributedSubtitle: attributedSubtitle,
                    titlePadding: titlePadding,
                    titleAlignment: titleAlignment,
                    image: image,
                    imagePadding: imagePadding,
                    baseForegroundColor: baseForegroundColor,
                    baseBackgroundColor: baseBackgroundColor
                )
            } else if type == .clearGlass {
                liquid_ClearGlass(
                    title: title,
                    attributedTitle: attributedTitle,
                    subtitle: subtitle,
                    attributedSubtitle: attributedSubtitle,
                    titlePadding: titlePadding,
                    titleAlignment: titleAlignment,
                    image: image,
                    imagePadding: imagePadding,
                    baseForegroundColor: baseForegroundColor,
                    baseBackgroundColor: baseBackgroundColor
                )
            } else if type == .prominentGlass {
                liquid_ProminentGlass(
                    title: title,
                    attributedTitle: attributedTitle,
                    subtitle: subtitle,
                    attributedSubtitle: attributedSubtitle,
                    titlePadding: titlePadding,
                    titleAlignment: titleAlignment,
                    image: image,
                    imagePadding: imagePadding,
                    baseForegroundColor: baseForegroundColor,
                    baseBackgroundColor: baseBackgroundColor
                )
            } else if type == .prominentClearGlass {
                liquid_ProminentClearGlass(
                    title: title,
                    attributedTitle: attributedTitle,
                    subtitle: subtitle,
                    attributedSubtitle: attributedSubtitle,
                    titlePadding: titlePadding,
                    titleAlignment: titleAlignment,
                    image: image,
                    imagePadding: imagePadding,
                    baseForegroundColor: baseForegroundColor,
                    baseBackgroundColor: baseBackgroundColor
                )
            }
        }
    }
    /// 添加液态玻璃效果
    ///
    /// __示例：__
    ///
    /// ```swift
    /// let type: LiquidGlassType = .glass
    /// let config: [LiquidGlassConfig: Any] = [
    ///     title : "test"
    /// ]
    /// let button: UIButton = A.ui.button
    /// button.liquid(type, config)
    /// ```
    ///
    /// - Parameters:
    ///   - type: 液态玻璃类型
    ///   - config: 配置
    public func liquid(type: LiquidGlassType, config: [LiquidGlassConfig : Any]?=nil) {
        if #available(iOS 26.0, *) {
            if type == .glass {
                var glassConfig: UIButton.Configuration = UIButton.Configuration.glass()
                
                if config != nil {
                    setupLiquidConfig(glassConfig: &glassConfig, config: config!)
                }
            } else if type == .clearGlass {
                var glassConfig: UIButton.Configuration = UIButton.Configuration.clearGlass()
                
                if config != nil {
                    setupLiquidConfig(glassConfig: &glassConfig, config: config!)
                }
            } else if type == .prominentGlass {
                var glassConfig: UIButton.Configuration = UIButton.Configuration.prominentGlass()
                
                if config != nil {
                    setupLiquidConfig(glassConfig: &glassConfig, config: config!)
                }
            } else if type == .prominentClearGlass {
                var glassConfig: UIButton.Configuration = UIButton.Configuration.prominentClearGlass()
                
                if config != nil {
                    setupLiquidConfig(glassConfig: &glassConfig, config: config!)
                }
            }
        }
    }
    
    private func setupLiquidConfig(glassConfig: inout UIButton.Configuration, config: [LiquidGlassConfig : Any]) {
        if #available(iOS 26.0, *) {
            if config[LiquidGlassConfig.title] != nil {
                glassConfig.title = config[LiquidGlassConfig.title] as? String
            }
            
            if config[LiquidGlassConfig.attributedTitle] != nil {
                glassConfig.attributedTitle = config[LiquidGlassConfig.attributedTitle] as? AttributedString
            }
            
            if config[LiquidGlassConfig.subtitle] != nil {
                glassConfig.subtitle = config[LiquidGlassConfig.subtitle] as? String
            }
            
            if config[LiquidGlassConfig.attributedSubtitle] != nil {
                glassConfig.attributedSubtitle = config[LiquidGlassConfig.attributedSubtitle] as? AttributedString
            }
            
            if config[LiquidGlassConfig.titlePadding] != nil {
                glassConfig.titlePadding = config[LiquidGlassConfig.titlePadding] as! CGFloat
            }
            
            if config[LiquidGlassConfig.titleAlignment] != nil {
                glassConfig.titleAlignment = config[LiquidGlassConfig.titleAlignment] as! UIButton.Configuration.TitleAlignment
            }
            
            if config[LiquidGlassConfig.image] != nil {
                glassConfig.image = config[LiquidGlassConfig.image] as? UIImage
            }
            
            if config[LiquidGlassConfig.imagePadding] != nil {
                glassConfig.imagePadding = config[LiquidGlassConfig.imagePadding] as! CGFloat
            }
            
            if config[LiquidGlassConfig.baseForegroundColor] != nil {
                glassConfig.baseForegroundColor = config[LiquidGlassConfig.baseForegroundColor] as? UIColor
            }
            
            if config[LiquidGlassConfig.baseBackgroundColor] != nil {
                glassConfig.baseBackgroundColor = config[LiquidGlassConfig.baseBackgroundColor] as? UIColor
            }
            
            self.configuration = glassConfig
        }
    }
    /// 添加Glass类型液态玻璃效果
    ///
    /// __示例：__
    ///
    /// ```swift
    /// let button: UIButton = A.ui.button
    /// button.liguid_Glass(title: "test")
    /// ```
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - attributedTitle: 富文本形式标题
    ///   - subtitle: 子标题
    ///   - attributedSubtitle: 富文本形式子标题
    ///   - titlePadding: 标题间距
    ///   - titleAlignment: 标题对齐方式
    ///   - image: 图片
    ///   - imagePadding: 图片间距
    ///   - baseForegroundColor: 前景色
    ///   - baseBackgroundColor: 背景色
    public func liquid_Glass(
        title: String?=nil,
        attributedTitle: AttributedString?=nil,
        subtitle: String?=nil,
        attributedSubtitle: AttributedString?=nil,
        titlePadding: CGFloat?=nil,
        titleAlignment:UIButton.Configuration.TitleAlignment?=nil,
        image: UIImage?=nil,
        imagePadding: CGFloat?=nil,
        baseForegroundColor: UIColor?=nil,
        baseBackgroundColor: UIColor?=nil) {
        if #available(iOS 26.0, *) {
            var glassConfig = UIButton.Configuration.glass()
            if title != nil {
                glassConfig.title = title!
            }
            if attributedTitle != nil {
                glassConfig.attributedTitle = attributedTitle!
            }
            if subtitle != nil {
                glassConfig.subtitle = subtitle!
            }
            if attributedSubtitle != nil {
                glassConfig.attributedSubtitle = attributedSubtitle!
            }
            if titlePadding != nil {
                glassConfig.titlePadding = titlePadding!
            }
            if titleAlignment != nil {
                glassConfig.titleAlignment = titleAlignment!
            }
            if image != nil {
                glassConfig.image = image!
            }
            if imagePadding != nil {
                glassConfig.imagePadding = imagePadding!
            }
            if baseForegroundColor != nil {
                glassConfig.baseForegroundColor = baseForegroundColor!
            }
            if baseBackgroundColor != nil {
                glassConfig.baseBackgroundColor = baseBackgroundColor!
            }
            self.configuration = glassConfig
        }
    }
    /// 添加Glass类型液态玻璃效果
    ///
    /// __示例：__
    ///
    /// ```swift
    /// let config: [LiquidGlassConfig : Any] = [
    ///     .title : "test"
    /// ]
    /// let button: UIButton = A.ui.button
    /// button.liquid_Glass(config)
    /// ```
    ///
    /// - Parameter config: 配置
    public func liquid_Glass(_ config: [LiquidGlassConfig : Any]?=nil) {
        if #available(iOS 26.0, *) {
            var glassConfig = UIButton.Configuration.glass()
            if config != nil {
                setupLiquidConfig(glassConfig: &glassConfig, config: config!)
            }
            self.configuration = glassConfig
        }
    }
    /// 添加clearGlass类型液态玻璃效果
    ///
    /// __示例：__
    ///
    /// ```swift
    /// let button: UIButton = A.ui.button
    /// button.liguid_ClearGlass(title: "test")
    /// ```
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - attributedTitle: 富文本形式标题
    ///   - subtitle: 子标题
    ///   - attributedSubtitle: 富文本形式子标题
    ///   - titlePadding: 标题间距
    ///   - titleAlignment: 标题对齐方式
    ///   - image: 图片
    ///   - imagePadding: 图片间距
    ///   - baseForegroundColor: 前景色
    ///   - baseBackgroundColor: 背景色
    /// - Returns: UIButton
    public func liquid_ClearGlass(
        title: String?=nil,
        attributedTitle: AttributedString?=nil,
        subtitle: String?=nil,
        attributedSubtitle: AttributedString?=nil,
        titlePadding: CGFloat?=nil,
        titleAlignment:UIButton.Configuration.TitleAlignment?=nil,
        image: UIImage?=nil,
        imagePadding: CGFloat?=nil,
        baseForegroundColor: UIColor?=nil,
        baseBackgroundColor: UIColor?=nil) {
        if #available(iOS 26.0, *) {
            var glassConfig = UIButton.Configuration.clearGlass()
            if title != nil {
                glassConfig.title = title!
            }
            if attributedTitle != nil {
                glassConfig.attributedTitle = attributedTitle!
            }
            if subtitle != nil {
                glassConfig.subtitle = subtitle!
            }
            if attributedSubtitle != nil {
                glassConfig.attributedSubtitle = attributedSubtitle!
            }
            if titlePadding != nil {
                glassConfig.titlePadding = titlePadding!
            }
            if titleAlignment != nil {
                glassConfig.titleAlignment = titleAlignment!
            }
            if image != nil {
                glassConfig.image = image!
            }
            if imagePadding != nil {
                glassConfig.imagePadding = imagePadding!
            }
            if baseForegroundColor != nil {
                glassConfig.baseForegroundColor = baseForegroundColor!
            }
            if baseBackgroundColor != nil {
                glassConfig.baseBackgroundColor = baseBackgroundColor!
            }
            self.configuration = glassConfig
        }
    }
    /// 添加clearGlass类型液态玻璃效果
    ///
    /// __示例：__
    ///
    /// ```swift
    /// let config: [LiquidGlassConfig : Any] = [
    ///     .title : "test"
    /// ]
    /// let button: UIButton = A.ui.button
    /// button.liquid_ClearGlass(config)
    /// ```
    ///
    /// - Parameter config: 配置
    public func liquid_ClearGlass(_ config: [LiquidGlassConfig : Any]?=nil) {
        if #available(iOS 26.0, *) {
            var glassConfig = UIButton.Configuration.clearGlass()
            if config != nil {
                setupLiquidConfig(glassConfig: &glassConfig, config: config!)
            }
            self.configuration = glassConfig
        }
    }
    /// 添加prominentGlass类型液态玻璃效果
    ///
    /// __示例：__
    ///
    /// ```swift
    /// let button: UIButton = A.ui.button
    /// button.liquid_ProminentGlass(title: "test")
    /// ```
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - attributedTitle: 富文本形式标题
    ///   - subtitle: 子标题
    ///   - attributedSubtitle: 富文本形式子标题
    ///   - titlePadding: 标题间距
    ///   - titleAlignment: 标题对齐方式
    ///   - image: 图片
    ///   - imagePadding: 图片间距
    ///   - baseForegroundColor: 前景色
    ///   - baseBackgroundColor: 背景色
    public func liquid_ProminentGlass(
        title: String?=nil,
        attributedTitle: AttributedString?=nil,
        subtitle: String?=nil,
        attributedSubtitle: AttributedString?=nil,
        titlePadding: CGFloat?=nil,
        titleAlignment:UIButton.Configuration.TitleAlignment?=nil,
        image: UIImage?=nil,
        imagePadding: CGFloat?=nil,
        baseForegroundColor: UIColor?=nil,
        baseBackgroundColor: UIColor?=nil) {
        if #available(iOS 26.0, *) {
            var glassConfig = UIButton.Configuration.prominentGlass()
            if title != nil {
                glassConfig.title = title!
            }
            if attributedTitle != nil {
                glassConfig.attributedTitle = attributedTitle!
            }
            if subtitle != nil {
                glassConfig.subtitle = subtitle!
            }
            if attributedSubtitle != nil {
                glassConfig.attributedSubtitle = attributedSubtitle!
            }
            if titlePadding != nil {
                glassConfig.titlePadding = titlePadding!
            }
            if titleAlignment != nil {
                glassConfig.titleAlignment = titleAlignment!
            }
            if image != nil {
                glassConfig.image = image!
            }
            if imagePadding != nil {
                glassConfig.imagePadding = imagePadding!
            }
            if baseForegroundColor != nil {
                glassConfig.baseForegroundColor = baseForegroundColor!
            }
            if baseBackgroundColor != nil {
                glassConfig.baseBackgroundColor = baseBackgroundColor!
            }
            self.configuration = glassConfig
        }
    }
    /// 添加prominentGlass类型液态玻璃效果
    ///
    /// __示例：__
    ///
    /// ```swift
    /// let config: [LiquidGlassConfig : Any] = [
    ///     .title : "test"
    /// ]
    /// let button: UIButton = A.ui.button
    /// button.liquid_ProminentGlass(config)
    /// ```
    ///
    /// - Parameter config: 配置
    public func liquid_ProminentGlass(_ config: [LiquidGlassConfig : Any]?=nil) {
        if #available(iOS 26.0, *) {
            var glassConfig = UIButton.Configuration.prominentGlass()
            if config != nil {
                setupLiquidConfig(glassConfig: &glassConfig, config: config!)
            }
            self.configuration = glassConfig
        }
    }
    /// 添加prominentClearGlass类型液态玻璃效果
    ///
    /// __示例：__
    ///
    /// ```swift
    /// let button: UIButton = A.ui.button
    /// button.liquid_ProminentClearGlass(title: "test")
    /// ```
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - attributedTitle: 富文本形式标题
    ///   - subtitle: 子标题
    ///   - attributedSubtitle: 富文本形式子标题
    ///   - titlePadding: 标题间距
    ///   - titleAlignment: 标题对齐方式
    ///   - image: 图片
    ///   - imagePadding: 图片间距
    ///   - baseForegroundColor: 前景色
    ///   - baseBackgroundColor: 背景色
    public func liquid_ProminentClearGlass(
        title: String?=nil,
        attributedTitle: AttributedString?=nil,
        subtitle: String?=nil,
        attributedSubtitle: AttributedString?=nil,
        titlePadding: CGFloat?=nil,
        titleAlignment:UIButton.Configuration.TitleAlignment?=nil,
        image: UIImage?=nil,
        imagePadding: CGFloat?=nil,
        baseForegroundColor: UIColor?=nil,
        baseBackgroundColor: UIColor?=nil) {
        if #available(iOS 26.0, *) {
            var glassConfig = UIButton.Configuration.prominentClearGlass()
            if title != nil {
                glassConfig.title = title!
            }
            if attributedTitle != nil {
                glassConfig.attributedTitle = attributedTitle!
            }
            if subtitle != nil {
                glassConfig.subtitle = subtitle!
            }
            if attributedSubtitle != nil {
                glassConfig.attributedSubtitle = attributedSubtitle!
            }
            if titlePadding != nil {
                glassConfig.titlePadding = titlePadding!
            }
            if titleAlignment != nil {
                glassConfig.titleAlignment = titleAlignment!
            }
            if image != nil {
                glassConfig.image = image!
            }
            if imagePadding != nil {
                glassConfig.imagePadding = imagePadding!
            }
            if baseForegroundColor != nil {
                glassConfig.baseForegroundColor = baseForegroundColor!
            }
            if baseBackgroundColor != nil {
                glassConfig.baseBackgroundColor = baseBackgroundColor!
            }
            self.configuration = glassConfig
        }
    }
    /// 添加prominentClearGlass类型液态玻璃效果
    ///
    /// __示例：__
    ///
    /// ```swift
    /// let config: [LiquidGlassConfig : Any] = [
    ///     .title : "test"
    /// ]
    /// let button: UIButton = A.ui.button
    /// button.liquid_ProminentClearGlass(config)
    /// ```
    ///
    /// - Parameter config: 配置
    /// - Returns: UIButton
    public func liquid_ProminentClearGlass(_ config: [LiquidGlassConfig : Any]?=nil) {
        if #available(iOS 26.0, *) {
            var glassConfig = UIButton.Configuration.prominentClearGlass()
            if config != nil {
                setupLiquidConfig(glassConfig: &glassConfig, config: config!)
            }
            self.configuration = glassConfig
        }
    }
}
