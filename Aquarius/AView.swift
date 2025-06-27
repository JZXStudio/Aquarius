//
//  AView.swift
//  Aquarius
//
//  Created by SONG JIN on 2021/6/12.
//

import UIKit
/// view的基类（MVVM）
///
/// 主要包括：
/// + 键盘管理
/// + 分层管理
/// + 事件管理
/// + Delegate管理
/// + 通知管理
/// + 数据绑定管理
/// + 日志管理
/// + 热更新管理
open class AView: UIView, ANotificationDelegate, ABindProcotol {
    internal var events: Array<Dictionary<UIControl, UIControl.Event>> = []
    private var delegateManagers: Array<Dictionary<String, AnyObject>> = []
    internal var bindKeyArray: Array<String> = Array()
    internal var notification: ANotification = ANotification(notifications: [])
    internal let logger: ALogger = ALogger()
    /*
        当非全面屏手机时，导航条中的view的基点为0而非导航条下方。
        如果是全面屏，则返回0
        如果不是全面屏，则返回64
     */
    
    /// 页面最上方的基点位置
    ///
    /// ```
    /// 当非全面屏手机当非全面屏手机时，导航条中的view的基点为0而非导航条下方。
    ///
    /// 如果是全面屏，则返回0
    ///
    /// 如果不是全面屏，则返回64
    /// ```
    public let a_topMargins: CGFloat = UIView.safeAreaFooterHeight() == 0 ? 64 : 0
    
    private var keyboardView: UIView?
    /// 键盘高度
    public var keyboardHeight: CGFloat = 0.0
    private var keyboardDuration: CGFloat = 0.5
    private var keyboardAuto: Bool = true
    private var keyboardShow: ((_ notification: Notification)->Void)?
    private var keyboardHide: ((_ notification: Notification)->Void)?
    /// 是否开启键盘自动隐藏
    ///
    /// 默认：不开启
    public var keyboardAutoHide: Bool = false
    /// 是否启用键盘通知
    ///
    /// 默认： 不启用
    public var isKeyboardEnabled: Bool = false {
        willSet {
            if newValue {
                notification.addNotifications(notificationNames: [
                    UIResponder.keyboardWillShowNotification.rawValue,
                    UIResponder.keyboardWillHideNotification.rawValue
                ])
            } else {
                notification.removeNotifications(notificationNames: [
                    UIResponder.keyboardWillShowNotification.rawValue,
                    UIResponder.keyboardWillHideNotification.rawValue
                ])
            }
        }
    }
    /// 设置键盘自动隐藏
    /// 
    /// 默认：不开启
    /// - Parameter isKeyboardEnabled: 是否自动隐藏
    public func isKeyboardEnabled(_ isKeyboardEnabled: Bool=false) {
        self.isKeyboardEnabled = isKeyboardEnabled
    }
    
    /// 设置是否启用键盘通知
    ///
    /// 默认：不启用
    /// - Parameter keyboardAutoHide: 是否启用键盘通知
    public func keyboardAutoHide(_ keyboardAutoHide: Bool=false) {
        self.keyboardAutoHide = keyboardAutoHide
    }
    
