//
//  AImage.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/9/13.
//

import UIKit
import Foundation

open class AImage: NSObject {
    public static let shared = AImage()
    //MARK: - Image
    public var image: UIImage {
        get {
            return UIImage()
        }
    }
    
    public func systemImage(systemName: String) -> UIImage? {
        return UIImage(systemName: systemName)
    }
}
