//
//  ALayout.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/4/19.
//

import Foundation

@available(*, deprecated, message: "此方法已弃用")
open class ALayout: NSObject, LayoutProtocol {
    
}

@objc
public protocol LayoutProtocol {
    @objc optional var x: CGFloat { get set }
    @objc optional var y: CGFloat { get set }
    @objc optional var width: CGFloat { get set }
    @objc optional var height: CGFloat { get set }
    @objc optional var point: CGPoint { get set }
    @objc optional var size: CGSize { get set }
    @objc optional var frame: CGRect { get set }
}
