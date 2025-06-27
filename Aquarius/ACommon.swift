//
//  ACommon.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/8/23.
//

import UIKit
import MessageUI
import Foundation
import LocalAuthentication

public enum ACommonBiometryType {
    case faceID
    case touchID
    case opticID
    case none
}

open class ACommon: NSObject {
    public static func getAppName() -> String {
        guard let info = Bundle.main.infoDictionary,
              let projectName = info["CFBundleExecutable"] as? String else { return "" }
        let nameSpace = projectName.replacingOccurrences(of: "-", with: "_")
        return nameSpace
    }
    
    public static func getBundleID() -> String {
        guard let info = Bundle.main.infoDictionary,
              let projectName = info["CFBundleIdentifier"] as? String else { return "" }
        return projectName
    }
    
    public static let kScreenSize: CGSize = UIScreen.main.bounds.size
    //获取主工程中的bundle
    public static func GetMainResourceBundle(bundleName: String) -> Bundle? {
        return Bundle(path: Bundle.main.path(forResource: bundleName, ofType: "bundle")!)
    }
    //静态库里的资源
    public static func GetStaticFrameworkResourceBundle(frameworkName: String) -> Bundle? {
        let bundle = Bundle(for: ACommon.self)
        let path = bundle.path(forResource: frameworkName, ofType: "framework")
        if let path = path {
            return Bundle(path: path)
        }
        return nil
    }
    //静态库的bundle里的资源
    public static func getStaticFrameworkBundle(frameworkName: String, bundleName: String) -> Bundle? {
        let bundle: Bundle? = Bundle(for: ACommon.self)
        let path = bundle?.path(forResource: bundleName, ofType: "bundle", inDirectory: frameworkName+".framework")
        
        if let path = path {
            return Bundle(path: path)
        }
        return nil
    }
    //动态库里的资源
    public static func GetDynamicFrameworkResourceBundle(frameworkClass: AnyClass) -> Bundle? {
        return Bundle(for: frameworkClass.self)
    }
    //动态库的bundle里的资源
    public static func GetDynamicFrameworkBundle(frameworkClass: AnyClass, bundleName: String) -> Bundle? {
        let bundle: Bundle? = Bundle(for: ACommon.self)
        let path = bundle?.path(forResource: bundleName, ofType: "bundle")
        if let path = path {
            return Bundle(path: path)
        }
        return nil
    }
    
    public static func getPlistDictionary(name: String, bundle: Bundle) -> [String: Any] {
        guard let categoryListPath = bundle.url(forResource: name, withExtension: "plist") else {
            //print("找不到plist")
            return [:]
        }
        do {
            let  listData = try Data(contentsOf: categoryListPath)
            do {
                let listDictionary = try PropertyListSerialization.propertyList(from: listData, options: [], format: nil) as! [String: Any]
                return listDictionary
            } catch {
                fatalError("plist数据转换失败!")
            }
        } catch {
            fatalError("文件路劲不存在!")
        }
        return [:]
    }
    
    public static func getPlistArrayFromMain(name: String) -> [Any] {
        return getPlistArray(name: name, bundle: Bundle.main)
    }
    
