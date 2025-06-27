//
//  Array+aLayout.swift
//  Aquarius
//
//  Created by SONG JIN on 2025/4/24.
//
import UIKit
import Foundation

extension Array<UIView> {
    public func width(width: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        for currentView: UIView in self {
            currentView.width(width: width, animate: animate, duration: duration)
        }
    }
    
    public func width(width: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, _ index: Int) {
        let view: UIView = self.getView(index)
        view.width(width: width, animate: animate, duration: duration)
    }
    
    public func height(height: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        for currentView: UIView in self {
            currentView.height(height: height, animate: animate, duration: duration)
        }
    }
    
    public func height(height: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, _ index: Int) {
        let view: UIView = self.getView(index)
        view.height(height: height, animate: animate, duration: duration)
    }
    
    public func equalWidth(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        for currentView: UIView in self {
            currentView.equalWidth(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalWidth(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, _ index: Int) {
        let view: UIView = self.getView(index)
        view.equalWidth(target: target, animate: animate, duration: duration)
    }
    
    public func equalHeight(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        for currentView: UIView in self {
            currentView.equalHeight(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalHeight(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, _ index: Int) {
        let view: UIView = self.getView(index)
        view.equalHeight(target: target, animate: animate, duration: duration)
    }
    
    public func equalLeft(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        for currentView: UIView in self {
            currentView.equalLeft(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalLeft(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, _ index: Int) {
        let view: UIView = self.getView(index)
        view.equalLeft(target: target, animate: animate, duration: duration)
    }
    
    public func equalRight(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        for currentView: UIView in self {
            currentView.equalRight(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalRight(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, _ index: Int) {
        let view: UIView = self.getView(index)
        view.equalRight(target: target, animate: animate, duration: duration)
    }
    
    public func alignTop(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        let array: Array<UIView> = self
        for currentView: UIView in array {
            currentView.alignTop(view: view, offset: offset, animate: animate, duration: duration)
        }
    }
    
    public func alignTop(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration, _ index: Int) {
        let view: UIView = self.getView(index)
        view.alignTop(view: view, offset: offset, animate: animate, duration: duration)
    }
    
    public func alignBottom(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        for currentView: UIView in self {
            currentView.alignBottom(view: view, offset: offset, animate: animate, duration: duration)
        }
    }
    
    public func alignBottom(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration, _ index: Int) {
        let view: UIView = self.getView(index)
        view.alignBottom(view: view, offset: offset, animate: animate, duration: duration)
    }
    
    public func alignLeft(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        for currentView: UIView in self {
            currentView.alignLeft(view: view, offset: offset, animate: animate, duration: duration)
        }
    }
    
    public func alignLeft(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration, _ index: Int) {
        let view: UIView = self.getView(index)
        view.alignLeft(view: view, offset: offset, animate: animate, duration: duration)
    }
    
    public func alignRight(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        for currentView: UIView in self {
            currentView.alignRight(view: view, offset: offset, animate: animate, duration: duration)
        }
    }
    
    public func alignRight(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration, _ index: Int) {
        let view: UIView = self.getView(index)
        view.alignRight(view: view, offset: offset, animate: animate, duration: duration)
    }
}
