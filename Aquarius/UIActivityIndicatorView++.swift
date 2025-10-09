//
//  UIActivityIndicatorView++.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/11/22.
//
import UIKit
import Foundation

extension UIActivityIndicatorView {
    public func showAndStartAnimating() {
        startAnimating()
        isShow()
    }
    
    public func hiddenAndStopAnimating() {
        stopAnimating()
        isHidden()
    }
    
    public func mediumStyle() {
        self.style = .medium
    }
    
    public func largeStyle(){
        self.style = .large
    }
}