    deinit {
        a_InternalClear()
        a_Clear()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required public init() {
        super.init(frame: UIScreen.main.bounds)
        
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.notification = ANotification(notifications: [AThemeStyle.kNotification_UpdateThemeStyle])
        self.notification.delegate = self
        
        self.a_Preview()
        self.a_Begin()
        
        self.a_UI()
        self.a_UIConfig()
        self.a_Layout()
        self.a_Notification()
        self.a_Delegate()
        self.updateThemeStyle()
        self.a_Bind()
        self.a_Event()
        self.a_Other()
        self.a_End()
        
        A.DEBUG { [weak self] in
            self?.a_Test()
        }
    }
    /// 热更新代码，在此方法中执行
    ///
    /// __此方法依赖injectIII工具__
    ///
    /// __此方法只在测试时调用，发布后不会调用此方法中的代码__
    open func a_Inject() {
        setup()
    }
    /// 开始之前执行的方法
    ///
    /// 示例：
    ///
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
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
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
    ///     override func a_Begin() {
    ///         super.a_Begin()
    ///
    ///         printLog("a_Begin")
    ///     }
    /// }
    /// ```
    open func a_Begin() {}
    private func a_InternalClear() {
        for delegateDict: Dictionary<String, AnyObject> in delegateManagers {
            let key: String = Array(delegateDict.keys)[0]
            let anyObject: AnyObject = Array(delegateDict.values)[0]
            anyObject.setValue(nil, forKey: key)
        }
        self.delegateManagers.removeAll()
        
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
        clearAllEvents()
        
        notification.clearNotifications()
        notification.delegate = nil
    }
    /// 页面销毁时执行的方法
    ///
    /// 示例：
    ///
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
    ///     override func a_Clear() {
    ///         super.a_Clear()
    ///
    ///         printLog("a_Clear")
    ///     }
    /// }
    /// ```
    open func a_Clear() {}
    /// 设置UI的方法
    ///
    /// __在此方法中完成UI控件的加载__
    ///
    /// 示例：
    ///
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
    ///     private let testLabel: UILabel = A.ui.label
    ///     private let testButton: UIButton = A.ui.button
    ///
    ///     override func a_UI() {
    ///         super.a_UI()
    ///
    ///         addSubViews(views: [
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
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
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
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
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
    /// __通过<doc:Manage_SetNotification(_:)>或者<doc:Manage_SetNotifications(_:)>方法完成通知的设置将在页面销毁时自动销毁，无需手动销毁__
    ///
    /// 示例：
    ///
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
    ///     override func a_Notification() {
    ///         super.a_Notification()
    ///
    ///         Manage_SetNotification("notificationID")
    ///         viewModel.Manage_SetNotifications([
    ///             "notification1ID",
    ///             "notification2ID"
    ///         ])
    ///     }
    /// }
    /// ```
    open func a_Notification() {}
    /// 设置Delegate的方法
    ///
    /// __在此方法中完成Delegate设置__
    ///
    /// __通过<doc:Manage_SetDelegate(targetObject:delegateName:object:)>或者<doc:Manage_SetDelegate(targetObject:delegateNames:object:)>完成Delegate设置将在页面销毁时自动销毁，无需手动销毁__
    ///
    /// 示例：
    ///
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
    ///     override func a_Delegate() {
    ///         super.a_Delegate()
    ///
    ///         Manage_SetDelegate(
    ///             targetObject: a_view.testTableView,
    ///             delegateNames: AProtocol.delegateAndDataSource,
    ///             object: self
    ///         )
    ///     }
    /// }
    /// ```
    open func a_Delegate() {}
    /// 设置数据绑定的方法
    ///
    /// __在此方法中完成数据绑定设置__
    open func a_Bind() {}
    /// 设置Event事件的方法
    ///
    /// 示例：
    ///
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
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
    /// 主题更新的代码在此方法中完成
    ///
    /// __当普通模式和深色模式切换时，此方法将自动调用__
    open func updateThemeStyle() {}
    /// 临时测试的代码，在此方法中完成
    ///
    /// __此方法只在测试时调用，发布后不会调用此方法中的代码__
    open func a_Test() {}
    /// 键盘显示时的回调方法
    /// - Parameter keyboardHeight: 键盘高度
    open func a_KeyboardWillShow(keyboardHeight: CGFloat) {}
    /// 键盘隐藏时的回调方法
    open func a_KeyboardWillHide() {}
    /// 使用Event时的统一回调方法
    /// - Parameter sender: 事件的UI控件
    @objc
    open func manageAllEvents(sender: UIControl) {}
    /// 添加UI控件事件
    ///
    /// 示例：
    ///
    /// ```swift
    /// addEvent(testButton, controlEvent: .touchUpInside)
    /// ```
    ///
    /// - Parameters:
    ///   - sender: UI控件
    ///   - controlEvent: 事件类型
    public func addEvent(_ sender: UIControl, controlEvent: UIControl.Event) {
        sender.addTarget(self, action: #selector(manageAllEvents(sender: )), for: controlEvent)
        
        let dict: Dictionary<UIControl, UIControl.Event> = [sender : controlEvent]
        events.append(dict)
    }
    /// 删除UI控件事件
    ///
    /// 示例：
    ///
    /// ```swift
    /// deleteEvent(testButton, controlEvent: .touchUpInside)
    /// ```
    ///
    /// - Parameters:
    ///   - sender: UI控件
    ///   - controlEvent: 事件类型
    public func deleteEvent(_ sender: UIControl, controlEvent: UIControl.Event) {
        sender.removeTarget(self, action: #selector(manageAllEvents(sender: )), for: controlEvent)
        
        var index: Int = 0
        for dict: Dictionary<UIControl, UIControl.Event> in events {
            let currentSender: UIControl = Array(dict.keys)[0]
            let currentControlEvent: UIControl.Event = Array(dict.values)[0]
            
            if currentSender == sender && currentControlEvent == controlEvent {
                events.remove(at: index)
            }
            index = index + 1
        }
    }
    /// 删除所有Event
    public func clearAllEvents() {
        for dict: Dictionary<UIControl, UIControl.Event> in events {
            let currentSender: UIControl = Array(dict.keys)[0]
            let currentControlEvent: UIControl.Event = Array(dict.values)[0]
            
            currentSender.removeTarget(self, action: #selector(manageAllEvents(sender: )), for: currentControlEvent)
        }
        
        events.removeAll()
    }
    /// 添加touchDown类型的Event
    ///
    /// ```swift
    /// addTouchDownEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addTouchDownEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .touchDown)
    }
    /// 删除touchDown类型的Event
    ///
    /// ```swift
    /// removeTouchDownEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeTouchDownEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .touchDown)
    }
    /// 添加touchDownRepeat类型的Event
    ///
    /// ```swift
    /// addTouchDownRepeatEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addTouchDownRepeatEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .touchDownRepeat)
    }
    /// 删除touchDownRepeat类型的Event
    ///
    /// ```swift
    /// removeTouchDownEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeTouchDownRepeat(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .touchDownRepeat)
    }
    /// 添加touchDragInside类型的Event
    ///
    /// ```swift
    /// addTouchDragInsideEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addTouchDragInsideEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .touchDragInside)
    }
    /// 删除touchDragInside类型的Event
    ///
    /// ```swift
    /// removeTouchDragInsideEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeTouchDragInsideEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .touchDragInside)
    }
    /// 添加touchDragOutside类型的Event
    ///
    /// ```swift
    /// addTouchDragOutsideEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addTouchDragOutsideEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .touchDragOutside)
    }
    /// 删除touchDragOutside类型的Event
    ///
    /// ```swift
    /// removeTouchDragOutsideEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeTouchDragOutsideEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .touchDragOutside)
    }
    /// 添加touchDragEnter类型的Event
    ///
    /// ```swift
    /// addTouchDragEnterEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addTouchDragEnterEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .touchDragEnter)
    }
    /// 删除touchDragEnter类型的Event
    ///
    /// ```swift
    /// removeTouchDragEnterEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeTouchDragEnterEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .touchDragEnter)
    }
    /// 添加touchDragExit类型的Event
    ///
    /// ```swift
    /// addTouchDragExitEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addTouchDragExitEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .touchDragExit)
    }
    /// 删除touchDragExit类型的Event
    ///
    /// ```swift
    /// removeTouchDragExitEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeTouchDragExitEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .touchDragExit)
    }
    /// 添加touchUpInside类型的Event
    ///
    /// ```swift
    /// addTouchUpInsideEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addTouchUpInsideEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .touchUpInside)
    }
    /// 删除touchUpInside类型的Event
    ///
    /// ```swift
    /// removeTouchUpInsideEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    func removeTouchUpInsideEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .touchUpInside)
    }
    /// 添加touchUpOutside类型的Event
    ///
    /// ```swift
    /// addTouchUpOutsideEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addTouchUpOutsideEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .touchUpOutside)
    }
    /// 删除touchUpOutside类型的Event
    ///
    /// ```swift
    /// removeTouchUpOutsideEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeTouchUpOutsideEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .touchUpOutside)
    }
    /// 添加touchCancel类型的Event
    ///
    /// ```swift
    /// addTouchCancelEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addTouchCancelEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .touchCancel)
    }
    /// 删除touchCancel类型的Event
    ///
    /// ```swift
    /// removeTouchCancelEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeTouchCancelEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .touchCancel)
    }
    /// 添加valueChanged类型的Event
    ///
    /// ```swift
    /// addValueChangedEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addValueChangedEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .valueChanged)
    }
    /// 删除valueChanged类型的Event
    ///
    /// ```swift
    /// removeValueChangedEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeValueChangedEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .valueChanged)
    }
    /// 添加editingDidBegin类型的Event
    ///
    /// ```swift
    /// addEditingDidBeginEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addEditingDidBeginEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .editingDidBegin)
    }
    /// 删除editingDidBegin类型的Event
    ///
    /// ```swift
    /// removeEditingDidBeginEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeEditingDidBeginEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .editingDidBegin)
    }
    /// 添加editingChanged类型的Event
    ///
    /// ```swift
    /// addEditingChangedEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addEditingChangedEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .editingChanged)
    }
    /// 删除editingChanged类型的Event
    ///
    /// ```swift
    /// removeEditingChangedEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeEditingChangedEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .editingChanged)
    }
    /// 添加editingDidEnd类型的Event
    ///
    /// ```swift
    /// addEditingDidEndEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addEditingDidEndEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .editingDidEnd)
    }
    /// 删除editingDidEnd类型的Event
    ///
    /// ```swift
    /// removeEditingDidEndEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeEditingDidEndEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .editingDidEnd)
    }
    /// 添加editingDidEndOnExit类型的Event
    ///
    /// ```swift
    /// addEditingDidEndOnExitEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addEditingDidEndOnExitEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .editingDidEndOnExit)
    }
    /// 删除editingDidEndOnExit类型的Event
    ///
    /// ```swift
    /// removeEditingDidEndOnExitEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeEditingDidEndOnExitEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .editingDidEndOnExit)
    }
    /// 添加allTouchEvents类型的Event
    ///
    /// ```swift
    /// addAllTouchEventsEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addAllTouchEventsEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .allTouchEvents)
    }
    /// 删除allTouchEvents类型的Event
    ///
    /// ```swift
    /// removeAllTouchEventsEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeAllTouchEventsEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .allTouchEvents)
    }
    /// 添加allEditingEvents类型的Event
    ///
    /// ```swift
    /// addAllEditingEventsEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addAllEditingEventsEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .allEditingEvents)
    }
    /// 删除allEditingEvents类型的Event
    ///
    /// ```swift
    /// removeAllEditingEventsEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeAllEditingEventsEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .allEditingEvents)
    }
    /// 添加applicationReserved类型的Event
    ///
    /// ```swift
    /// addApplicationReservedEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addApplicationReservedEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .applicationReserved)
    }
    /// 删除applicationReserved类型的Event
    ///
    /// ```swift
    /// removeApplicationReservedEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeApplicationReservedEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .applicationReserved)
    }
    /// 添加systemReserved类型的Event
    ///
    /// ```swift
    /// addSystemReservedEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addSystemReservedEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .systemReserved)
    }
    /// 删除systemReserved类型的Event
    ///
    /// ```swift
    /// removeSystemReservedEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeSystemReservedEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .systemReserved)
    }
    /// 添加allEvents类型的Event
    ///
    /// ```swift
    /// addAllEventsEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func addAllEventsEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .allEvents)
    }
    /// 删除allEvents类型的Event
    ///
    /// ```swift
    /// removeAllEventsEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    public func removeAllEventsEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .allEvents)
    }
    /// 添加allEvents类型的Event
    ///
    /// ```swift
    /// addPrimaryActionTriggeredEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    @available(iOS 9.0, *)
    public func addPrimaryActionTriggeredEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .primaryActionTriggered)
    }
    /// 删除primaryActionTriggered类型的Event
    ///
    /// ```swift
    /// removePrimaryActionTriggeredEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    @available(iOS 9.0, *)
    public func removePrimaryActionTriggeredEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .primaryActionTriggered)
    }
    /// 添加menuActionTriggered类型的Event
    ///
    /// ```swift
    /// addMenuActionTriggeredEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    @available(iOS 14.0, *)
    public func addMenuActionTriggeredEvent(_ sender: UIControl) {
        addEvent(sender, controlEvent: .menuActionTriggered)
    }
    /// 删除menuActionTriggered类型的Event
    ///
    /// ```swift
    /// removeMenuActionTriggeredEvent(UI控件)
    /// ```
    ///
    /// - Parameter sender: UI控件
    @available(iOS 14.0, *)
    public func removeMenuActionTriggeredEvent(_ sender: UIControl) {
        deleteEvent(sender, controlEvent: .menuActionTriggered)
    }
    
    func addDelegate(object: AnyObject, delegateName: String) {
        let dict: Dictionary<String, AnyObject> = [delegateName: object]
        delegateManagers.append(dict)
    }
    /// 添加delegate（自动管理）
    ///
    /// 添加Delegate的一般写法
    ///
    /// 示例：
    ///
    /// ```swift
    /// testTableView.delegate = self
    /// testTableView.dataSource = self
    /// ```
    ///
    /// 此种写法在页面销毁时，需要手动销毁
    ///
    /// 示例：
    ///
    /// ```swift
    /// testTableView.delegate = nil
    /// testTableView.dataSource = nil
    /// ```
    ///
    /// 针对此种情况，框架在view中加入了自动管理Delegate的机制。在实际使用中，只需要调用此方法或<doc:Manage_SetDelegate(targetObject:delegateNames:object:)>即可加入自动管理中，无需再关心销毁问题
    ///
    /// 框架引入了<doc:AProtocol>，提供了:
    ///
    /// + <doc:AProtocol/delegate>
    /// + <doc:AProtocol/dataSource>
    /// + <doc:AProtocol/delegateAndDataSource>
    /// + <doc:AProtocol/emptyDelegate>
    ///
    /// 在实际使用中可以结合使用
    ///
    /// 示例：
    ///
    /// ```swift
    /// Manage_SetDelegate(
    ///     targetObject: a_view.testTableView,
    ///     delegateName: AProtocol.delegate,
    ///     object: self
    /// )
    ///
    /// Manage_SetDelegate(
    ///     targetObject: a_view.testTableView,
    ///     delegateName: AProtocol.dataSource,
    ///     object: self
    /// )
    /// ```
    ///
    /// 同样，也可以自己来写delegateName。
    ///
    /// 示例：
    ///
    /// ```swift
    /// Manage_SetDelegate(
    ///     targetObject: a_view.testTableView,
    ///     delegateName: "delegate",
    ///     object: self
    /// )
    ///
    /// Manage_SetDelegate(
    ///     targetObject: a_view.testTableView,
    ///     delegateName: "dataSource",
    ///     object: self
    /// )
    /// ```
    ///
    /// __Delegate建议在<doc:AViewController/a_Delegate()>中使用__
    ///
    /// - Parameters:
    ///   - targetObject: 加入Delegate的UI组件
    ///   - delegateName: delegate名称
    ///   - object: 目标
    public func Manage_SetDelegate(targetObject: AnyObject, delegateName: String, object: AnyObject) {
        targetObject.setValue(object, forKey: delegateName)
        self.addDelegate(object: targetObject, delegateName: delegateName)
    }
    /// 添加多个delegate（自动管理）
    ///
    /// 添加Delegate的一般写法
    ///
    /// 示例：
    ///
    /// ```swift
    /// testTableView.delegate = self
    /// testTableView.dataSource = self
    /// ```
    ///
    /// 此种写法在页面销毁时，需要手动销毁
    ///
    /// 示例：
    ///
    /// ```swift
    /// testTableView.delegate = nil
    /// testTableView.dataSource = nil
    /// ```
    ///
    /// 针对此种情况，框架在view中加入了自动管理Delegate的机制。在实际使用中，只需要调用此方法或<doc:Manage_SetDelegate(targetObject:delegateName:object:)>即可加入自动管理中，无需再关心销毁问题
    ///
    /// 框架引入了<doc:AProtocol>，提供了:
    ///
    /// + <doc:AProtocol/delegate>
    /// + <doc:AProtocol/dataSource>
    /// + <doc:AProtocol/delegateAndDataSource>
    /// + <doc:AProtocol/emptyDelegate>
    ///
    /// 在实际使用中可以结合使用
    ///
    /// 示例：
    ///
    /// ```swift
    /// Manage_SetDelegate(
    ///     targetObject: a_view.testTableView,
    ///     delegateNames: AProtocol.delegateAndDataSource,
    ///     object: self
    /// )
    /// ```
    ///
    /// 同样，也可以自己来写delegateNames。
    ///
    /// 示例：
    ///
    /// ```swift
    /// Manage_SetDelegate(
    ///     targetObject: a_view.testTableView,
    ///     delegateNames: ["delegate", "dataSource"],
    ///     object: self
    /// )
    /// ```
    ///
    /// __Delegate建议在<doc:AViewController/a_Delegate()>中使用__
    ///
    /// - Parameters:
    ///   - targetObject: 加入Delegate的UI组件
    ///   - delegateNames: delegate名称数组
    ///   - object: 目标
    public func Manage_SetDelegate(targetObject: AnyObject, delegateNames: Array<String>, object: AnyObject) {
        for delegateName in delegateNames {
            targetObject.setValue(object, forKey: delegateName)
            self.addDelegate(object: targetObject, delegateName: delegateName)
        }
    }
    /// 删除自动管理的某个Delegate
    ///
    /// 由于view加入了自动管理Delegate的机制，所以使用<doc:Manage_SetDelegate(targetObject:delegateName:object:)>或<doc:Manage_SetDelegate(targetObject:delegateNames:object:)>后除特殊情况，不必手动删除
    ///
    /// __Delegate建议在<doc:AViewController/a_Delegate()>中使用__
    ///
    /// - Parameters:
    ///   - object: 加入Delegate的UI组件
    ///   - delegateName: delegate名称
    public func Manage_DeleteDelegate(object: AnyObject, delegateName: String) {
        self.deleteObject(object: object, delegateName: delegateName)
    }
    /// 删除自动管理的多个Delegate
    ///
    /// 由于view加入了自动管理Delegate的机制，所以使用<doc:Manage_SetDelegate(targetObject:delegateName:object:)>或<doc:Manage_SetDelegate(targetObject:delegateNames:object:)>后除特殊情况，不必手动删除
    ///
    /// __Delegate建议在<doc:AViewController/a_Delegate()>中使用__
    ///
    /// - Parameters:
    ///   - object: 加入Delegate的UI组件
    ///   - delegateNames: delegate名称数组
    public func Manage_DeleteDelegate(object: AnyObject, delegateNames: Array<String>) {
        for delegateName in delegateNames {
            self.deleteObject(object: object, delegateName: delegateName)
        }
    }
    
    internal func deleteObject(object: AnyObject, delegateName: String) {
        var i: Int = 0
        for dict: Dictionary<String, AnyObject> in self.delegateManagers {
            if Array(dict.keys)[0] == delegateName && Array(dict.values)[0] === object {
                delegateManagers.remove(at: i)
                break
            }
            
            i = i + 1
        }
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
    /// 针对此种情况，框架在view中加入了自动管理Notification的机制。在实际使用中，只需要调用此方法或<doc:Manage_SetNotifications(_:)>即可加入自动管理中，无需再关心销毁问题
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
    /// 针对此种情况，框架在view中加入了自动管理Notification的机制。在实际使用中，只需要调用此方法或<doc:Manage_SetNotifications(_:)>即可加入自动管理中，无需再关心销毁问题
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
    /// 由于view加入了自动管理通知的机制，所以使用<doc:Manage_SetNotification(_:)>或<doc:Manage_SetNotifications(_:)>后除特殊情况，不必手动删除
    ///
    /// - Parameter notificationName: 通知ID
    public func Manage_DeleteNotification(_ notificationName: String) {
        notification.removeNotification(notificationName: notificationName)
    }
    /// 删除自动管理的多个通知
    ///
    /// 由于view加入了自动管理通知的机制，所以使用<doc:Manage_SetNotification(_:)>或<doc:Manage_SetNotifications(_:)>后除特殊情况，不必手动删除
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
    /// 添加数据绑定（自动管理）（临时隐藏）
    ///
    /// 框架引入了数据绑定机制。
    ///
    /// 在viewController、viewModel和view中绑定相同的ID，其中一个变化，其它类也会变化
    ///
    /// 通过数据绑定，viewController、viewModel和view可以进一步实现解耦
    ///
    /// 示例：
    ///
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
    ///     override func a_Bind() {
    ///         super.a_Bind()
    ///
    ///         Manage_SetBind("bindID")
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter bindKey: 绑定的ID
    private func Manage_Bind(_ bindKey: String) {
        bindKeyArray.append(bindKey)
    }
    /// 添加多个数据绑定（自动管理）（临时隐藏）
    ///
    /// 框架引入了数据绑定机制。
    ///
    /// 在viewController、viewModel和view中绑定相同的ID，其中一个变化，其它类也会变化
    ///
    /// 通过数据绑定，viewController、viewModel和view可以进一步实现解耦
    ///
    /// 示例：
    ///
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
    ///     override func a_Bind() {
    ///         super.a_Bind()
    ///
    ///         Manage_SetBinds([
    ///             "bind1ID",
    ///             "bind2ID"
    ///         ])
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter bindKeys: 绑定的ID数组
    private func Manage_Binds(_ bindKeys: [String]) {
        for bindKey in bindKeys {
            bindKeyArray.append(bindKey)
        }
    }
    /// 清空所有的数据绑定（临时隐藏）
    private func clearAllBinds() {
        for bindKey in bindKeyArray {
            clearBind(bindKey: bindKey)
        }
    }
    /// 通知的回调方法
    ///
    /// 加入通知后，再此方法中统一完成要实现的代码
    ///
    /// 示例：
    ///
    /// ```swift
    /// override func ANotificationReceive(notification: Notification) {
    ///     super.ANotificationReceive(notification: notification)
    ///
    ///     if notification.name.rawValue == "notificationID" {
    ///         printLog("notificationID")
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter notification: 通知类
    open func ANotificationReceive(notification: Notification) {
        if notification.name.rawValue == AThemeStyle.kNotification_UpdateThemeStyle {
            updateThemeStyle()
        } else if notification.name == UIResponder.keyboardWillShowNotification {
            if keyboardAuto {
                keyboardWillShow(sender: notification)
            } else {
                setKeyboardShowHeight(sender: notification)
                keyboardShow!(notification)
            }
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            if keyboardAuto {
                keyboardWillHide(sender: notification)
            } else {
                keyboardHeight = 0.0
                keyboardHide!(notification)
            }
        }
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            //是否改变
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                ANotification.PostNotification(notificationName: AThemeStyle.kNotification_UpdateThemeStyle, object: Dictionary())
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// 检查支持键盘的view
    ///
    /// __此方法不安全，带入参数的view需支持键盘，例如UILabel__
    ///
    /// - Parameters:
    ///   - view: 检查的view
    ///   - duration: 键盘显示/隐藏的事件间隔
    ///   - auto: 是否自动
    ///   - show: 键盘显示后的回调方法
    ///   - hide: 键盘隐藏后的回调方法
    final public
    func checkKeyboardOnView(view: UIView, duration: CGFloat=0.5, auto: Bool=true, show: ((_ notification: Notification)->Void)?=nil, hide: ((_ notification: Notification)->Void)?=nil) {
        if (keyboardView == nil) {
            isKeyboardEnabled = true
        }
        
        keyboardView = view
        keyboardDuration = duration
        keyboardAuto = auto
        keyboardShow = show
        keyboardHide = hide
    }
    
    private func keyboardWillShow(sender: Notification) {
        setKeyboardShowHeight(sender: sender)
        a_KeyboardWillShow(keyboardHeight: keyboardHeight)
        UIView.animate(withDuration: TimeInterval(keyboardDuration)) { [weak self] () in
            self?.keyboardView?.y(y: self!.screenHeight()-self!.navigationBarMaxY()-self!.keyboardHeight-self!.keyboardView!.height())
        }
    }
    
    private func keyboardWillHide(sender: Notification) {
        keyboardHeight = 0.0
        a_KeyboardWillHide()
        UIView.animate(withDuration: TimeInterval(keyboardDuration)) { [weak self] () in
            self?.keyboardView?.equalBottom(target: self!, offset: self!.navigationBarMaxY()+10)
        }
    }
    
    private func setKeyboardShowHeight(sender: Notification) {
        guard let userInfo = sender.userInfo else { return }
        keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if keyboardAutoHide {
            endEditing(true)
        }
    }
    /// 获取顶层viewController
    /// - Returns: viewController
    open func topViewController() -> UIViewController? {
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
    //MARK: - ABindProcotol
    internal func bindableTo(bindKey: String, attribute: String) {
        bindKeyArray.append(bindKey)
        bindTo(bindKey: bindKey, attribute: attribute)
    }
    /// 数据绑定（被动绑定） - 单向
    ///
    /// 示例：
    ///
    /// ```
    /// 此示例中，当变量fromValue值改变后，toValue随即改变
    ///
    /// 当变量toValue值改变后，fromValue的值不变
    /// ```
    ///
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
    ///     @objc dynamic
    ///     private var fromValue: Bool = false
    ///     @objc dynamic
    ///     private var toValue: Bool = false
    ///
    ///     override func a_Bind() {
    ///         super.a_Bind()
    ///
    ///         bindableFrom(["bindID" : "fromValue"])
    ///         bindableTo(["bindID" : "toValue"])
    ///     }
    /// }
    /// ```
    /// <doc:bindableFrom(_:)>和<doc:bindablesFrom(_:)>绑定的值更新后，此处绑定的数据将更新
    /// - Parameter dict: [绑定ID : 绑定的变量值的字符串]
    public func bindableTo(_ dict: Dictionary<String, String>) {
        let bindKey: String = Array(dict.keys)[0]
        let attribute: String = Array(dict.values)[0]
        
        bindableTo(bindKey: bindKey, attribute: attribute)
    }
    /// 多个数据绑定（被动绑定） - 单向
    ///
    /// 示例：
    /// 
    /// ```
    /// 此示例中，多个bindsFrom设置的变量值改变后，对应bindsTo对应变量值随即改变
    ///
    /// 当变量toValue值改变后，fromValue的值不变
    /// ```
    ///
    /// __TestView.swift__
    /// 
    /// ```swift
    /// class TestView: AView {
    ///     @objc dynamic
    ///     private var fromValue1: Bool = false
    ///     @objc dynamic
    ///     private var fromValue2: Bool = false
    ///     @objc dynamic
    ///     private var toValue1: Bool = false
    ///     @objc dynamic
    ///     private var toValue2: Bool = false
    /// 
    ///     override func a_Bind() {
    ///         super.a_Bind()
    ///
    ///         bindablesFrom(
    ///             ["bindID1" : "fromValue1"],
    ///             ["bindID2" : "fromValue2"]
    ///         )
    ///
    ///         bindablesTo(
    ///             ["bindID1" : "toValue1"],
    ///             ["bindID2" : "toValue2"]
    ///         )
    ///     }
    /// }
    /// ```
    /// <doc:bindableFrom(_:)>和<doc:bindablesFrom(_:)>绑定的值更新后，此处绑定的数据将更新
    /// - Parameter o: 绑定ID和绑定变量值字符串的数组
    public func bindablesTo(_ o: Array<Dictionary<String, String>>) {
        for current: Dictionary<String, String> in o {
            let bindKey: String = Array(current.keys)[0]
            let attribute: String = Array(current.values)[0]
            
            bindableTo(bindKey: bindKey, attribute: attribute)
        }
    }
    
    internal func bindableFrom(bindKey: String, attribute: String) {
        bindKeyArray.append(bindKey)
        bindFrom(bindKey: bindKey, attribute: attribute)
    }
    /// 数据绑定（主动绑定） - 单向
    ///
    /// 示例：
    ///
    /// ```
    /// 此示例中，当变量fromValue值改变后，toValue随即改变
    ///
    /// 当变量toValue值改变后，fromValue的值不变
    /// ```
    ///
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
    ///     @objc dynamic
    ///     private var fromValue: Bool = false
    ///     @objc dynamic
    ///     private var toValue: Bool = false
    ///
    ///     override func a_Bind() {
    ///         super.a_Bind()
    ///
    ///         bindableFrom(["bindID" : "fromValue"])
    ///         bindableTo(["bindID" : "toValue"])
    ///     }
    /// }
    /// ```
    /// <doc:bindableFrom(_:)>和<doc:bindablesFrom(_:)>绑定的值更新后，此处绑定的数据将更新
    /// - Parameter dict: [绑定ID : 绑定的变量值的字符串]
    public func bindableFrom(_ dict: Dictionary<String, String>) {
        let bindKey: String = Array(dict.keys)[0]
        let attribute: String = Array(dict.values)[0]
        
        bindableFrom(bindKey: bindKey, attribute: attribute)
    }
    /// 多个数据绑定（主动绑定） - 单向
    ///
    /// 示例：
    ///
    /// ```
    /// 此示例中，多个bindsFrom设置的变量值改变后，对应bindsTo对应变量值随即改变
    ///
    /// 当变量toValue值改变后，fromValue的值不变
    /// ```
    ///
    /// __TestView.swift__
    ///
    /// ```swift
    /// class TestView: AView {
    ///     @objc dynamic
    ///     private var fromValue1: Bool = false
    ///     @objc dynamic
    ///     private var fromValue2: Bool = false
    ///     @objc dynamic
    ///     private var toValue1: Bool = false
    ///     @objc dynamic
    ///     private var toValue2: Bool = false
    ///
    ///     override func a_Bind() {
    ///         super.a_Bind()
    ///
    ///         bindablesFrom(
    ///             ["bindID1" : "fromValue1"],
    ///             ["bindID2" : "fromValue2"]
    ///         )
    ///
    ///         bindablesTo(
    ///             ["bindID1" : "toValue1"],
    ///             ["bindID2" : "toValue2"]
    ///         )
    ///     }
    /// }
    /// ```
    /// <doc:bindableFrom(_:)>和<doc:bindablesFrom(_:)>绑定的值更新后，此处绑定的数据将更新
    /// - Parameter o: 绑定ID和绑定变量值字符串的数组
    public func bindablesFrom(_ o: Array<Dictionary<String, String>>) {
        for current: Dictionary<String, String> in o {
            let bindKey: String = Array(current.keys)[0]
            let attribute: String = Array(current.values)[0]
            
            bindableFrom(bindKey: bindKey, attribute: attribute)
        }
    }
    
    public func ABind_Keys(_ o: Array<String>) {
        for currentKey: String in o {
            bindKeyArray.append(currentKey)
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
