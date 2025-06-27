//
//  ATableViewHeaderFooterView.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/10/23.
//

import UIKit
import Foundation

open class ATableViewHeaderFooterView: UITableViewHeaderFooterView, ANotificationDelegate {
    private var notification: ANotification = ANotification(notifications: [])
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let customView = UIView(frame: self.contentView.frame)
        self.contentView.addSubview(customView)
        
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        a_InternalClear()
        a_Clear()
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
    
    open func a_Inject() {
        //a_Clear()
        setup()
    }
    
    open func a_Preview() {}
    open func a_Begin() {}
    private func a_InternalClear() {
        notification.clearNotifications()
        notification.delegate = nil
    }
    open func a_Clear() {}
    open func a_UI() {}
    open func a_UIConfig() {}
    open func a_Layout() {}
    open func a_Notification() {}
    open func a_Delegate() {}
    open func a_Bind() {}
    open func a_Event() {}
    open func a_Other() {}
    open func a_End() {}
    open func updateThemeStyle() {}
    open func a_Test() {}
    open func ANotificationReceive(notification: Notification) {
        if notification.name.rawValue == AThemeStyle.kNotification_UpdateThemeStyle {
            updateThemeStyle()
        }
    }
}
