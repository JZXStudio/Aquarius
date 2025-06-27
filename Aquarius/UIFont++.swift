//
//  UIFont++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/20.
//

import UIKit
import Foundation

extension UIFont {
    @discardableResult public
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    @discardableResult public
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
    @discardableResult public
    func with(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {

        guard let fd = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }

        return UIFont(descriptor: fd, size: pointSize)
    }
    @discardableResult public
    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
