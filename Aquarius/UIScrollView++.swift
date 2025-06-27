//
//  UIScrollView++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/10/3.
//

import UIKit
import Foundation

extension UIScrollView {
    public func contentWidth() -> CGFloat {
        return self.contentSize.width
    }
    
    public func contentHeight() -> CGFloat {
        return self.contentSize.height
    }
    
    public func contentOffsets(_ contentOffsets: Array<CGFloat>) {
        self.contentOffset = CGPoint(x: contentOffsets[0], y: contentOffsets[1])
    }
    
    public func contentInsets(_ contentInsets: Array<CGFloat>) {
        self.contentInset = UIEdgeInsets(top: contentInsets[0], left: contentInsets[1], bottom: contentInsets[2], right: contentInsets[3])
    }
    /// 设置是否显示水平滚动条
    /// - Parameter showsHorizontalScrollIndicator: 是否显示，默认为true
    public func showsHorizontalScrollIndicator(_ showsHorizontalScrollIndicator: Bool=true) {
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
    }
    /// 隐藏水平滚动条
    public func hiddenHorizontalScrollIndicator() {
        self.showsHorizontalScrollIndicator = false
    }
    /// 设置是否显示垂直滚动条
    /// - Parameter showsVerticalScrollIndicator: 是否显示，默认为true
    public func showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: Bool=true) {
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
    }
    /// 隐藏垂直滚动条
    public func hiddenVerticalScrollIndicator() {
        self.showsVerticalScrollIndicator = false
    }
    /// 同时显示水平和垂直滚动条
    public func showsHorizontalAndVerticalScrollIndicator() {
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = true
    }
    /// 同时隐藏水平和垂直滚动条
    public func hiddenHorizontalAndVerticalScrollIndicator() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    /// 设置分页滚动
    /// - Parameter isPagingEnabled: 是否分页滚动
    public func isPagingEnabled(_ isPagingEnabled: Bool=true) {
        self.isPagingEnabled = isPagingEnabled
    }
    /// 分页滚动
    public func pagingEnabled() {
        self.isPagingEnabled = true
    }
    /// 禁止分页滚动
    public func pagingUnEnabled() {
        self.isPagingEnabled = false
    }
    /// 设置是否可以滑出空白区域
    /// - Parameter bounces: 是否可以滑出空白区域，默认可以
    public func bounces(_ bounces: Bool=true) {
        self.bounces = bounces
    }
    /// 设置禁止滑出空白区域
    public func unBounces() {
        self.bounces = false
    }
    /// 是否支持垂直滚动
    /// - Parameter alwaysBounceVertical: 是否支持，默认支持
    public func alwaysBounceVertical(_ alwaysBounceVertical: Bool=true) {
        self.alwaysBounceVertical = alwaysBounceVertical
    }
    /// 禁止垂直滚动
    /// - Parameter alwaysBounceVertical: 是否支持，默认支持
    public func neverBounceVertical() {
        self.alwaysBounceVertical = false
    }
    /// 是否支持水平滚动
    /// - Parameter alwaysBounceHorizontal: 是否支持，默认支持
    public func alwaysBounceHorizontal(_ alwaysBounceHorizontal: Bool=true) {
        self.alwaysBounceHorizontal = alwaysBounceHorizontal
    }
    /// 是否支持水平滚动
    public func neverBounceHorizontal() {
        self.alwaysBounceHorizontal = false
    }
    /// 支持水平和垂直滚动
    public func alwaysBounceHorizontalAndVertical() {
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = true
    }
    /// 禁止水平和垂直滚动
    /// - Returns: UIScrollView
    public func a_neverBounceHorizontalAndVertical() {
        self.alwaysBounceHorizontal = false
        self.alwaysBounceVertical = false
    }
}
