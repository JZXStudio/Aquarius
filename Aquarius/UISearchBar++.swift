//
//  UISearchBar++.swift
//  Aquarius
//
//  Created by SONG JIN on 2023/12/18.
//

import UIKit
import Foundation

extension UISearchBar {
    override public
    func styleDesign(_ design: DesignStyleProtocol) {
        super.styleDesign(design)
        
        if design.placeholder != nil {
            placeholder = design.placeholder as? String
        }
        
        if design.barTintColor != nil {
            barTintColor = design.barTintColor as? UIColor
        }
    }
    
    public func placeholderColor(_ placeholderColor: UIColor) {
        let textfield = self.value(forKey: "searchField") as! UITextField
        textfield.placeHolderColor = placeholderColor
    }
    
    public func textColor(_ textColor: UIColor) {
        let textfield = self.value(forKey: "searchField") as! UITextField
        textfield.textColor = textColor
    }
    
    public func setIconImage(_ image: UIImage) {
        setImage(image, for: .search, state: .normal)
    }
}
