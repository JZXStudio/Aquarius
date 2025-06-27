//
//  AFont.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/9/13.
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
