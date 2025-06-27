//
//  UINavigationItem++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/10/3.
//

import UIKit
import Foundation

public enum NavigationItemEqualProperty {
    case title
    case backBarButtonItem
    case backButtonTitle
    case titleView
    case none
}

extension UINavigationItem {
    internal struct UINavigationItemTemp {
        public static var equalProperty: NavigationItemEqualProperty = .none
        public static var equalToProperty: NavigationItemEqualProperty = .none
        public static var equalTarget: UINavigationItem? = nil
    }
    
    public func equal(_ property: NavigationItemEqualProperty) {
        if UINavigationItemTemp.equalTarget == nil {
            UINavigationItemTemp.equalProperty = property
        } else {
            let navigationItem: UINavigationItem = UINavigationItemTemp.equalTarget!
            switch UINavigationItemTemp.equalToProperty {
            case .title:
                navigationItem.title = self.title
                break
            case .backBarButtonItem:
                navigationItem.backBarButtonItem = self.backBarButtonItem
                break
            case .backButtonTitle:
                navigationItem.backButtonTitle = self.backButtonTitle
                break
            case .titleView:
                navigationItem.titleView = self.titleView
                break
            default:
                break
            }
            
            UINavigationItemTemp.equalTarget = nil
        }
    }
    
    public func equals(_ properties: Array<NavigationItemEqualProperty>) {
        if UINavigationItemTemp.equalTarget == nil {
            return
        }
        for currentProperty: NavigationItemEqualProperty in properties {
            let navigationItem: UINavigationItem = UINavigationItemTemp.equalTarget!
            switch currentProperty {
            case .title:
                navigationItem.title = self.title
                break
            case .backBarButtonItem:
                navigationItem.backBarButtonItem = self.backBarButtonItem
                break
            case .backButtonTitle:
                navigationItem.backButtonTitle = self.backButtonTitle
                break
            case .titleView:
                navigationItem.titleView = self.titleView
                break
            default:
                break
            }
        }
        
        UINavigationItemTemp.equalTarget = nil
    }
    
    public func equalTo(_ property: NavigationItemEqualProperty) {
        UINavigationItemTemp.equalToProperty = property
    }
    
    public func target(_ navigationItem: UINavigationItem) {
        if UINavigationItemTemp.equalProperty != .none {
            switch UINavigationItemTemp.equalProperty {
            case .title:
                self.title = navigationItem.title
                break
            case .backBarButtonItem:
                self.backBarButtonItem = navigationItem.backBarButtonItem
                break
            case .backButtonTitle:
                self.backButtonTitle = navigationItem.backButtonTitle
                break
            case .titleView:
                titleView = navigationItem.titleView
                break
            default:
                break
            }
            UINavigationItemTemp.equalProperty = .none
        } else {
            UINavigationItemTemp.equalTarget = navigationItem
        }
        
        if UINavigationItemTemp.equalToProperty != .none {
            switch UINavigationItemTemp.equalToProperty {
            case .title:
                navigationItem.title = self.title
                break
            case .backBarButtonItem:
                navigationItem.backBarButtonItem = self.backBarButtonItem
                break
            case .backButtonTitle:
                navigationItem.backButtonTitle = self.backButtonTitle
                break
            case .titleView:
                navigationItem.titleView = titleView
                break
            default:
                break
            }
            UINavigationItemTemp.equalToProperty = .none
        }
    }
    
    public func targets(_ navigationItems: Array<UINavigationItem>) {
        for currentNavigationItem: UINavigationItem in navigationItems {
            if UINavigationItemTemp.equalToProperty != .none {
                switch UINavigationItemTemp.equalToProperty {
                case .title:
                    currentNavigationItem.title = self.title
                    break
                case .backBarButtonItem:
                    currentNavigationItem.backBarButtonItem = self.backBarButtonItem
                    break
                case .backButtonTitle:
                    currentNavigationItem.backButtonTitle = self.backButtonTitle
                    break
                case .titleView:
                    currentNavigationItem.titleView = self.titleView
                    break
                default:
                    break
                }
            }
        }
        
        UINavigationItemTemp.equalToProperty = .none
    }
    
    public func leftBarButtonItemTintColor(_ tintColor: UIColor) {
        leftBarButtonItem?.tintColor = tintColor
    }
    
    public func rightBarButtonItemTintColor(_ tintColor: UIColor) {
        rightBarButtonItem?.tintColor = tintColor
    }
}
