//
//  UIViewController++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/10/1.
//

import UIKit
import Foundation

extension UIViewController {
    public func pushViewController(viewController: UIViewController, animated: Bool=true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func popViewController(animated: Bool=true) {
        navigationController?.popViewController(animated: animated)
    }
    
    public func interfaceOrientationMask(from deviceOrientation: UIDeviceOrientation) -> UIInterfaceOrientationMask {
        switch deviceOrientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        // 添加其他需要的情况，例如 .faceUp 和 .faceDown，如果需要的话
        default:
            return []
        }
    }
    
    public var AAView: UIView {
        get {
            return self.view
        }
    }
    
    public var ATitle: String? {
        get {
            return self.title
        }
    }
    
    public var AOverrideUserInterfaceStyle: UIUserInterfaceStyle {
        get {
            return self.overrideUserInterfaceStyle
        }
    }
    
    public var AHidesBottomBarWhenPushed: Bool {
        get {
            return self.hidesBottomBarWhenPushed
        }
    }
    
    public var AToolbarItems: [UIBarButtonItem]? {
        get {
            return self.toolbarItems
        }
    }
    
    public var ATabBarItem: UITabBarItem {
        get {
            return self.tabBarItem
        }
    }
    
    public var AIsEditing: Bool {
        get {
            return self.isEditing
        }
    }
    
    public func currentShowViewController() -> UIViewController? {
        if let presentedVC = self.presentedViewController {
            return presentedVC.currentShowViewController()
        }
        if let navController = self as? UINavigationController {
            return navController.visibleViewController?.currentShowViewController()
        }
        if let tabController = self as? UITabBarController {
            return tabController.selectedViewController?.currentShowViewController()
        }
        return self
    }
    //获取上层viewcontroller
    public func getPreviousViewController() -> UIViewController? {
        // 获取当前的父控制器
        if let presentingVC = self.presentingViewController {
            return presentingVC
        } else {
            // 如果没有父控制器，返回 nil
            return nil
        }
    }
}
