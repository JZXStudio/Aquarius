//
//  UIView+aLayout.swift
//  Aquarius
//
//  Created by SONG JIN on 2025/4/24.
//
import UIKit
import Foundation

extension UIView {
    public static func top(views: Array<UIView>, position: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if position == 0 {
            var currentPosition: CGFloat = 0
            for currentView: UIView in views {
                if currentPosition == 0 {
                    currentPosition = currentView.top()
                } else {
                    if currentView.top() < currentPosition {
                        currentPosition = currentView.top()
                    }
                }
            }
            for currentView: UIView in views {
                currentView.top(top: currentPosition, animate: animate, duration: duration)
            }
        } else {
            for currentView: UIView in views {
                currentView.top(top: position, animate: animate, duration: duration)
            }
        }
    }
    
    public static func bottom(views: Array<UIView>, position: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if position == 0 {
            var currentPosition: CGFloat = 0
            for currentView: UIView in views {
                if currentPosition == 0 {
                    currentPosition = currentView.bottom()
                } else {
                    if currentView.bottom() > currentPosition {
                        currentPosition = currentView.bottom()
                    }
                }
            }
            for currentView: UIView in views {
                currentView.bottom(bottom: currentPosition, animate: animate, duration: duration)
            }
        } else {
            for currentView: UIView in views {
                currentView.bottom(bottom: position, animate: animate, duration: duration)
            }
        }
    }
    
    public static func left(views: Array<UIView>, position: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if position == 0 {
            var currentPosition: CGFloat = 0
            for currentView: UIView in views {
                if currentPosition == 0 {
                    currentPosition = currentView.left()
                } else {
                    if currentView.left() < currentPosition {
                        currentPosition = currentView.left()
                    }
                }
            }
            for currentView: UIView in views {
                currentView.left(left: currentPosition, animate: animate, duration: duration)
            }
        } else {
            for currentView: UIView in views {
                currentView.left(left: position, animate: animate, duration: duration)
            }
        }
    }
    
    public static func right(views: Array<UIView>, position: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if position == 0 {
            var currentPosition: CGFloat = 0
            for currentView: UIView in views {
                if currentPosition == 0 {
                    currentPosition = currentView.right()
                } else {
                    if currentView.right() > currentPosition {
                        currentPosition = currentView.right()
                    }
                }
            }
            for currentView: UIView in views {
                currentView.right(right: currentPosition, animate: animate, duration: duration)
            }
        } else {
            for currentView: UIView in views {
                currentView.right(right: position, animate: animate, duration: duration)
            }
        }
    }
    
    public static func horizontal(views: Array<UIView>, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if views.count > 2 {
            var viewsWidth: CGFloat = 0
            let distance: CGFloat = views[views.count-1].left()-views[0].right()
            var index: Int = 0
            for currentView: UIView in views {
                if index > 0 && index < views.count-1 {
                    viewsWidth += currentView.width()
                }
                index += 1
            }
            let space: CGFloat = (distance - viewsWidth) / CGFloat((views.count - 1))
            index = 0
            for currentView: UIView in views {
                if index > 0 && index < views.count {
                    currentView.left(left: (viewsWidth + space), animate: animate, duration: duration)
                }
                viewsWidth = currentView.right()
                index += 1
            }
        }
    }
    