    public static func getPlistArray(name: String, bundle: Bundle) -> Array<Any> {
        guard let categoryListPath = bundle.url(forResource: name, withExtension: "plist") else {
            //print("找不到plist")
            return Array()
        }
        do {
            let  listData = try Data(contentsOf: categoryListPath)
            do {
                let list = try PropertyListSerialization.propertyList(from: listData, options: [], format: nil) as! Array<Any>
                return list
            } catch {
                fatalError("plist数据转换失败!")
            }
        } catch {
            fatalError("文件路劲不存在!")
        }
        return Array()
    }
    /// 判断是touchID还是faceID还是opticID
    /// - Returns: 判断结果
    public static func isBiometryType() -> ACommonBiometryType {
        //该参数必须在canEvaluatePolicy方法后才有值
        let authContent = LAContext()
        var error: NSError?
        if authContent.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if #available(iOS 17.0, *) {
                if authContent.biometryType == .opticID {
                    return .opticID
                }
            }
            //iPhoneX出厂最低系统版本号：iOS11.0.0
            if #available(iOS 11.0, *) {
                if authContent.biometryType == .faceID {
                    return .faceID
                } else if authContent.biometryType == .touchID {
                    return .touchID
                }
            } else {
                guard let laError = error as? LAError else{
                    return .none
                }
                if laError.code != .touchIDNotAvailable {
                    return .touchID
                }
            }
        }
        return .none
    }
    /// 获取alertController
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    ///   - doneTitle: 确定按钮标题
    ///   - cancelTitle: 取消按钮标题
    ///   - doneBlock: 确定按钮回调函数
    ///   - cancelBlock: 取消按钮回调
    /// - Returns: alertController
    public static func getAlertController(title: String = "提示", message: String, doneTitle: String="确定", cancelTitle: String = "", doneBlock: @escaping ()->Void = {}, cancelBlock: @escaping ()->Void = {}) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: doneTitle, style: .default) { action in
            // 在点击按钮时执行的代码
            doneBlock()
        }
        alertController.addAction(okAction)
        if cancelTitle != "" {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
                cancelBlock()
            }
            alertController.addAction(cancelAction)
        }
        
        return alertController
    }
    /// 检测当前运行的是否是模拟器环境
    /// - Returns: 是否模拟器环境
    public static func isSimulator() -> Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
    /// 检测是否越狱
    /// - Returns: 是否越狱状态
    public static func isJailbroken() -> Bool {
        if isSimulator() {
            return false
        }
        
        var isBreak = false
        let breakDir = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/var/lib/cydia",
            "/var/Lib/apt",
            "/var/cache/apt",
            "/private/var/lib/apt/",
            "/etc/apt",
            "/bin/bash",
            "/bin/sh",
            "/usr/sbin/sshd",
            "/usr/libexec/ssh-keysig",
            "/etc/ssh/sshd config"
        ]
        
        for dir in breakDir {
            if FileManager.default.fileExists(atPath: dir ) {
                isBreak = true
            }
        }
        
        let cydiaInstalled = UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
        
        return isBreak || cydiaInstalled
    }
    /// 打开浏览器
    /// - Parameter urlString: 浏览器地址
    /// - Parameter error: 错误回调
    public static func openBrowser(_ urlString: String, error: ((String) -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            if error != nil {
                error!("打开浏览器失败")
            }
            return
        }
        
        openURL(url, errorHandler: error)
    }
    /// 打电话
    /// - Parameter phoneNumber: 电话号码
    /// - Parameter error: 错误回调
    public static func openPhoneCall(_ phoneNumber: String, error: ((String) -> Void)? = nil) {
        guard let phoneCallURL = URL(string: "tel://\(phoneNumber)") else {
            if error != nil {
                error!("无法打电话")
            }
            return
        }
        
        openURL(phoneCallURL)
    }
    
    private static func openURL(_ url: URL, errorHandler: ((String) -> Void)? = nil) {
        // 检查是否可以打开该URL
        if UIApplication.shared.canOpenURL(url) {
            // 打开URL
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        } else {
            if errorHandler != nil {
                errorHandler!("打开URL失败")
            }
        }
    }
    /// 获取发送短信controller
    /// - Parameters:
    ///   - phoneNumbers: 电话号码数组
    ///   - message: 短信内容
    ///   - error: 错误回调
    /// - Returns: 短信界面controller
    public static func messageController(_ phoneNumbers: [String], _ message: String, error: ((String) -> Void)? = nil) -> MFMessageComposeViewController? {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = message
            messageVC.recipients = phoneNumbers // 可以是单个字符串或字符串数组 设置委托以处理发送完成后的回调
            return messageVC
        } else {
            // 如果设备不支持发送短信，可以给出提示
            if error != nil {
                error!("无法发送短信")
            }
            return nil
        }
    }
    /// 获取邮件controller
    /// - Parameters:
    ///   - recipients: 邮件地址数组
    ///   - subject: 主题
    ///   - message: 内容
    ///   - error: 错误回调
    /// - Returns: 邮件controller
    public static func mailController(recipients: [String], subject: String, message: String, error: ((String) -> Void)? = nil) -> MFMailComposeViewController? {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(recipients) // 收件人地址
            mail.setSubject(subject) // 邮件主题
            mail.setMessageBody(message, isHTML: false) // 邮件内容，可以设置成HTML格式
                
            return mail
        } else {
            // 设备不支持发送邮件，可以提示用户配置邮箱或者使用其他方式发送邮件
            if error != nil {
                error!("无法发送邮件，请配置邮箱账户。")
            }
            
            return nil
        }
    }
}
