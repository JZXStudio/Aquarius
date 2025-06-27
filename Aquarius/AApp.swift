//
//  AApp.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/12/13.
//

import Foundation

open class AApp: NSObject {
    public static let shared = AApp()
    
    public var appName: String {
        get {
            Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "未知名称"
        }
    }
    
    public var version: String {
        get {
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "未知版本"
        }
    }
    
    public var build: String {
        get {
            Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "未知构建版本"
        }
    }
}
