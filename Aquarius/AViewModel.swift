//
//  AViewModel.swift
//  Aquarius
//
//  Created by SONG JIN on 2021/6/21.
//

import UIKit
import Combine
import Foundation

/// viewModel的基类（MVVM）
///
/// 主要包括：
/// + 分层管理
/// + Delegate管理
/// + 通知管理
/// + 数据绑定管理
/// + 日志管理
/// + 热更新管理
open class AViewModel: AViewBase, ObservableObject, ANotificationDelegate {
    internal var delegateManagers: Array<Dictionary<String, AnyObject>> = []
    /// 管理Observe
    ///
    /// __主要用于viewController中__
    ///
    /// 示例：
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
    public var kvo: NSKeyValueObservation? {
        willSet {
            kvos.append(newValue)
        }
    }
    private var kvos: Array<NSKeyValueObservation?> = []
    
    private var c_observes: Array<Dictionary<String, AnyObject>> = Array()
    
    internal var coreNotification: ANotification = ANotification()
        
    internal let logger: ALogger = ALogger()
    /// 缓存viewController（弱引用）
    public weak var viewController: AViewController? = nil
    
    deinit {
        a_InternalClear()
        a_Clear()
    }
    
    override public init() {
        super.init()
        
        self.coreNotification.delegate = self;
        
        self.a_Notification()
        self.a_Delegate()
        self.a_Observe()
        self.a_Bind()
        self.a_Other()
        self.a_End()
        
        A.DEBUG { [weak self] in
            self?.a_Test()
        }
    }
    /// 设置通知的方法
    ///
    /// __在此方法中完成通知设置__
    ///
    /// __通过<doc:AViewModel/Manage_SetNotification(_:)>或者<doc:AViewModel/Manage_SetNotifications(_:)>方法完成通知的设置将在页面销毁时自动销毁，无需手动销毁__
    ///
    /// 示例：
    ///
    /// __TestVM.swift__
    ///
    /// ```swift
    /// class TestVM: AViewModel {
    ///     override func a_Notification() {
    ///         super.a_Notification()
    ///
    ///         Manage_SetNotification("notificationID")
    ///         Manage_SetNotifications([
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
    /// __一般UI的delegate比较多，所以一般的使用场景是在viewController中使用a_Delegate方法，只有某些特殊场景下，需要在viewModel中实现，所以viewModel中此方法的实现较少__
    ///
    /// __建议所有的Delegate均在viewController中完成__
    ///
    /// __通过<doc:AViewModel/Manage_SetDelegate(targetObject:delegateName:object:)>或者<doc:AViewModel/Manage_SetDelegate(targetObject:delegateNames:object:)>完成Delegate设置将在页面销毁时自动销毁，无需手动销毁__
    ///
    /// 示例：
    ///
    /// __TestVM.swift__
    ///
    /// ```swift
    /// class TestVM: AViewModel {
    ///     override func a_Delegate() {
    ///         super.a_Delegate()
    ///
    ///         viewModel.Manage_SetDelegate(
    ///             targetObject: testTableView,
    ///             delegateName: AProtocol.delegate,
    ///             object: self
    ///         )
    ///     }
    /// }
    /// ```
    open func a_Delegate() {}
    /// 设置Observe的方法
    ///
    /// __建议所有的Observe均在viewController中完成__
    ///
    /// 示例：
    ///
    /// __TestVM.swift__
    ///
    /// ```swift
    /// class TestVM: AViewModel {
    ///     @objc dynamic
    ///     public var observeTag_RefreshData: Bool = false
    ///
    ///     override func a_Observe() {
    ///         super.a_Observe()
    ///
    ///         kvo = observe(\.observeTag_RefreshData,
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
    /// 额外的一些页面设置在此方法中完成
    open func a_Other() {}
    /// 结尾的一些页面设置在此方法中完成
    open func a_End() {}
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
    
