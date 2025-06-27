//
//  Data++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/28.
//

import UIKit
import Foundation

extension Data {
    public func toImage() -> UIImage? {
        return UIImage(data: self)
    }
}
