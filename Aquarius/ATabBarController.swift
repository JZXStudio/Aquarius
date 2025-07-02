//
//  ATabBarController.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/10/21.
//

import UIKit
import Foundation

open class ATabBarController: UITabBarController, ANotificationDelegate {
    private var notification: ANotification = ANotification(notifications: [])
    
    deinit {
        notification.delegate = nil
        
        a_Clear()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
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
        
        a_Delegate()
        updateThemeStyle()
        a_Notification()
        a_Bind()
        a_Observe()
        a_Event()
    }
    
    open func a_Preview() {}
    open func a_Begin() {}
    open func a_Clear() {}
    open func a_UI() {}
    open func a_UIConfig() {}
    open func a_Layout() {}
    open func a_Delegate() {}
    open func a_Notification() {}
    open func a_Bind() {}
    open func a_Observe() {}
    open func a_Event() {}
    open func a_Other() {}
    open func a_End() {}
    open func updateThemeStyle() {}
    open func a_Test() {}
    open func a_Inject() {}
    open func ANotificationReceive(notification: Notification) {
        if notification.name.rawValue == AThemeStyle.kNotification_UpdateThemeStyle {
            updateThemeStyle()
        }
    }
    open func a_viewControllers(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }
}
