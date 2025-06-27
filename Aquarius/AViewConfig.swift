//
//  AViewConfig.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/6/16.
//

import UIKit
import Foundation

open class AViewConfig: AViewBase {
    public let kScreenWidth: CGFloat = UIScreen.main.bounds.width
    public let kScreenHeight: CGFloat = UIScreen.main.bounds.height
    
    override public init() {
        super.init()
        
        self.setup()
    }
    
    private func setup() {
        a_Navigation()
        a_UI()
        a_UIConfig()
        a_Layout()
        a_Delegate()
        a_Notification()
        a_Bind()
        a_Observe()
        a_Event()
        a_Other()
        a_End()
    }
    
    open func a_Navigation() {}
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
}