    public static func topAndHorizontal(views: Array<UIView>, position: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                UIView.top(views: views, position: position)
                UIView.horizontal(views: views)
            }
        } else {
            UIView.top(views: views, position: position)
            UIView.horizontal(views: views)
        }
    }
    
    public static func bottomAndHorizontal(views: Array<UIView>, position: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                UIView.bottom(views: views, position: position)
                UIView.horizontal(views: views)
            }
        } else {
            UIView.bottom(views: views, position: position)
            UIView.horizontal(views: views)
        }
    }
    
    public static func vertical(views: Array<UIView>, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if views.count > 2 {
            var viewsHeight: CGFloat = 0
            let distance: CGFloat = views[views.count-1].top()-views[0].bottom()
            var index: Int = 0
            for currentView: UIView in views {
                if index > 0 && index < views.count-1 {
                    viewsHeight += currentView.height()
                }
                index += 1
            }
            let space: CGFloat = (distance - viewsHeight) / CGFloat((views.count - 1))
            index = 0
            for currentView: UIView in views {
                if index > 0 && index < views.count {
                    currentView.top(top: (viewsHeight + space), animate: animate, duration: duration)
                }
                viewsHeight = currentView.top()
                index += 1
            }
        }
    }
    
    public static func leftAndVertical(views: Array<UIView>, position: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                UIView.left(views: views, position: position)
                UIView.vertical(views: views)
            }
        } else {
            UIView.left(views: views, position: position)
            UIView.vertical(views: views)
        }
    }
    
    public static func rightAndVertical(views: Array<UIView>, position: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                UIView.right(views: views, position: position)
                UIView.vertical(views: views)
            }
        } else {
            UIView.right(views: views, position: position)
            UIView.vertical(views: views)
        }
    }
    
    public func x() -> CGFloat {
        return self.frame.origin.x
    }
    
    public func x(x: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.origin.x = x
            }
        } else {
            self.frame.origin.x = x
        }
    }
    
    public static func x(x: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.x(x: x, animate: animate, duration: duration)
        }
    }
    
    public func y() -> CGFloat {
        return self.frame.origin.y
    }
    
    public func y(y: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.origin.y = y
            }
        } else {
            self.frame.origin.y = y
        }
    }
    
    public static func y(y: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.y(y: y, animate: animate, duration: duration)
        }
    }
    
    public func width() -> CGFloat {
        return self.frame.size.width
    }
    
    public func width(width: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.size.width = width
            }
        } else {
            self.frame.size.width = width
        }
    }
    
    public static func width(width: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.width(width: width, animate: animate, duration: duration)
        }
    }
    /// 自动计算view的宽度
    /// - Parameters:
    ///   - endPoint: 目标点
    ///   - animate: 是否有动画，默认为false
    ///   - duration: 动画间隔时间，默认为0.3秒
    public func autoWidth(endPoint: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.size.width = endPoint - self.frame.origin.x
            }
        } else {
            self.frame.size.width = endPoint - self.frame.origin.x
        }
    }
    /// 自动计算当前view的宽度
    /// - Parameters:
    ///   - view: 目标view
    ///   - animate: 是否有动画，默认为false
    ///   - duration: 动画间隔时间，默认为0.3秒
    public func autoWidth(view: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.size.width = view.frame.origin.x - self.frame.origin.x
            }
        } else {
            self.frame.size.width = view.frame.origin.x - self.frame.origin.x
        }
    }
    
    public func setScreenWidth(animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.size.width = self.screenWidth()
            }
        } else {
            self.frame.size.width = self.screenWidth()
        }
    }
    
    public func height() -> CGFloat {
        return self.frame.size.height
    }
    
    public func height(height: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.size.height = height
            }
        } else {
            self.frame.size.height = height
        }
    }
    
    public static func height(height: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.height(height: height, animate: animate, duration: duration)
        }
    }
    /// 自动计算当前view的高度
    /// - Parameters:
    ///   - endPoint: 目标点
    ///   - animate: 是否有动画，默认为false
    ///   - duration: 动画间隔时间，默认0.3秒
    public func autoHeight(endPoint: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.size.height = endPoint - self.frame.origin.y
            }
        } else {
            self.frame.size.height = endPoint - self.frame.origin.y
        }
    }
    /// 自动计算当前view的高度
    /// - Parameters:
    ///   - view: 目标UIView
    ///   - animate: 是否有动画，默认为false
    ///   - duration: 动画间隔时间，默认0.3秒
    public func autoHeight(view: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.size.height = view.frame.origin.y - self.frame.origin.y
            }
        } else {
            self.frame.size.height = view.frame.origin.y - self.frame.origin.y
        }
    }
    
    public func setScreenHeight(animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.size.height = self.screenHeight()
            }
        } else {
            self.frame.size.height = self.screenHeight()
        }
    }
    
    public func left() -> CGFloat {
        return self.x()
    }
    
    public func left(left: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.x(x: left, animate: animate, duration: duration)
    }
    
    public func topAndLeft(topAndLeft: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.x(x: topAndLeft, animate: animate, duration: duration)
        self.y(y: topAndLeft, animate: animate, duration: duration)
    }
    
    public static func left(left: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.left(left: left, animate: animate, duration: duration)
        }
    }
    
    public func top() -> CGFloat {
        return self.y()
    }
    
    public func top(top: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.y(y: top, animate: animate, duration: duration)
    }
    /// 设置组件的中心点在另外一个组件的中心点
    /// - Parameters:
    ///   - top: 另一个组件的高
    ///   - animate: 是否有动画
    ///   - duration: 动画时间
    public func centerTop(height: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        let top: CGFloat = (height-self.height())/2
        self.y(y: top, animate: animate, duration: duration)
    }
    /// 设置组件的中心点在另外一个组件的中心点
    /// - Parameters:
    ///   - view: 另一个组件
    ///   - animate: 是否有动画
    ///   - duration: 动画时间
    public func centerTop(view: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        let top: CGFloat = (view.height()-self.height())/2
        self.y(y: top, animate: animate, duration: duration)
    }
    /// 设置组件的中心点在另外一个组件的中心点
    /// - Parameters:
    ///   - width: 另一个组件的宽
    ///   - animate: 是否有动画
    ///   - duration: 动画时间
    public func centerLeft(width: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        let left: CGFloat = (width-self.width())/2
        self.x(x: left, animate: animate, duration: duration)
    }
    /// 设置组件的中心点在另外一个组件的中心点
    /// - Parameters:
    ///   - view: 另一个组件
    ///   - animate: 是否有动画
    ///   - duration: 动画时间
    public func centerLeft(view: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        let left: CGFloat = (view.width()-self.width())/2
        self.x(x: left, animate: animate, duration: duration)
    }
    
    public static func top(top: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.top(top: top, animate: animate, duration: duration)
        }
    }
    
    public func right() -> CGFloat {
        return self.x() + self.width()
    }
    
    public func right(right: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.x(x: (right - self.width()), animate: animate, duration: duration)
    }
    
    public static func right(right: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.right(right: right, animate: animate, duration: duration)
        }
    }
    
    public func bottom() -> CGFloat {
        return self.y() + self.height()
    }
    
    public func bottom(bottom: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.y(y: (bottom - self.height()), animate: animate, duration: duration)
    }
    
    public static func bottom(bottom: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.bottom(bottom: bottom, animate: animate, duration: duration)
        }
    }
    
    public func point() -> CGPoint {
        return self.frame.origin
    }
    
    public func point(x: CGFloat, y: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.origin = CGPoint(x: x, y: y)
            }
        } else {
            self.frame.origin = CGPoint(x: x, y: y)
        }
    }
    
    public static func point(x: CGFloat, y: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.point(x: x, y: y, animate: animate, duration: duration)
        }
    }
    
    //当x和y坐标相同时，使用
    public func point(xy: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.point(x: xy, y: xy, animate: animate, duration: duration)
    }
    
    public static func point(xy: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.point(xy: xy, animate: animate, duration: duration)
        }
    }
    
    public func point(points: Array<CGFloat>, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.point(x: points[0], y: points[1], animate: animate, duration: duration)
    }
    
    public static func point(points: Array<CGFloat>, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.point(points: points, animate: animate, duration: duration)
        }
    }
    
    public func point(point: CGPoint, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.point(x: point.x, y: point.y, animate: animate, duration: duration)
    }
    
    public static func point(point: CGPoint, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.point(point: point, animate: animate, duration: duration)
        }
    }
    
    public func size() -> CGSize {
        return self.frame.size
    }
    
    public func size(width: CGFloat, height: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.size = CGSize(width: width, height: height)
            }
        } else {
            self.frame.size = CGSize(width: width, height: height)
        }
    }
    
    public static func size(width: CGFloat, height: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.size(width: width, height: height, animate: animate, duration: duration)
        }
    }
    
    public func size(w: CGFloat, h: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame.size = CGSize(width: w, height: h)
            }
        } else {
            self.frame.size = CGSize(width: w, height: h)
        }
    }
    
    public static func size(w: CGFloat, h: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.size(w: w, h: h, animate: animate, duration: duration)
        }
    }
    
    public func size(sizes: Array<CGFloat>, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.size(width: sizes[0], height: sizes[1], animate: animate, duration: duration)
    }
    
    public static func size(sizes: Array<CGFloat>, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.size(sizes: sizes, animate: animate, duration: duration)
        }
    }
    
    public func size(size: CGSize, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.size(width: size.width, height: size.height, animate: animate, duration: duration)
    }
    
    public static func size(size: CGSize, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.size(size: size, animate: animate, duration: duration)
        }
    }
    //当宽和高相同时，使用
    public func size(widthHeight: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.size(width: widthHeight, height: widthHeight, animate: animate, duration: duration)
    }
    
    public static func size(widthHeight: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.size(widthHeight: widthHeight, animate: animate, duration: duration)
        }
    }
    
    public func frame() -> CGRect {
        return self.frame
    }
    
    @objc
    public func frame(frame: CGRect, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.frame = frame
        if animate {
            UIView.animate(withDuration: duration) {
                self.frame = frame
            }
        } else {
            self.frame = frame
        }
    }
    
    public static func frame(frame: CGRect, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.frame(frame: frame, animate: animate, duration: duration)
        }
    }
    
    @objc
    public func frame(frames: Array<CGFloat>, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.frame(frame: CGRect(x: frames[0], y: frames[1], width: frames[2], height: frames[3]), animate: animate, duration: duration)
    }
    
    public static func frame(frames: Array<CGFloat>, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.frame(frames: frames, animate: animate, duration: duration)
        }
    }
    
    @objc
    public func frame(xy: CGFloat, widthHeight: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.frame(frame: CGRect(x: xy, y: xy, width: widthHeight, height: widthHeight), animate: animate, duration: duration)
    }
    
    public static func frame(xy: CGFloat, widthHeight: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.frame(xy: xy, widthHeight: widthHeight, animate: animate, duration: duration)
        }
    }
    
    @objc
    public func frame(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.frame(frame: CGRect(x: x, y: y, width: w, height: h), animate: animate, duration: duration)
    }
    
    public static func frame(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.frame(x: x, y: y, w: w, h: h, animate: animate, duration: duration)
        }
    }
    
    public func centerX() -> CGFloat {
        return x() + width() / 2
    }
    
    public func centerY() -> CGFloat {
        return y() + height() / 2
    }
    
    public func center(x: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.x(x: (x - width() / 2), animate: animate, duration: duration)
    }
    
    public static func center(x: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.center(x: x, animate: animate, duration: duration)
        }
    }
    
    public func center(y: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.y(y: (y - height()) / 2, animate: animate, duration: duration)
    }
    
    public static func center(y: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.center(y: y, animate: animate, duration: duration)
        }
    }
    
    public func center(point: CGPoint, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        center(x: point.x, animate: animate, duration: duration)
        center(y: point.y, animate: animate, duration: duration)
    }
    
    public static func center(point: CGPoint, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.center(point: point, animate: animate, duration: duration)
        }
    }
    
    public func center(view: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        center(point: CGPoint(x: view.centerX(), y: view.centerY()), animate: animate, duration: duration)
    }
    
    public static func center(view: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.center(view: view, animate: animate, duration: duration)
        }
    }
    
    public func centerX(view: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        center(x: view.centerX(), animate: animate, duration: duration)
    }
    
    public static func centerX(view: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.centerX(view: view, animate: animate, duration: duration)
        }
    }
    
    public func centerY(view: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        center(y: view.bottom(), animate: animate, duration: duration)
    }
    
    public static func centerY(view: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.centerY(view: view, animate: animate, duration: duration)
        }
    }
    //废弃 - self改变，target不变
    public func align(target: UIView, direction: GradientDirection = .Vertial, offset: CGFloat = 0) {
        switch direction {
        case .Horizontal:
            self.top(top: target.top())
            self.left(left: target.right()+offset)
        case .Vertial:
            self.left(left: target.left())
            self.top(top: target.bottom()+offset)
        }
    }
    //废弃 - self不变，to变
    public func align(to: UIView, direction: GradientDirection = .Vertial, offset: CGFloat = 0) {
        switch direction {
        case .Horizontal:
            to.top(top: self.top())
            to.left(left: self.right()+offset)
        case .Vertial:
            to.left(left: self.left())
            to.top(top: self.bottom()+offset)
        }
    }
    //废弃- 根据offset自动调整间距。只固定第一个UIView，其余跟着改变
    public static func aligns(views: Array<UIView>, direction: GradientDirection = .Vertial, offset: CGFloat = 0) {
        for i in 1..<views.count {
            var targetView: UIView
            if i == 1 {
                targetView = views[0]
            } else {
                targetView = views[i-1]
            }
            let toView: UIView = views[i]
            targetView.align(to: toView, direction: direction, offset: offset)
        }
    }
    //废弃 - 根据view里的宽度或高度自动计算offset并自动调整间距。第一个和最后一个UIView固定，中间的跟着改变
    public static func fixAligns(fixViews: Array<UIView>, direction: GradientDirection = .Vertial) {
        let offset: CGFloat = UIView.layoutOffset(views: fixViews, direction: direction)
        UIView.aligns(views: fixViews, direction: direction, offset: offset)
    }
    //直接通过数组进行赋值，数组里的顺序分别是x, y, width, height
    public func alignRect(rect:Array<CGFloat>) {
        for i in 0..<rect.count {
            if rect[i] == EMPTY {
                continue
            }
            
            if i == 0 {
                self.x(x: rect[i])
            } else if i == 1 {
                self.y(y: rect[i])
            } else if i == 2 {
                self.width(width: rect[i])
            } else if i == 3 {
                self.height(height: rect[i])
            } else {
                return
            }
        }
    }
    
    public static func alignRect(rect:Array<CGFloat>, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.alignRect(rect: rect)
        }
    }
    //直接通过数组进行赋值，数组里放的是UIView组件，的顺序分别是view.left(), view.top(), view.width(), view.height()
    public func alignRect(views:Array<UIView>) {
        for i in 0..<views.count {
            let view: UIView? = views[i]
            if view == nil {
                continue
            }
            
            if i == 0 {
                self.x(x: views[i].left())
            } else if i == 1 {
                self.y(y: views[i].top())
            } else if i == 2 {
                self.width(width: views[i].width())
            } else if i == 3 {
                self.height(height: views[i].height())
            } else {
                return
            }
        }
    }
    //views2为批量的view
    public static func alignRect(views1:Array<UIView>, views2: Array<UIView>) {
        for currentView: UIView in views2 {
            currentView.alignRect(views: views1)
        }
    }
    //直接通过数组进行赋值，数组里放的可能是数值可能是UIView组件，如果是数值的话，直接赋值，如果是UIView的话，顺序分别是view.left(), view.top(), view.width(), view.height()
    public func alignRect(mix:Array<Any>) {
        
        for i in 0..<mix.count {
            let mirror = Mirror(reflecting: mix[i].self)
            if mirror.subjectType == Double.self || mirror.subjectType == Int.self {
                var value = EMPTY
                if mirror.subjectType == Double.self {
                    value = mix[i] as! CGFloat
                } else if mirror.subjectType == Int.self {
                    value = CGFloat(mix[i] as! Int)
                }
                
                if value == EMPTY {
                    continue
                }
               
                if i == 0 {
                    self.x(x: value)
                } else if i == 1 {
                    self.y(y: value)
                } else if i == 2 {
                    self.width(width: value)
                } else if i == 3 {
                    self.height(height: value)
                } else {
                    return
                }
            } else {
                let view: UIView? = mix[i] as? UIView
                if view == nil {
                    continue
                }
                
                if i == 0 {
                    self.x(x: view!.left())
                } else if i == 1 {
                    self.y(y: view!.top())
                } else if i == 2 {
                    self.width(width: view!.width())
                } else if i == 3 {
                    self.height(height: view!.height())
                } else {
                    return
                }
            }
        }
    }
    
    public static func alignRect(mix:Array<Any>, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.alignRect(mix: mix)
        }
    }
    
    public func alignTop(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.top(top: (view.bottom()+offset), animate: animate, duration: duration)
    }
    
    public static func alignTop(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.alignTop(view: view, offset: offset, animate: animate, duration: duration)
        }
    }
    
    public func alignBottom(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.bottom(bottom: (view.top()-offset), animate: animate, duration: duration)
    }
    
    public static func alignBottom(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.alignBottom(view: view, offset: offset, animate: animate, duration: duration)
        }
    }
    
    public func alignLeft(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.left(left: (view.right()+offset), animate: animate, duration: duration)
    }
    
    public static func alignLeft(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.alignLeft(view: view, offset: offset, animate: animate, duration: duration)
        }
    }
    
    public func alignRight(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.right(right: (view.left()-offset), animate: animate, duration: duration)
    }
    
    public static func alignRight(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.alignRight(view: view, offset: offset, animate: animate, duration: duration)
        }
    }
    
    public func layout(topView: UIView, offset: CGFloat = 0) {
        self.equalTop(target: topView, offset: offset)
    }
    
    public static func layout(topView: UIView, offset: CGFloat = 0, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layout(topView: topView, offset: offset)
        }
    }
    
    public func layout(bottomView: UIView, offset: CGFloat = 0) {
        self.equalBottom(target: bottomView, offset: offset)
    }
    
    public static func layout(bottomView: UIView, offset: CGFloat = 0, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layout(bottomView: bottomView, offset: offset)
        }
    }
    
    public func layout(leftView: UIView, offset: CGFloat = 0) {
        self.equalLeft(target: leftView, offset: offset)
    }
    
    public static func layout(leftView: UIView, offset: CGFloat = 0, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layout(leftView: leftView, offset: offset)
        }
    }
    
    public func layout(rightView: UIView, offset: CGFloat = 0) {
        self.equalRight(target: rightView, offset: offset)
    }
    
    public static func layout(rightView: UIView, offset: CGFloat = 0, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layout(rightView: rightView, offset: offset)
        }
    }
    //当前UIView在中间，根据offset自动变更width
    public func layoutWidth(first: UIView, end: UIView, offset: CGFloat = 0) {
        self.width(width: end.left()-first.right()-offset*2)
    }
    
    public static func layoutWidth(first: UIView, end: UIView, offset: CGFloat = 0, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layoutWidth(first: first, end: end, offset: offset)
        }
    }
    //当前UIView在中间，根据offset自动变更height
    public func layoutHeight(first: UIView, end: UIView, offset: CGFloat = 0) {
        self.height(height: end.top()-first.bottom()-offset*2)
    }
    
    public static func layoutHeight(first: UIView, end: UIView, offset: CGFloat = 0, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.layoutHeight(first: first, end: end, offset: offset)
        }
    }
    //固定第一个和最后一个UIView，计算中间的offset
    public static func layoutOffset(views: Array<UIView>, direction: GradientDirection = .Vertial) -> CGFloat {
        let first: UIView = views[0]
        let end: UIView = views[views.count-1]
        var firstPosition: CGFloat {
            get {
                switch direction {
                case .Horizontal:
                    return first.right()
                case .Vertial:
                    return first.bottom()
                }
            }
        }
        var endPosition: CGFloat {
            get {
                switch direction {
                case .Horizontal:
                    return end.left()
                case .Vertial:
                    return end.top()
                }
            }
        }
        
        var middleDistance: CGFloat = 0
        for i in 1...views.count-2 {
            switch direction {
            case .Horizontal:
                middleDistance = middleDistance + views[i].width()
                break
            case .Vertial:
                middleDistance = middleDistance + views[i].height()
                break
            }
        }
        
        return (endPosition - firstPosition - middleDistance) / CGFloat(views.count-1)
    }
    
    public func equalSize(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.size(size: target.size(), animate: animate, duration: duration)
    }
    
    public static func equalSize(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.equalSize(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalPoint(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.point(point: target.point(), animate: animate, duration: duration)
    }
    
    public static func equalPoint(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.equalPoint(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalTop(target: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.top(top: (target.top()+offset), animate: animate, duration: duration)
    }
    
    public static func equalTop(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.equalTop(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalBottom(target: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.bottom(bottom: (target.bottom()-offset), animate: animate, duration: duration)
    }
    
    public static func equalBottom(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.equalBottom(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalLeft(target: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.left(left: (target.left()+offset), animate: animate, duration: duration)
    }
    
    public static func equalLeft(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.equalLeft(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalRight(target: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.right(right: (target.right()-offset), animate: animate, duration: duration)
    }
    
    public static func equalRight(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.equalRight(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalWidth(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.width(width: target.width(), animate: animate, duration: duration)
    }
    
    public static func equalWidth(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.equalWidth(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalHeight(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.height(height: target.height(), animate: animate, duration: duration)
    }
    
    public static func equalHeight(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.equalHeight(target: target, animate: animate, duration: duration)
        }
    }
    
    public func equalRect(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration) {
        self.frame(frame: target.frame(), animate: animate, duration: duration)
    }
    
    public static func equalRect(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration, views: Array<UIView>) {
        for currentView: UIView in views {
            currentView.equalRect(target: target, animate: animate, duration: duration)
        }
    }
    
    public func screenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    public func screenWidth() -> CGFloat {
        return self.screenSize().width
    }
    
    public static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    public func screenHeight() -> CGFloat {
        return self.screenSize().height
    }
    
    public func screenHeightNoStatus() -> CGFloat {
        return screenHeight()-statusBarHeight()
    }
    
    public func screenHeightNoNavigation() -> CGFloat {
        return screenHeight()-navigationBarHeight()
    }
    
    public func screenHeightNoStatusNoNavigation() -> CGFloat {
        return screenHeight()-statusBarHeight()-navigationBarHeight()
    }
    
    public func screenHeightNoSafeAreaFooter() -> CGFloat {
        return screenHeight()-safeAreaFooterHeight()
    }
    
    public func screenHeightNoTabBar() -> CGFloat {
        return screenHeight()-tabBarHeight()
    }
    
    public func screenHeightNoStatusNoSafeAreaFooter() -> CGFloat {
        return screenHeightNoStatus()-safeAreaFooterHeight()
    }
    
    public func screenHeightNoStatusNoTabBar() -> CGFloat {
        return screenHeightNoStatus()-tabBarHeight()
    }
    
    public func screenHeightNoStatusNoSafeAreaFooterNoTabBar() -> CGFloat {
        return screenHeightNoStatus()-safeAreaFooterHeight()-tabBarHeight()
    }
    
    public func screenHeightNoNavigationNoSafeAreaFooter() -> CGFloat {
        return screenHeightNoNavigation()-safeAreaFooterHeight()
    }
    
    public func screenHeightNoNavigationNoTabBar() -> CGFloat {
        return screenHeightNoNavigation()-tabBarHeight()
    }
    
    public func screenHeightNoNavigationNoSafeAreaFooterNoTabBar() -> CGFloat {
        return screenHeightNoNavigation()-safeAreaFooterHeight()-tabBarHeight()
    }
    
    public func screenHeightNoStatusNoNavigationNoSafeAreaFooter() -> CGFloat {
        return screenHeightNoStatusNoNavigation()-safeAreaFooterHeight()
    }
    
    public func screenHeightNoStatusNoNavigationNoTabBar() -> CGFloat {
        return screenHeightNoStatusNoNavigation()-tabBarHeight()
    }
    
    public func screenHeightNoStatusNoNavigationNoSafeAreaFooterNoTabBar() -> CGFloat {
        return screenHeightNoStatusNoNavigation()-safeAreaFooterHeight()-tabBarHeight()
    }
    
    public static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    public func equalZeroLeft() {
        self.left(left: 0.0)
    }
    
    public func equalZeroTop() {
        self.top(top: 0.0)
    }
    
    public func equalZeroTopAndLeft() {
        equalZeroTop()
        equalZeroLeft()
    }
    
    public func equalScreenSize() {
        self.size(size: screenSize())
    }
    
    public func equalScreenWidth(_ offset: CGFloat=0.0) {
        self.width(width: screenWidth()-offset)
    }
    
    public func equalScreenHeight(_ offset: CGFloat=0.0) {
        self.height(height: screenHeight()-offset)
    }
    
    public func equalScreenHeightNoStatus(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoStatus()-offset)
    }
    
    public func equalScreenHeightNoNavigation(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoNavigation()-offset)
    }
    
    public func equalScreenHeightNoStatusNoNavigation(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoStatusNoNavigation()-offset)
    }
    
    public func equalScreenHeightNoSafeAreaFooter(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoSafeAreaFooter()-offset)
    }
    
    public func equalScreenHeightNoTabBar(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoTabBar()-offset)
    }
    
    public func equalScreenHeightNoStatusNoSafeAreaFooter(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoStatusNoSafeAreaFooter()-offset)
    }
    
    public func equalScreenHeightNoStatusNoTabBar(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoStatusNoTabBar()-offset)
    }
    
    public func equalScreenHeightNoStatusNoSafeAreaFooterNoTabBar(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoStatusNoSafeAreaFooterNoTabBar()-offset)
    }
    
    public func equalScreenHeightNoNavigationNoSafeAreaFooter(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoNavigationNoSafeAreaFooter()-offset)
    }
    
    public func equalScreenHeightNoNavigationNoTabBar(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoNavigationNoTabBar()-offset)
    }
    
    public func equalScreenHeightNoNavigationNoSafeAreaFooterNoTabBar(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoNavigationNoSafeAreaFooterNoTabBar()-offset)
    }
    
    public func equalScreenHeightNoStatusNoNavigationNoSafeAreaFooter(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoStatusNoNavigationNoSafeAreaFooter()-offset)
    }
    
    public func equalScreenHeightNoStatusNoNavigationNoTabBar(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoStatusNoNavigationNoTabBar()-offset)
    }
    
    public func equalScreenHeightNoStatusNoNavigationNoSafeAreaFooterNoTabBar(_ offset: CGFloat=0.0) {
        height(height: screenHeightNoStatusNoNavigationNoSafeAreaFooterNoTabBar()-offset)
    }
    
    public func betweenX(view: UIView) -> CGFloat {
        if view.left() > self.right() {
            return view.left() - self.right()
        } else if self.left() > view.right() {
            return self.left() - view.right()
        }
        return 0
    }
    
    public func betweenY(view: UIView) -> CGFloat {
        if view.top() > self.bottom() {
            return view.top() - self.bottom()
        } else if self.top() > view.bottom() {
            return self.top() - view.bottom()
        }
        return 0
    }
    
    public static func betweenX(view1: UIView, view2: UIView) -> CGFloat {
        if view1.left() > view2.right() {
            return view1.left() - view2.right()
        } else if view2.left() > view1.right() {
            return view2.left() - view1.right()
        }
        return 0
    }
    
    public static func betweenY(view1: UIView, view2: UIView) -> CGFloat {
        if view1.top() > view2.bottom() {
            return view1.top() - view2.bottom()
        } else if view2.top() > view1.bottom() {
            return view2.top() - view1.bottom()
        }
        return 0
    }
    
    public func safeAreaHeaderHeight() -> CGFloat {
        let verticalSafeAreaInset: CGFloat
        if #available(iOS 11.0, *) {
          verticalSafeAreaInset = self.safeAreaInsets.bottom + self.safeAreaInsets.top
        } else {
          verticalSafeAreaInset = 0.0
        }
        return verticalSafeAreaInset
    }
    
    public func safeAreaFooterHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets
            let bottomSafeAreaHeight = safeAreaInsets?.bottom ?? 0
            //let bottomNavigationBarHeight = bottomSafeAreaHeight > 0 ? bottomSafeAreaHeight : 49
            return bottomSafeAreaHeight
        }
        return 0;
    }
    
    public static func safeAreaFooterHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets
            let bottomSafeAreaHeight = safeAreaInsets?.bottom ?? 0
            //let bottomNavigationBarHeight = bottomSafeAreaHeight > 0 ? bottomSafeAreaHeight : 49
            return bottomSafeAreaHeight
        }
        return 0;
    }
    
    public func statusBarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            let statusManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
            return statusManager?.statusBarFrame.height ?? 20.0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    public static func statusBarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            let statusManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
            return statusManager?.statusBarFrame.height ?? 20.0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    public func navigationBarHeight() -> CGFloat {
        return 44.0
    }
    
    public static func navigationBarHeight() -> CGFloat {
        return 44.0
    }
    
    public func navigationBarMaxY() -> CGFloat {
        return 44 + self.statusBarHeight()
    }
    
    public func tabBarHeight() -> CGFloat {
        let tabBarVC = UITabBarController()
        return tabBarVC.tabBar.height()
    }
}
