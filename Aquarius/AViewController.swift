//
//  AViewController.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/6/18.
//

import UIKit
import Foundation
/// 导航条按钮类型
public enum BarButtonType
{
    case text
    case image
    case custom
}
/// viewController的基类（MVVM）
///
/// 主要包括：
/// + 埋点
/// + 导航条管理
/// + 分层管理
/// + 主题管理
/// + 日志管理
/// + 热更新管理
open class AViewController: UIViewController, ANotificationDelegate {
    internal let logger: ALogger = ALogger()
    /// 用于判断弹出的模态是present，还是push
    open var isPresent: Bool = false
    /// 埋点的ID（一般在页面上需要覆盖这个变量）
    ///
    /// 可以给类似友盟一样的统计网站使用
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override var analyticsID: String? {
    ///     get {
    ///         return "test"
    ///     }
    ///     set {
    ///         super.analyticsID = "test"
    ///     }
    /// }
    /// ```
    open var analyticsID: String? = nil
    /// 左侧按钮类型
    public var navigation_LeftBarButtonType: BarButtonType?
    /// 右侧按钮类型
    public var navigation_RightBarButtonType: BarButtonType?
    
    internal var leftBarButtonClickBlock: (() -> Void)?
    internal var rightBarButtonClickBlock: (() -> Void)?
    /// 导航条-标题
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     self.navigation_Title = "标题"
    /// }
    /// ```
    @objc dynamic public var navigation_Title: String = "" {
        willSet {
            navigationItem.title = newValue
        }
    }
    /// 导航条-标题的view
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     let titleView: UIView = A.ui.view
    ///
    ///     self.navigation_TitleView = titleView
    /// }
    /// ```
    public var navigation_TitleView: UIView? {
        willSet {
            navigationItem.titleView = newValue
            
            navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        }
    }
    /// 导航条-左侧按钮
    ///
    /// 设置此选项后，左侧按钮将变为按钮模式
    ///
    /// 此属性与下列属性冲突，不能同时设置
    ///
    /// + <doc:navigation_LeftBarButtonText>
    /// + <doc:navigation_LeftBarButtonText(_:)>
    /// + <doc:navigation_LeftBarButtonImage>
    /// + <doc:navigation_LeftBarButtonImage(_:)>
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     let button: UIButton = A.ui.button
    ///
    ///     self.navigation_LeftBarButton = button
    /// }
    /// ```
    public var navigation_LeftBarButton: UIButton? {
        willSet {
            let item = UIBarButtonItem(customView: newValue!)
            navigationItem.leftBarButtonItem = item
            
            navigation_LeftBarButtonType = .custom
        }
    }
    /// 导航条-左侧按钮的文本
    ///
    /// 设置此选项后，左侧按钮将变为文本模式
    ///
    /// 此属性与下列属性冲突，不能同时设置
    ///
    /// + <doc:navigation_LeftBarButton>
    /// + <doc:navigation_LeftBarButton(_:)>
    /// + <doc:navigation_LeftBarButtonImage>
    /// + <doc:navigation_LeftBarButtonImage(_:)>
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     self.navigation_LeftBarButtonText = "Test"
    /// }
    /// ```
    public var navigation_LeftBarButtonText: String? {
        willSet {
            let item = UIBarButtonItem(title: newValue, style: .plain, target: self, action: navigation_LeftBarButtonAction ?? nil)
            navigationItem.leftBarButtonItem = item
            
            navigation_LeftBarButtonType = .text
        }
    }
    /// 导航条-左侧按钮的图片
    ///
    /// 设置此选项后，左侧按钮将变为图片模式
    ///
    /// 此属性与下列属性冲突，不能同时设置
    ///
    /// + <doc:navigation_LeftBarButton>
    /// + <doc:navigation_LeftBarButton(_:)>
    /// + <doc:navigation_LeftBarButtonText>
    /// + <doc:navigation_LeftBarButtonText(_:)>
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     let image: UIImage = UIImage(systemName: "xmark")
    ///
    ///     self.navigation_LeftBarButtonImage = image
    /// }
    /// ```
    public var navigation_LeftBarButtonImage: UIImage? {
        willSet {
            let item = UIBarButtonItem(image: newValue, style: .plain, target: self, action: navigation_LeftBarButtonAction ?? nil)
            navigationItem.leftBarButtonItem = item
            
            navigation_LeftBarButtonType = .image
        }
    }
    /// 导航条-左侧按钮的颜色
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     let color: UIColor = 0xFFFFFF.a_color
    ///
    ///     self.navigation_LeftBarButtonTintColor = color
    /// }
    /// ```
    public var navigation_LeftBarButtonTintColor: UIColor? {
        willSet {
            navigationItem.leftBarButtonItemTintColor(newValue!)
        }
    }
    /// 导航条-点击左侧按钮后执行的方法
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     self.navigation_LeftBarButtonAction = #Selector(leftButtonClick:)
    /// }
    ///
    /// @objc
    /// func leftButtonClick(sender: UIControl) {
    ///     printLog("leftButtonClick")
    /// }
    /// ```
    public var navigation_LeftBarButtonAction: Selector?  {
        willSet {
            navigationItem.leftBarButtonItem?.action = newValue
        }
    }
    /// 导航条-点击左侧按钮后执行的回调方法
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     self.navigation_LeftBarButtonSelector {
    ///         printLog("leftButtonClick")
    ///     }
    /// ```
    /// - Parameter executeBlock: 点击执行的方法
    public func navigation_LeftBarButtonSelector(executeBlock: (() -> Void)?) {
        leftBarButtonClickBlock = executeBlock
        navigationItem.leftBarButtonItem?.action = #selector(leftBarButtonClick)
    }
    
    @objc internal func leftBarButtonClick() {
        leftBarButtonClickBlock!()
    }
    /// 导航条-右侧按钮
    ///
    /// 设置此选项后，右侧按钮将变为按钮模式
    ///
    /// 此属性与下列属性冲突，不能同时设置
    ///
    /// + <doc:navigation_RightBarButtonText>
    /// + <doc:navigation_RightBarButtonText(_:)>
    /// + <doc:navigation_RightBarButtonImage>
    /// + <doc:navigation_RightBarButtonImage(_:)>
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     let button: UIButton = A.ui.button
    ///
    ///    self.navigation_RightBarButton = button
    /// }
    /// ```
    public var navigation_RightBarButton: UIButton? {
        willSet {
            let item = UIBarButtonItem(customView: newValue!)
            navigationItem.rightBarButtonItem = item
            
            navigation_RightBarButtonType = .custom
        }
    }
    /// 导航条-右侧按钮的文本
    ///
    /// 设置此选项后，右侧按钮将变为文本模式
    ///
    /// 此属性与下列属性冲突，不能同时设置
    ///
    /// + <doc:navigation_RightBarButton>
    /// + <doc:navigation_RightBarButton(_:)>
    /// + <doc:navigation_RightBarButtonImage>
    /// + <doc:navigation_RightBarButtonImage(_:)>
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     self.navigation_RightBarButtonText = "Test"
    /// }
    /// ```
    public var navigation_RightBarButtonText: String? {
        willSet {
            let item = UIBarButtonItem(title: newValue, style: .plain, target: self, action: navigation_RightBarButtonAction ?? nil)
            navigationItem.rightBarButtonItem = item
            
            navigation_RightBarButtonType = .text
        }
    }
    /// 导航条-右侧按钮的图片
    ///
    /// 设置此选项后，右侧按钮将变为图片模式
    ///
    /// 此属性与下列属性冲突，不能同时设置
    ///
    /// + <doc:navigation_RightBarButton>
    /// + <doc:navigation_RightBarButton(_:)>
    /// + <doc:navigation_RightBarButtonText>
    /// + <doc:navigation_RightBarButtonText(_:)>
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     let image: UIImage = UIImage(systemName: "xmark")
    ///
    ///     self.navigation_RightBarButtonImage = image
    /// }
    /// ```
    public var navigation_RightBarButtonImage: UIImage? {
        willSet {
            let item = UIBarButtonItem(image: newValue, style: .plain, target: self, action: navigation_RightBarButtonAction ?? nil)
            navigationItem.rightBarButtonItem = item
            
            navigation_RightBarButtonType = .image
        }
    }
    /// 导航条-右侧按钮的颜色
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     let color: UIColor = 0xFFFFFF.a_color
    ///
    ///     self.navigation_RightBarButtonTintColor = color
    /// }
    /// ```
    public var navigation_RightBarButtonTintColor: UIColor? {
        willSet {
            navigationItem.rightBarButtonItemTintColor(newValue!)
        }
    }
    /// 导航条-点击右侧按钮后执行的方法
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     self.navigation_RightBarButtonAction = #Selector(rightButtonClick:)
    /// }
    ///
    /// @objc
    /// func rightButtonClick(sender: UIControl) {
    ///     printLog("rightButtonClick")
    /// }
    /// ```
    public var navigation_RightBarButtonAction: Selector?  {
        willSet {
            navigationItem.rightBarButtonItem?.action = newValue
        }
    }
    
    private var notification: ANotification = ANotification(notifications: [])
    /// 导航条-点击右侧按钮后执行的回调方法
    ///
    /// 示例：
    ///
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    ///
    ///     self.navigation_RightBarButtonSelector {
    ///         printLog("rightButtonClick")
    ///     }
    /// ```
    /// - Parameter executeBlock: 点击执行的方法
    public func navigation_RigthBarButtonSelector(executeBlock: (() -> Void)?) {
        rightBarButtonClickBlock = executeBlock
        navigationItem.rightBarButtonItem?.action = #selector(rightBarButtonClick)
    }
    
    @objc internal func rightBarButtonClick() {
        rightBarButtonClickBlock!()
    }
    
    deinit {
        a_InternalClear()
        a_Clear()
    }
    
    required public init() {
        super.init(nibName: nil, bundle: nil)
        
        setup()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        a_UI()
        a_UIConfig()
        a_Layout()
        
        a_Other()
        a_End()
        
        A.DEBUG { [weak self] in
            self?.a_Test()
        }
    }
    
    private func setup() {
        self.notification = ANotification(notifications: [AThemeStyle.kNotification_UpdateThemeStyle])
        self.notification.delegate = self
        
        a_Preview()
        a_Begin()
        
        a_Navigation()
        a_Delegate()
        updateThemeStyle()
        a_Notification()
        a_Bind()
        a_Observe()
        a_Event()
    }
    /// 开始之前执行的方法
    ///
    /// 示例：
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
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
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
    ///     override func a_Begin() {
    ///         super.a_Begin()
    ///
    ///         printLog("a_Begin")
    ///     }
    /// }
    /// ```
    open func a_Begin() {}
    private func a_InternalClear() {
        notification.clearNotifications()
        notification.delegate = nil
        
        var bindObjects: [Any] = []
        let mirror = Mirror(reflecting: self)
        for children in mirror.children {
            if ABindable.checkBind(children.value) {
                bindObjects.append(children.value)
            }
            
            if children.value is UIControl {
                (children.value as! UIControl).checkAndRemoveAllEventBlock()
            }
        }
        clearBinds(objects: bindObjects)
    }
    /// 页面销毁时执行的方法
    ///
    /// 示例：
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
    ///     override func a_Clear() {
    ///         super.a_Clear()
    ///
    ///         printLog("a_Clear")
    ///     }
    /// }
    /// ```
    open func a_Clear() {}
    /// 设置导航条的方法
    ///
    /// __所有导航条到设置均在此方法中完成设置__
    ///
    /// 示例：
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
    ///     override func a_Navigation() {
    ///         super.a_Navigation()
    ///
    ///         printLog("a_Navigation")
    ///     }
    /// }
    /// ```
    open func a_Navigation() {}
    /// 设置UI的方法
    ///
    /// __在此方法中完成view的加载__
    ///
    /// 示例：
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
    ///     private let a_view: TestView = TestView()
    ///
    ///     override func a_UI() {
    ///         super.a_UI()
    ///
    ///         addSubView(a_view)
    ///     }
    /// }
    /// ```
    open func a_UI() {}
    /// 设置UI的方法
    ///
    /// __在此方法中完成view的设置__
    ///
    /// 示例：
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
    ///     private let a_view: TestView = TestView()
    ///
    ///     override func a_UIConfig() {
    ///         super.a_UIConfig()
    ///
    ///         a_view
    ///             .backgroundColor(0xFFFFFF.a_color)
    ///     }
    /// }
    /// ```
    open func a_UIConfig() {}
    /// 设置UI布局的方法
    ///
    /// __在此方法中完成view的UI布局__
    ///
    /// 示例：
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
    ///     private let a_view: TestView = TestView()
    ///
    ///     override func a_Layout() {
    ///         super.a_Layout()
    ///
    ///         a_view.size([a_view.screenWidth, 500])
    ///         a_view.a_left(left: 0, offset: 8.0)
    ///         a_view.equalZeroTop()
    ///     }
    /// }
    /// ```
    open func a_Layout() {}
    /// 设置Delegate的方法
    ///
    /// __在此方法中完成Delegate设置__
    ///
    /// __通过<doc:AViewModel/Manage_SetDelegate(targetObject:delegateName:object:)>或者<doc:AViewModel/Manage_SetDelegate(targetObject:delegateNames:object:)>完成Delegate设置将在页面销毁时自动销毁，无需手动销毁__
    ///
    /// 示例：
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
    ///     private let viewModel: TestVM = TestVM()
    ///     private let a_view: TestView = TestView()
    ///
    ///     override func a_Delegate() {
    ///         super.a_Delegate()
    ///
    ///         viewModel.Manage_SetDelegate(
    ///             targetObject: a_view.testTableView,
    ///             delegateNames: AProtocol.delegateAndDataSource,
    ///             object: self
    ///         )
    ///     }
    /// }
    /// ```
    open func a_Delegate() {}
    /// 设置通知的方法
    ///
    /// __在此方法中完成通知设置__
    ///
    /// __通过<doc:AViewModel/Manage_SetNotification(_:)>或者<doc:AViewModel/Manage_SetNotifications(_:)>方法完成通知的设置将在页面销毁时自动销毁，无需手动销毁__
    ///
    /// 示例：
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
    ///     private let viewModel: TestVM = TestVM()
    ///
    ///     override func a_Notification() {
    ///         super.a_Notification()
    ///
    ///         viewModel.Manage_SetNotification("notificationID")
    ///         viewModel.Manage_SetNotifications([
    ///             "notification1ID",
    ///             "notification2ID"
    ///         ])
    ///     }
    /// }
    /// ```
    open func a_Notification() {}
    /// 设置数据绑定的方法
    ///
    /// __在此方法中完成数据绑定设置__
    open func a_Bind() {}
    /// 设置Observe的方法
    ///
    /// 示例：
    ///
    /// __TestVM.swift__
    ///
    /// ```swift
    /// class TestVM: AViewModel {
    ///     @objc dynamic
    ///     public var observeTag_RefreshData: Bool = false
    /// }
    /// ```
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
    ///     private let viewModel: TestVM = TestVM()
    ///
    ///     override func a_Observe() {
    ///         super.a_Observe()
    ///
    ///         viewModel.kvo = viewModel.observe(\.observeTag_RefreshData,
    ///             options: .new,
    ///             changeHandler: { [weak self] (object, change) in
    ///                 if change.newValue! as Bool {
    ///                     self?.a_view.testTableView.reloadData()
    ///                 }
    ///             }
    ///     }
    /// }
    /// ```
    open func a_Observe() {}
    /// 设置Event事件的方法
    ///
    /// 示例：
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
    ///     private let a_view: TestView = TestView()
    ///
    ///     override func a_Event() {
    ///         super.a_Event()
    ///
    ///         a_view.testButton.addEventBlock(.touchUpInside) { [weak self] control in
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
    /// 主题更新的代码在此方法中完成
    ///
    /// __当普通模式和深色模式切换时，此方法将自动调用__
    open func updateThemeStyle() {}
    /// 临时测试的代码，在此方法中完成
    ///
    /// __此方法只在测试时调用，发布后不会调用此方法中的代码__
    open func a_Test() {}
    /// 热更新代码，在此方法中执行
    ///
    /// __此方法依赖injectIII工具__
    ///
    /// __此方法只在测试时调用，发布后不会调用此方法中的代码__
    open func a_Inject() {}
    //默认设置加入的view为全屏
    /// 加入view方法
    /// 
    /// __默认设置加入的view为全屏__
    /// 
    /// 示例：
    ///
    /// ```swift
    /// override func a_UI() {
    ///     super.a_UI()
    /// 
    ///     addRootView(view: a_view)
    /// }
    /// ```
    ///
    /// - Parameter view: 要加入viewController中的UIView
    public func addRootView(view: UIView) {
        var rect: CGRect = UIScreen.main.bounds
        if (navigationController?.topViewController?.isKind(of: Self.self) != nil) {
            rect.origin.y = view.navigationBarMaxY()
            rect.size.height = rect.size.height - view.navigationBarMaxY()
        }
        
        if tabBarController?.viewControllers?.count != 0 {
            rect.size.height = rect.size.height - view.tabBarHeight() - view.safeAreaFooterHeight()
        }
        
        view.frame = rect
        self.view.addSubview(view)
    }
    /// 获取顶层的viewController
    /// - Returns: 顶层的viewController
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
    /// 打印日志信息
    /// - Parameter message: 打印的消息
    open func printLog<T>(_ message: T) {
        logger.a_print(message, type: .NONE)
    }
    /// 打印冗长、详细的日志信息
    /// - Parameter message: 打印的消息
    open func printVerbose<T>(_ message: T) {
        logger.a_print(message, type: .VERBOSE)
    }
    /// 打印debug日志信息
    /// - Parameter message: 打印的消息
    open func printDebug<T>(_ message: T) {
        logger.a_print(message, type: .DEBUG)
    }
    /// 打印debug信息类日志
    /// - Parameter message: 打印的消息
    open func printInfo<T>(_ message: T) {
        logger.a_print(message, type: .INFO)
    }
    /// 打印debug提醒类日志信息
    /// - Parameter message: 打印的消息
    open func printWarning<T>(_ message: T) {
        logger.a_print(message, type: .WARNING)
    }
    /// 打印debug错误日志信息
    /// - Parameter message: 打印的消息
    open func printError<T>(_ message: T) {
        logger.a_print(message, type: .ERROR)
    }
    /// 添加通知（自动管理）
    ///
    /// 添加通知的一般写法
    ///
    /// 示例：
    ///
    /// ```swift
    /// NotificationCenter.default.addObserver(self, selector: #selector(notifAction), name: NSNotification.Name(rawValue: "notificationID"), object: nil)
    /// ```
    ///
    /// 此种写法在页面销毁时，需要手动销毁
    ///
    /// 示例：
    ///
    /// ```swift
    /// NotificationCenter.default.removeObserver(name: NSNotification.Name(rawValue: "notificationID"))
    /// ```
    ///
    /// 针对此种情况，框架在viewModel中加入了自动管理Notification的机制。在实际使用中，只需要调用此方法或<doc:Manage_SetNotifications(_:)>即可加入自动管理中，无需再关心销毁问题
    ///
    /// 示例：
    ///
    /// ```swift
    /// Manage_SetNotification("notificationID")
    /// ```
    ///
    /// 加入通知后，需要覆写<doc:ANotificationReceive(notification:)>来完成通知后的回调
    ///
    /// - Parameter notificationName: 通知ID
    public func Manage_SetNotification(_ notificationName: String) {
        notification.addNotification(notificationName: notificationName)
    }
    /// 添加多个通知（自动管理）
    ///
    /// 添加通知的一般写法
    ///
    /// 示例：
    ///
    /// ```swift
    /// NotificationCenter.default.addObserver(self, selector: #selector(notifAction), name: NSNotification.Name(rawValue: "notification1ID"), object: nil)
    ///
    /// NotificationCenter.default.addObserver(self, selector: #selector(notifAction), name: NSNotification.Name(rawValue: "notification2ID"), object: nil)
    /// ```
    ///
    /// 此种写法在页面销毁时，需要手动销毁
    ///
    /// 示例：
    ///
    /// ```swift
    /// NotificationCenter.default.removeObserver(name: NSNotification.Name(rawValue: "notification1ID"))
    ///
    /// NotificationCenter.default.removeObserver(name: NSNotification.Name(rawValue: "notification2ID"))
    /// ```
    ///
    /// 针对此种情况，框架在viewModel中加入了自动管理Notification的机制。在实际使用中，只需要调用此方法或<doc:Manage_SetNotifications(_:)>即可加入自动管理中，无需再关心销毁问题
    ///
    /// 示例：
    ///
    /// ```swift
    /// Manage_SetNotification("notification1ID")
    /// Manage_SetNotification("notification2ID")
    /// ```
    ///
    /// 或者
    ///
    /// ```swift
    /// Manage_SetNotifications([
    ///     "notification1ID",
    ///     "notification2ID"
    /// ])
    /// ```
    ///
    /// 加入通知后，需要覆写<doc:ANotificationReceive(notification:)>来完成通知后的回调
    ///
    /// - Parameter notificationNames: 通知ID数组
    public func Manage_SetNotifications(_ notificationNames: Array<String>) {
        notification.addNotifications(notificationNames: notificationNames)
    }
    /// 删除自动管理的通知
    ///
    /// 由于viewModel加入了自动管理通知的机制，所以使用<doc:Manage_SetNotification(_:)>或<doc:Manage_SetNotifications(_:)>后除特殊情况，不必手动删除
    ///
    /// - Parameter notificationName: 通知ID
    public func Manage_DeleteNotification(_ notificationName: String) {
        notification.removeNotification(notificationName: notificationName)
    }
    /// 删除自动管理的多个通知
    ///
    /// 由于viewModel加入了自动管理通知的机制，所以使用<doc:Manage_SetNotification(_:)>或<doc:Manage_SetNotifications(_:)>后除特殊情况，不必手动删除
    ///
    /// - Parameter notificationNames: 通知ID数组
    public func Manage_DeleteNotifications(_ notificationNames: Array<String>) {
        notification.removeNotifications(notificationNames: notificationNames)
    }
    /// 发送单条通知
    ///
    /// 支持发送单条通知和发送多条通知
    /// 发送单条通知用此方法
    /// 发送多条通知用<doc:Manage_PostNotifications(_:objects:)>
    ///
    /// - Parameters:
    ///   - notificationName: 通知名称
    ///   - object: 通知发送的对象（可以不发对象）
    public func Manage_PostNotification(_ notificationName: String, object:[String : Any]?=nil) {
        ANotification.PostNotification(notificationName: notificationName, object: object)
    }
    /// 发送多条通知
    ///
    /// 支持发送单条通知和发送多条通知
    /// 发送多条通知用此方法
    /// 发送单条通知用<doc:Manage_PostNotification(_:object:)>
    ///
    ///
    /// - Parameters:
    ///   - notificationNames: 通知名称数组
    ///   - objects: 通知发送的对象数组（可以不发对象）
    public func Manage_PostNotifications(_ notificationNames: [String], objects: [[String : Any]?]?=nil) {
        var i: Int = 0
        while i<notificationNames.count {
            Manage_PostNotification(notificationNames[i], object: objects?[i])
            i++
        }
    }
    /// 通知类消息的回调方法
    ///
    /// 此方法为<doc:a_Notification()>中设置的通知的回调
    ///
    /// 示例：
    ///
    /// __TestVC.swift__
    ///
    /// ```swift
    /// class TestVC: AViewController {
    ///     private let viewModel: TestVM = TestVM()
    ///
    ///     override func a_Notification() {
    ///         super.a_Notification()
    ///
    ///         viewModel.Manage_SetNotification("notificationID")
    ///     }
    ///
    ///     override func ANotificationReceive(notification: Notification) {
    ///         super.ANotificationReceive(notification: notification)
    ///
    ///         if notification.name.rawValue == "notificationID" {
    ///             printLog("test notification")
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter notification: 通知
    open func ANotificationReceive(notification: Notification) {
        if notification.name.rawValue == AThemeStyle.kNotification_UpdateThemeStyle {
            updateThemeStyle()
        }
    }
    
    /// 判断是否时模态方式退出
    ///
    /// + true：modal方式
    /// + false：push方式
    ///
    /// - Parameter isPresent: 是否模态方式
    public func isPresent(_ isPresent: Bool) {
        self.isPresent = isPresent
    }
    /// 设置导航条-标题方法
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     self.navigation_Title("标题")
    /// }
    /// ```
    /// - Parameter navigation_Title: 标题
    public func navigation_Title(_ navigation_Title: String) {
        self.navigation_Title = navigation_Title
    }
    /// 设置导航条-标题的view方法
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     let titleView: UIView = A.ui.view
    /// 
    ///     self.navigation_TitleView(titleView)
    /// }
    /// ```
    /// - Parameter navigation_TitleView: 标题view
    public func navigation_TitleView(_ navigation_TitleView: UIView) {
        self.navigation_TitleView = navigation_TitleView
    }
    /// 设置导航条-左侧按钮方法
    /// 
    /// 设置此选项后，左侧按钮将变为按钮模式
    /// 
    /// 此属性与下列属性冲突，不能同时设置
    /// 
    /// + <doc:navigation_LeftBarButtonText>
    /// + <doc:navigation_LeftBarButtonText(_:)>
    /// + <doc:navigation_LeftBarButtonImage>
    /// + <doc:navigation_LeftBarButtonImage(_:)>
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     let button: UIButton = A.ui.button
    /// 
    ///     self.navigation_LeftBarButton = button
    /// }
    /// ```
    /// - Parameter navigation_LeftBarButton: 左侧按钮
    public func navigation_LeftBarButton(_ navigation_LeftBarButton: UIButton) {
        self.navigation_LeftBarButton = navigation_LeftBarButton
    }
    /// 设置导航条-左侧按钮的文本方法
    /// 
    /// 设置此选项后，左侧按钮将变为文本模式
    /// 
    /// 此属性与下列属性冲突，不能同时设置
    /// 
    /// + <doc:navigation_LeftBarButton>
    /// + <doc:navigation_LeftBarButton(_:)>
    /// + <doc:navigation_LeftBarButtonImage>
    /// + <doc:navigation_LeftBarButtonImage(_:)>
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     self.navigation_LeftBarButtonText("Test")
    /// }
    /// ```
    /// - Parameter navigation_LeftBarButtonText: 左侧按钮文本
    public func navigation_LeftBarButtonText(_ navigation_LeftBarButtonText: String) {
        self.navigation_LeftBarButtonText = navigation_LeftBarButtonText
    }
    /// 设置导航条-左侧按钮的图片方法
    /// 
    /// 设置此选项后，左侧按钮将变为图片模式
    /// 
    /// 此属性与下列属性冲突，不能同时设置
    /// 
    /// + <doc:navigation_LeftBarButton>
    /// + <doc:navigation_LeftBarButton(_:)>
    /// + <doc:navigation_LeftBarButtonText>
    /// + <doc:navigation_LeftBarButtonText(_:)>
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     let image: UIImage = UIImage(systemName: "xmark")
    /// 
    ///     self.navigation_LeftBarButtonImage(image)
    /// }
    /// ```
    /// - Parameter navigation_LeftBarButtonImage: 左侧图片
    public func navigation_LeftBarButtonImage(_ navigation_LeftBarButtonImage: UIImage) {
        self.navigation_LeftBarButtonImage = navigation_LeftBarButtonImage
    }
    /// 设置导航条-左侧按钮的颜色方法
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     let color: UIColor = 0xFFFFFF.a_color
    /// 
    ///     self.navigation_LeftBarButtonTintColor(color)
    /// }
    /// ```
    /// - Parameter tintColor: 左侧按钮颜色
    public func navigation_LeftBarButtonTintColor(_ tintColor: UIColor?) {
        self.navigation_LeftBarButtonTintColor = tintColor
    }
    /// 设置导航条-点击左侧按钮后执行的方法
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     self.navigation_LeftBarButtonAction(#Selector(leftButtonClick:))
    /// }
    /// 
    /// @objc
    /// func leftButtonClick(sender: UIControl) {
    ///     printLog("leftButtonClick")
    /// }
    /// ```
    /// - Parameter navigation_LeftBarButtonAction: 左侧按钮点击后执行的方法
    public func navigation_LeftBarButtonAction(_ navigation_LeftBarButtonAction: Selector) {
        self.navigation_LeftBarButtonAction = navigation_LeftBarButtonAction
    }
    /// 设置导航条-右侧按钮方法
    /// 
    /// 设置此选项后，右侧按钮将变为按钮模式
    /// 
    /// 此属性与下列属性冲突，不能同时设置
    /// 
    /// + <doc:navigation_RightBarButtonText>
    /// + <doc:navigation_RightBarButtonText(_:)>
    /// + <doc:navigation_RightBarButtonImage>
    /// + <doc:navigation_RightBarButtonImage(_:)>
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     let button: UIButton = A.ui.button
    /// 
    ///    self.navigation_RightBarButton(button)
    /// }
    /// ```
    /// - Parameter navigation_RightBarButton: 右侧按钮
    public func navigation_RightBarButton(_ navigation_RightBarButton: UIButton) {
        self.navigation_RightBarButton = navigation_RightBarButton
    }
    /// 设置导航条-右侧按钮的文本方法
    /// 
    /// 设置此选项后，右侧按钮将变为文本模式
    /// 
    /// 此属性与下列属性冲突，不能同时设置
    /// 
    /// + <doc:navigation_RightBarButton>
    /// + <doc:navigation_RightBarButton(_:)>
    /// + <doc:navigation_RightBarButtonImage>
    /// + <doc:navigation_RightBarButtonImage(_:)>
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     self.navigation_RightBarButtonText("Test")
    /// }
    /// ```
    /// - Parameter navigation_RightBarButtonText: 右侧显示文本
    public func navigation_RightBarButtonText(_ navigation_RightBarButtonText: String) {
        self.navigation_RightBarButtonText = navigation_RightBarButtonText
    }
    /// 设置导航条-右侧按钮的图片方法
    /// 
    /// 设置此选项后，右侧按钮将变为图片模式
    /// 
    /// 此属性与下列属性冲突，不能同时设置
    /// 
    /// + <doc:navigation_RightBarButton>
    /// + <doc:navigation_RightBarButton(_:)>
    /// + <doc:navigation_RightBarButtonText>
    /// + <doc:navigation_RightBarButtonText(_:)>
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     let image: UIImage = UIImage(systemName: "xmark")
    /// 
    ///     self.navigation_RightBarButtonImage(image)
    /// }
    /// ```
    /// - Parameter navigation_RightBarButtonImage: 右侧图片
    public func navigation_RightBarButtonImage(_ navigation_RightBarButtonImage: UIImage) {
        self.navigation_RightBarButtonImage = navigation_RightBarButtonImage
    }
    /// 设置导航条-右侧按钮的颜色方法
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     let color: UIColor = 0xFFFFFF.a_color
    /// 
    ///     self.navigation_RightBarButtonTintColor(color)
    /// }
    /// ```
    /// - Parameter tintColor: 右侧按钮颜色
    public func navigation_RightBarButtonTintColor(_ tintColor: UIColor?) {
        self.navigation_RightBarButtonTintColor = tintColor
    }
    /// 设置导航条-点击右侧按钮后执行的方法
    /// 
    /// 示例：
    /// 
    /// ```swift
    /// open override func a_Navigation() -> Void {
    ///     super.a_Navigation()
    /// 
    ///     self.navigation_RightBarButtonAction(#Selector(rightButtonClick:))
    /// }
    /// 
    /// @objc
    /// func rightButtonClick(sender: UIControl) {
    ///     printLog("rightButtonClick")
    /// }
    /// ```
    /// - Parameter navigation_RightBarButtonAction: 右侧按钮点击时执行的方法
    public func navigation_RightBarButtonAction(_ navigation_RightBarButtonAction: Selector) {
        self.navigation_RightBarButtonAction = navigation_RightBarButtonAction
    }
    //MARK: - Inject
    /// 热更新时调用的代码在此方法中实现
    ///
    /// __此方法依赖InjectIII工具__
    @objc open
    func injected()  {
        A.DEBUG { [weak self] in
            self?.viewDidLoad()
            self?.a_Inject()
        }
    }
}
