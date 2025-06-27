//
//  UIImageView++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/30.
//

import UIKit
import Foundation

public enum ImageViewEqualProperty {
    case image
    case highlightedImage
    case isHighlighted
    case none
}

extension UIImageView {
    internal struct UIImageViewTemp {
        public static var equalProperty: ImageViewEqualProperty = .none
        public static var equalToProperty: ImageViewEqualProperty = .none
        public static var equalTarget: UIView? = nil
    }
    
    public func equal(_ property: ImageViewEqualProperty) {
        if UIImageViewTemp.equalTarget == nil {
            UIImageViewTemp.equalProperty = property
        } else {
            let imageView: UIImageView = UIImageViewTemp.equalTarget as! UIImageView
            switch property {
            case .image:
                imageView.image = self.image
                break
            case .highlightedImage:
                imageView.highlightedImage = self.highlightedImage
                break
            case .isHighlighted:
                imageView.isHighlighted = self.isHighlighted
                break
            default:
                break
            }
            
            UIImageViewTemp.equalTarget = nil
        }
    }
    public func equals(_ properties: Array<ImageViewEqualProperty>) {
        if UIImageViewTemp.equalTarget == nil {
            return
        }
        for currentProperty: ImageViewEqualProperty in properties {
            let imageView: UIImageView = UIImageViewTemp.equalTarget as! UIImageView
            
            switch currentProperty {
            case .image:
                imageView.image = self.image
                break
            case .highlightedImage:
                imageView.highlightedImage = self.highlightedImage
                break
            case .isHighlighted:
                imageView.isHighlighted = self.isHighlighted
                break
            default:
                break
            }
        }
        
        UIImageViewTemp.equalTarget = nil
    }
    
    public func equalTo(_ property: ImageViewEqualProperty) {
        UIImageViewTemp.equalToProperty = property
    }
    
    public func imageViewTarget(_ view: UIView) {
        let imageView: UIImageView = view as! UIImageView
        
        if UIImageViewTemp.equalProperty != .none {
            switch UIImageViewTemp.equalProperty {
            case .image:
                image = imageView.image
                break
            case .highlightedImage:
                highlightedImage = imageView.highlightedImage
                break
            case .isHighlighted:
                isHighlighted = imageView.isHighlighted
                break
            default:
                break
            }
            UIImageViewTemp.equalProperty = .none
        } else {
            UIImageViewTemp.equalTarget = view
        }
        
        if UIImageViewTemp.equalToProperty != .none {
            switch UIImageViewTemp.equalToProperty {
            case .image:
                imageView.image = image
                break
            case .highlightedImage:
                imageView.highlightedImage = highlightedImage
                break
            case .isHighlighted:
                imageView.isHighlighted = isHighlighted
                break
            default:
                break
            }
            UIImageViewTemp.equalToProperty = .none
        }
    }
    
    public func imageViewTargets(_ views: Array<UIView>) {
        for currentView: UIView in views {
            let imageView: UIImageView = currentView as! UIImageView
            
            if UIImageViewTemp.equalToProperty != .none {
                switch UIImageViewTemp.equalToProperty {
                case .image:
                    imageView.image = image
                    break
                case .highlightedImage:
                    imageView.highlightedImage = highlightedImage
                    break
                case .isHighlighted:
                    imageView.isHighlighted = isHighlighted
                    break
                default:
                    break
                }
                UIImageViewTemp.equalToProperty = .none
            }
        }
    }
    
    override public
    func styleDesign(_ design: any DesignStyleProtocol) {
        super.styleDesign(design)
        
        if design.image != nil {
            image = design.image as? UIImage
        }
    }
}
