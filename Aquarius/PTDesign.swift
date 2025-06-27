//
//  ProtoTypeDesign.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/4/1.
//

import UIKit
import Foundation

public enum ProtoType {
    //实心
    case solid
    //空心
    case hollow
}

extension UIButton {
    public func prototypeDesign(_ protoType: ProtoType = .solid) {
        if protoType == .solid {
            self.backgroundColor = 0x999999.toColor
            self.setTitleColor(0xFFFFFF.toColor, for: .normal)
            self.titleLabel?.fontBold(true)
            
            self.layer.cornerRadius = 8.0
        } else {
            self.setTitleColor(0x7A7A7A.toColor, for: .normal)
            self.titleLabel?.fontBold(true)
            
            self.layer.borderWidth = 1.0
            self.layer.borderColor = 0x999999.toColor.cgColor
            self.layer.cornerRadius = 4.0
        }
    }
}

extension UIView {
    public func aa_prototypeDesign(_ protoType: ProtoType = .solid) {
        if protoType == .solid {
            self.backgroundColor = 0x999999.toColor
            self.layer.cornerRadius = 4.0
        } else {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = 0x999999.toColor.cgColor
            self.layer.cornerRadius = 4.0
        }
    }
}

public enum ProtoLabelType {
    case title
    case subTitle
    case content
    case subContent
}

extension UILabel {
    public func prototypeDesign(_ type: ProtoLabelType = .content) {
        if type == .title {
            self.font = UIFont.boldSystemFont(ofSize: 32.0)
            self.textColor = 0x333333.toColor
        } else if type == .subTitle {
            self.font = UIFont.boldSystemFont(ofSize: 16.0)
            self.textColor = 0x333333.toColor
        } else if type == .content {
            self.font = UIFont.boldSystemFont(ofSize: 24.0)
            self.textColor = 0x999999.toColor
        } else {
            self.font = UIFont.boldSystemFont(ofSize: 16.0)
            self.textColor = 0x999999.toColor
        }
    }
}

extension UIImageView {
    public func prototypeDesign() {
        self.layer.cornerRadius = 8.0
    }
}

public enum TableViewCellProtoType {
    case largeAll
    case middleAll
    case middleNoArrowNoIcon
    case middleNoArrow
    case middleNoSubTitle
    case smallAll
    case smallNoIcon
}

extension ATableViewCell {
    internal struct ATableViewCellTemp {
        public static let iconImageView: UIImageView = A.ui.imageView
        public static let titleLabel: UILabel = A.ui.label
        public static let subTitleLabel: UILabel = A.ui.label
        public static let rightArrowImageView: UIImageView = A.ui.imageView
    }
    
    public func prototypeDesign(_ type: TableViewCellProtoType) {
        if type == .largeAll {
            self.height(height: 62.0)
            
            ATableViewCellTemp.iconImageView.size(widthHeight: 34.0)
            ATableViewCellTemp.iconImageView.left(left: 12.0)
            ATableViewCellTemp.iconImageView.center(y:( height()-ATableViewCellTemp.iconImageView.height())/2)
            ATableViewCellTemp.iconImageView.backgroundColor = 0x999999.toColor
            ATableViewCellTemp.iconImageView.layer.cornerRadius = 8.0
            
            ATableViewCellTemp.titleLabel.width(width: 200.0)
            ATableViewCellTemp.titleLabel.equalHeight(target: ATableViewCellTemp.iconImageView)
            ATableViewCellTemp.titleLabel.alignLeft(view: ATableViewCellTemp.iconImageView, offset: 12.0)
            ATableViewCellTemp.titleLabel.equalTop(target: ATableViewCellTemp.iconImageView)
            ATableViewCellTemp.titleLabel.textColor = 0x333333.toColor
            ATableViewCellTemp.titleLabel.textAlignment = .left
            ATableViewCellTemp.titleLabel.boldFont(20.0)
            
            ATableViewCellTemp.rightArrowImageView.size(widthHeight: 24.0)
            ATableViewCellTemp.rightArrowImageView.left(left: screenWidth()-width()-12)
            ATableViewCellTemp.rightArrowImageView.center(y: (height()-ATableViewCellTemp.rightArrowImageView.height())/2)
            
            ATableViewCellTemp.subTitleLabel.width(width: 100.0)
            ATableViewCellTemp.subTitleLabel.equalHeight(target: ATableViewCellTemp.iconImageView)
            ATableViewCellTemp.subTitleLabel.alignRight(view: ATableViewCellTemp.rightArrowImageView)
            ATableViewCellTemp.subTitleLabel.textColor = 0x999999.toColor
            ATableViewCellTemp.subTitleLabel.textAlignment = .left
            ATableViewCellTemp.subTitleLabel.font(16.0)
            
            addSubviewsInContentView(views: [
                ATableViewCellTemp.iconImageView,
                ATableViewCellTemp.titleLabel,
                ATableViewCellTemp.rightArrowImageView,
                ATableViewCellTemp.subTitleLabel
            ])
        } else if type == .middleAll {
            
        } else if type == .middleNoArrowNoIcon {
            
        } else if type == .middleNoArrow {
            
        } else if type == .middleNoSubTitle {
            
        } else if type == .smallAll {
            
        } else if type == .smallNoIcon {
            
        }
    }
}
