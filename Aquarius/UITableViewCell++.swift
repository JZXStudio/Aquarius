//
//  UITableViewCell++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/10/1.
//

import UIKit
import Foundation

extension UITableViewCell {
    override public
    func styleDesign(_ design: DesignStyleProtocol) {
        super.styleDesign(design)
        
        if design.accessoryType != nil {
            accessoryType = design.accessoryType as! UITableViewCell.AccessoryType
        }
        
        if design.textLabelFont != nil {
            textLabelFont(design.textLabelFont as! UIFont)
        }
        
        if design.textLabelColor != nil {
            textLabelColor(design.textLabelColor as! UIColor)
        }
        
        if design.textLabelText != nil {
            textLabelText(design.textLabelText as! String)
        }
        
        if design.detailTextLabelFont != nil {
            detailTextLabelFont(design.detailTextLabelFont as! UIFont)
        }
        
        if design.detailTextLabelColor != nil {
            detailTextLabelColor(design.detailTextLabelColor as! UIColor)
        }
        
        if design.detailTextLabelText != nil {
            detailTextLabelText(design.detailTextLabelText as! String)
        }
    }
    
    public func selectedBackgroundColor(_ selectedBackgroundColor: UIColor) {
        self.selectedBackgroundView?.backgroundColor = selectedBackgroundColor
    }
    
    public func textLabelFont(_ textLabelFont: UIFont) {
        textLabel?.font = textLabelFont
    }
    
    public func textLabelColor(_ textLabelColor: UIColor) {
        textLabel?.textColor = textLabelColor
    }
    
    public func textLabelText(_ textLabelText: String) {
        textLabel?.text = textLabelText
    }
    
    public func detailTextLabelFont(_ detailTextLabelFont: UIFont) {
        detailTextLabel?.font = detailTextLabelFont
    }
    
    public func detailTextLabelColor(_ detailTextLabelColor: UIColor) {
        detailTextLabel?.textColor = detailTextLabelColor
    }
    
    public func detailTextLabelText(_ detailTextLabelText: String) {
        detailTextLabel?.text = detailTextLabelText
    }
}
