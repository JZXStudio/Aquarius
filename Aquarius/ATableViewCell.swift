//
//  ATableViewCell.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/15.
//

import UIKit
import Foundation
/// tableViewCell的基类
///
/// 主要包括：
/// + 分层管理
/// + 热更新管理
open class ATableViewCell: UITableViewCell, ANotificationDelegate {
    private var notification: ANotification?
    /// cell的高度
    ///
    /// __需要手动设置，设置后在其它类中使用__
    public static var cellHeight: CGFloat?
    /// 间距
    ///
    /// __需要手动设置，设置后在其它类中使用__
    public var a_inset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    deinit {
        notification?.delegate = nil
        
        a_Clear()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.notification = ANotification(notifications: [AThemeStyle.kNotification_UpdateThemeStyle])
        self.notification?.delegate = self
        
        self.a_Preview()
        self.a_Begin()
        
        self.a_UI()
        self.a_UIConfig()
        self.a_Layout()
        self.updateThemeStyle()
        self.a_Notification()
        self.a_Delegate()
        self.a_Observe()
        self.a_Bind()
        self.a_Event()
        self.a_Other()
        self.a_End()
        self.a_Inject()
    }
    /// 开始之前执行的方法
    ///
    /// 示例：
    ///
    /// __TestCell.swift__
    ///
    /// ```swift
    /// class TestCell: ATableViewCell {
    ///     override func a_Preview() {
    ///         super.a_Preview()
    ///
    ///         printLog("a_Preview")
    ///     }
    /// }
    /// ```
    open func a_Preview() {}
    /// 开始时执行的方法
    ///
    /// 示例：
    ///
    /// __TestCell.swift__
    ///
    /// ```swift
    /// class TestCell: ATableViewCell {
    ///     override func a_Begin() {
    ///         super.a_Begin()
    ///
    ///         printLog("a_Begin")
    ///     }
    /// }
    /// ```
    open func a_Begin() {}
    /// 页面销毁时执行的方法
    ///
    /// 示例：
    ///
    /// __TestCell.swift__
    ///
    /// ```swift
    /// class TestCell: ATableViewCell {
    ///     override func a_Clear() {
    ///         super.a_Clear()
    ///
    ///         printLog("a_Clear")
    ///     }
    /// }
    /// ```
    open func a_Clear() {
        self.clearBind()
        
        self.notification?.clearNotifications()
        self.notification?.delegate = nil
    }
    /// 设置UI的方法
    ///
    /// __在此方法中完成UI控件的加载__
    ///
    /// 示例：
    ///
    /// __TestCell.swift__
    ///
    /// ```swift
    /// class TestCell: ATableViewCell {
    ///     private let testLabel: UILabel = A.ui.label
    ///     private let testButton: UIButton = A.ui.button
    ///
    ///     override func a_UI() {
    ///         super.a_UI()
    ///
    ///         addSubviewsInContentView(views: [
    ///             testLabel,
    ///             testButton
    ///         ])
    ///     }
    /// }
    /// ```
    open func a_UI() {}
    /// 设置各UI控件的方法
    ///
    /// __在此方法中完成各UI控件的设置__
    ///
    /// 示例：
    ///
    /// __TestCell.swift__
    ///
    /// ```swift
    /// class TestCell: ATableViewCell {
    ///     private let testLabel: UILabel = A.ui.label
    ///     private let testButton: UIButton = A.ui.button
    ///
    ///     override func a_UIConfig() {
    ///         super.a_UIConfig()
    ///
    ///         testLabel
    ///             .backgroundColor(0xFFFFFF.a_color)
    ///
    ///         testButton
    ///             .backgroundColor(0xFFFFFF.a_color)
    ///     }
    /// }
    /// ```
    open func a_UIConfig() {}
    /// 设置各UI控件布局的方法
    ///
    /// __在此方法中完成各UI控件的布局__
    ///
    /// 示例：
    ///
    /// __TestCell.swift__
    ///
    /// ```swift
    /// class TestCell: ATableViewCell {
    ///     private let testLabel: UILabel = A.ui.label
    ///     private let testButton: UIButton = A.ui.button
    ///
    ///     override func a_Layout() {
    ///         super.a_Layout()
    ///
    ///         testLabel.size([a_view.screenWidth, 500])
    ///         testLabel.a_left(left: 0, offset: 8.0)
    ///         testLabel.equalZeroTop()
    ///
    ///         testButton.size([a_view.screenWidth, 500])
    ///         testButton.equalleft(target: testLabel)
    ///         testButton.alignTop(view: testLabel, offset: 8.0)
    ///     }
    /// }
    /// ```
    open func a_Layout() {}
    /// 设置通知的方法
    ///
    /// __在此方法中完成通知设置__
    ///
    /// __通过<doc:addNotification(notificationName:)>或者<doc:addNotification(notificationNames:)>方法完成通知的设置将在页面销毁时自动销毁，无需手动销毁__
    ///
    /// 示例：
    ///
    /// __TestCell.swift__
    ///
    /// ```swift
    /// class TestCell: ATableViewCell {
    ///     override func a_Notification() {
    ///         super.a_Notification()
    ///
    ///         addNotification(notificationName: "notificationID")
    ///     }
    /// }
    /// ```
    open func a_Notification() {}
    /// 设置Delegate的方法
    ///
    /// __在此方法中完成Delegate设置__
    ///
    /// 示例：
    ///
    /// __TestCell.swift__
    ///
    /// ```swift
    /// class TestCell: ATableViewCell {
    ///     private let testLabel: UILabel = A.ui.label
    ///
    ///     override func a_Delegate() {
    ///         super.a_Delegate()
    ///
    ///         testLabel.delegate = self
    ///     }
    /// }
    /// ```
    open func a_Delegate() {}
    /// 设置Observe的方法
    ///
    /// 示例：
    ///
    /// __TestCell.swift__
    ///
    /// ```swift
    /// class TestCell: ATableViewCell {
    ///     @objc dynamic
    ///     public var observeTag_RefreshData: Bool = false
    ///
    ///     override func a_Observe() {
    ///         super.a_Observe()
    ///
    ///         observe(\.observeTag_RefreshData,
    ///             options: .new,
    ///             changeHandler: { [weak self] (object, change) in
    ///                 if change.newValue! as Bool {
    ///                     printLog("observe")
    ///                 }
    ///             }
    ///     }
    /// }
    open func a_Observe() {}
    /// 设置数据绑定的方法
    ///
    /// __在此方法中完成数据绑定设置__
    open func a_Bind() {}
    /// 设置Event事件的方法
    ///
    /// 示例：
    ///
    /// __TestCell.swift__
    ///
    /// ```swift
    /// class TestCell: ATableViewCell {
    ///     private let testButton: UIButton = A.ui.button
    ///
    ///     override func a_Event() {
    ///         super.a_Event()
    ///
    ///         testButton.addEventBlock(.touchUpInside) { [weak self] control in
    ///             self?.printLog("testButton click")
    ///       }
    ///     }
    /// }
    /// ```
    open func a_Event() {}
    /// 额外的一些页面设置在此方法中完成
    open func a_Other() {}
    /// 结尾的一些页面设置在此方法中完成
    open func a_End() {}
    /// 热更新代码，在此方法中执行
    ///
    /// __此方法依赖injectIII工具__
    ///
    /// __此方法只在测试时调用，发布后不会调用此方法中的代码__
    open func a_Inject() {
        layoutSubviews()
    }
    /// 获取顶层viewController
    /// - Returns: viewController
    public func topViewController() -> UIViewController? {
        var keyWindow: UIWindow?

        if #available(iOS 13.0, *) {
            keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }

