//
//  AAppStore.swift
//  Aquarius
//
//  Created by SONG JIN on 2025/10/11.
//
import StoreKit
import Foundation

open class AAppStore {
    public static var shared: AAppStore = AAppStore()
    /// 调用系统的评分窗口
    public func openReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    /// 跳转到appstore的评分和评论窗口
    ///
    /// **appID的获取方式：**
    ///
    /// 1. 打开电脑的**Appstore**，搜索你的app
    /// 2. 进入app的详细信息页面，点击**导出**，选择**拷贝**
    /// 3. 打开浏览器，**粘贴**拷贝的内容，在内容中，找到**id**后面的一串数字，该**数字**即为**appID**
    ///
    /// **注意：**
    ///
    /// 此方法需在真机测试
    ///
    /// - Parameter appID: app的ID
    public func openReviewInAppStore(appID: String?) {
        if appID == nil {
            return
        }
        
        ACommon.openBrowser("itms-apps://apps.apple.com/app/id\(appID!)?action=write-review")
    }
    
}