    private func a_InternalClear() {
        super.a_Clear()
        
        for delegateDict: Dictionary<String, AnyObject> in delegateManagers {
            let key: String = Array(delegateDict.keys)[0]
            let anyObject: AnyObject = Array(delegateDict.values)[0]
            anyObject.setValue(nil, forKey: key)
        }
        self.delegateManagers.removeAll()
        
        kvos.removeAll()
        self.clearObserves()
        self.c_observes.removeAll()
        
        self.coreNotification.clearNotifications()
        self.coreNotification.delegate = nil
        
        viewController = nil
        
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
    /// __TestVM.swift__
    ///
    /// ```swift
    /// class TestVM: AViewModel {
    ///     override func a_Clear() {
    ///         super.a_Clear()
    ///
    ///         printLog("a_Clear")
    ///     }
    /// }
    /// ```
    open override func a_Clear() {}
    
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
    /// 针对此种情况，框架在viewModel中加入了自动管理Delegate的机制。在实际使用中，只需要调用此方法或<doc:Manage_SetDelegate(targetObject:delegateNames:object:)>即可加入自动管理中，无需再关心销毁问题
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
    /// __此方法建议在<doc:AViewController/a_Delegate()>中使用__
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
    /// 针对此种情况，框架在viewModel中加入了自动管理Delegate的机制。在实际使用中，只需要调用此方法或<doc:Manage_SetDelegate(targetObject:delegateName:object:)>即可加入自动管理中，无需再关心销毁问题
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
    /// __此方法建议在<doc:AViewController/a_Delegate()>中使用__
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
    /// 由于viewModel加入了自动管理Delegate的机制，所以使用<doc:Manage_SetDelegate(targetObject:delegateName:object:)>或<doc:Manage_SetDelegate(targetObject:delegateNames:object:)>后除特殊情况，不必手动删除
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
    /// 由于viewModel加入了自动管理Delegate的机制，所以使用<doc:Manage_SetDelegate(targetObject:delegateName:object:)>或<doc:Manage_SetDelegate(targetObject:delegateNames:object:)>后除特殊情况，不必手动删除
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
        coreNotification.addNotification(notificationName: notificationName)
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
        coreNotification.addNotifications(notificationNames: notificationNames)
    }
    /// 删除自动管理的通知
    ///
    /// 由于viewModel加入了自动管理通知的机制，所以使用<doc:Manage_SetNotification(_:)>或<doc:Manage_SetNotifications(_:)>后除特殊情况，不必手动删除
    ///
    /// - Parameter notificationName: 通知ID
    public func Manage_DeleteNotification(_ notificationName: String) {
        coreNotification.removeNotification(notificationName: notificationName)
    }
    /// 删除自动管理的多个通知
    ///
    /// 由于viewModel加入了自动管理通知的机制，所以使用<doc:Manage_SetNotification(_:)>或<doc:Manage_SetNotifications(_:)>后除特殊情况，不必手动删除
    ///
    /// - Parameter notificationNames: 通知ID数组
    public func Manage_DeleteNotifications(_ notificationNames: Array<String>) {
        coreNotification.removeNotifications(notificationNames: notificationNames)
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
    open func ANotificationReceive(notification: Notification) {}
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
    /// __TestVM.swift__
    ///
    /// ```swift
    /// class TestVM: AViewModel {
    ///     override func a_Bind() {
    ///         super.a_Bind()
    ///
    ///         viewModel.Manage_SetBind("bindID")
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
    /// __TestVM.swift__
    ///
    /// ```swift
    /// class TestVM: AViewModel {
    ///     override func a_Bind() {
    ///         super.a_Bind()
    ///
    ///         viewModel.Manage_SetBinds([
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
    
    open func addObserves(observers: Array<Dictionary<String, AnyObject>>) {
        for dict: Dictionary<String, AnyObject> in observers {
            let o: AnyObject = Array(dict.values)[0] as AnyObject
            let key: String = Array(dict.keys)[0] as String
            
            o.addObserver(self, forKeyPath: key, context: nil)
        }
        
        self.c_observes = observers
    }
    
    private func clearObserves() {
        for dict: Dictionary<String, AnyObject> in self.c_observes {
            let o: AnyObject = Array(dict.values)[0] as AnyObject
            let key: String = Array(dict.keys)[0] as String
            
            o.removeObserver(self, forKeyPath: key, context: nil)
        }
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
