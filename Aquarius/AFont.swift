//
//  AFont.swift
//  Aquarius
//
//  Created by JZXStudio on 2024/9/13.
//

import UIKit
import Foundation

open class AFont: NSObject {
    public static let shared = AFont()
    //MARK: - Font
    public var font: UIFont {
        get {
            return UIFont()
        }
    }
}
