//
//  A.swift
//  Aquarius
//
//  Created by SONG JIN on 2023/1/16.
//

import UIKit
import Foundation

public enum AEqualProperty {
    case alpha
    case textAlignment
    case font
    case bold
    case italic
    case none
}

public struct A {
    
    /// 只在debug模式时执行的函数体
    /// - Parameter block: 函数体
    public static func DEBUG(_ block: (() -> Void)) {
        #if DEBUG
        block()
        #endif
    }
    
    /// 分别在debug模式下执行和在release下执行的函数体
    /// - Parameters:
    ///   - debug: debug模式下的函数体
    ///   - RELEASE: release模式下的函数体
    public static func DEBUG(_ debug: (() -> Void), RELEASE: (() -> Void)) {
        #if DEBUG
        debug()
        #else
        RELEASE()
        #endif
    }
    /// 进入后台时调用
    public static let kApplicationDidEnterBackground: String = "kApplicationDidEnterBackground"
    /// 即将进入前台时调用
    public static let kApplicationWillEnterForeground: String = "kApplicationWillEnterForeground"
    /// 即将终止时调用
    public static let kApplicationWillTerminate: String = "kApplicationWillTerminate"
    /// 后台回到前台时调用
    public static let kApplicationDidBecomeActive: String = "kApplicationDidBecomeActive"
    
    /// 快速创建UI组件
    public static var ui: AUI = AUI.shared
    /// 快速创建颜色实例
    public static var color: AColor = AColor.shared
    /// 快速创建图片实例
    public static var image: AImage = AImage.shared
    /// 快速创建字体实例
    public static var font: AFont = AFont.shared
    /// 快速创建本地存储实例
    public static var userDefaults: AUserDefaults = AUserDefaults.shared
    /// 快速创建日历实例
    public static var calendar: ACalendar = ACalendar.shared
    /// 快速创建日历事件实例
    public static var calendarEvent: ACalendarEvent = ACalendarEvent.shared
    /// 快速创建提醒事件实例
    public static var reminderEvent: AReminderEvent = AReminderEvent.shared
    /// 快速创建文件实例
    public static var file: AFile = AFile.shared
    /// 快速创建app信息实例
    public static var app: AApp = AApp.shared
    /// 快速创建支付实例
    public static var iap: AIap = AIap.shared
    
    public static var log: ALogger = ALogger.shared
}
