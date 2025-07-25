//
//  ANavigationController.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/10/31.
//

import UIKit
import Foundation

open class ANavigationController: UINavigationController, ANotificationDelegate {
    private var notification: ANotification = ANotification(notifications: [])
    
    deinit {
        a_InternalClear()
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
}