        var viewController = keyWindow?.rootViewController
        while (viewController?.presentedViewController != nil) {
            viewController = viewController?.presentedViewController
        }
        return viewController
    }
    /// 主题更新的代码在此方法中完成
    ///
    /// __当普通模式和深色模式切换时，此方法将自动调用__
    open func updateThemeStyle() {}
    /// 更新cell
    ///
    /// 此方法在tableView的cellForRowAt函数回调中使用
    ///
    /// 在configWithCell中需手动转换值
    ///
    /// 示例：
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    ///     let cell = (tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath))as! TestCell
    ///
    ///     let testValue: Bool = false
    ///     cell.configWithCell(cellData: testValue)
    ///
    ///     return cell
    /// }
    /// ```
    ///
    /// __TestCell.swift__
    ///
    /// ```swift
    /// class TestCell: ATableViewCell {
    ///     override func configWithCell(cellData: Any) {
    ///         let value: Bool = cellData as! Bool
    ///         printLog("\(value)")
    ///     }
    /// }
    /// ```
    /// - Parameter cellData: 更新cell传递的值
    open func configWithCell(cellData: Any) {}
    /// 将UI控件加入到contentView中
    /// - Parameter view: 加入的UI控件
    public func addSubviewInContentView(view: UIView) {
        contentView.addSubview(view)
    }
    /// 将UI控件从contentView中删除
    /// - Parameter view: 删除的UI控件
    public func removeSubviewInContentView(view: UIView) {
        view.removeFromSuperview()
    }
    /// 将多个UI控件加入到contentView中
    /// - Parameter views: 加入的UI控件数组
    public func addSubviewsInContentView(views: Array<UIView>) {
        contentView.addSubviews(views: views)
    }
    /// 将多个UI控件从contentView中删除
    /// - Parameter views: 删除的UI控件数组
    public func removeSubviewsInContentView(views: Array<UIView>) {
        contentView.removeSubviews(views: views)
    }
    /// 添加多个通知
    /// - Parameter notificationNames: 通知ID数组
    public func addNotification(notificationNames: Array<String>) {
        notification?.addNotifications(notificationNames: notificationNames)
    }
    /// 添加通知
    /// - Parameter notificationName: 通知ID
    public func addNotification(notificationName: String) {
        notification?.addNotification(notificationName: notificationName)
    }
    /// 通知的回调方法
    /// - Parameter notification: 通知
    open func ANotificationReceive(notification: Notification) {
        if notification.name.rawValue == AThemeStyle.kNotification_UpdateThemeStyle {
            self.updateThemeStyle()
        }
    }
    //MARK: - Inject
    /// 热更新时调用的代码在此方法中实现
    ///
    /// __此方法依赖InjectIII工具__
    @objc open
    func injected()  {
        A.DEBUG { [weak self] in
            self?.a_Inject()
        }
    }
}
