//
//  ACollectionViewCell.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/21.
//

import UIKit
import Foundation

open class ACollectionViewCell: UICollectionViewCell, ANotificationDelegate {
    private var notification: ANotification?
    
    deinit {
        a_Clear()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
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
    }
    
    open func a_Preview() {}
    open func a_Begin() {}
    open func a_Clear() {
        self.clearBind()
        
        self.notification?.removeNotification(notificationName: AThemeStyle.kNotification_UpdateThemeStyle)
        self.notification?.delegate = nil
    }
    
    open func a_UI() {}
    open func a_UIConfig() {}
    open func a_Layout() {}
    open func a_Notification() {}
    open func a_Delegate() {}
    open func a_Observe() {}
    open func a_Bind() {}
    open func a_Event() {}
    open func a_Other() {}
    open func a_End() {}
    open func updateThemeStyle() {}
    open func configWithCell(cellData: Any) {}
    
    public func addSubviewInContentView(view: UIView) {
        contentView.addSubview(view)
    }
    
    public func removeSubviewInContentView(view: UIView) {
        view.removeFromSuperview()
    }
    
    public func addSubviewsInContentView(views: Array<UIView>) {
        contentView.addSubviews(views: views)
    }
    
    public func removeSubviewsInContentView(views: Array<UIView>) {
        contentView.removeSubviews(views: views)
    }
    
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
    
    public func addNotification(notificationNames: Array<String>) {
        notification?.addNotifications(notificationNames: notificationNames)
    }
    
    public func addNotification(notificationName: String) {
        notification?.addNotification(notificationName: notificationName)
    }
    
    open func ANotificationReceive(notification: Notification) {
        if notification.name.rawValue == AThemeStyle.kNotification_UpdateThemeStyle {
            self.updateThemeStyle()
        }
    }
}
