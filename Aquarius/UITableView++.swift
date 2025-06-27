//
//  UITableView++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/23.
//

import UIKit
import Foundation

extension UITableView {
    private struct UITableViewTemp {
        static var emptyView: EmptyView = EmptyView()
        static var isInsertEmptyView: Bool = false
        static weak var emptyDelegate: EmptyDelegate?
    }
    
    public var emptyDelegate: EmptyDelegate? {
        get {
            return UITableViewTemp.emptyDelegate
        }
        set {
            UITableViewTemp.emptyDelegate = newValue
            
            emptyView.isHidden = self.numberOfSections != 0
            if emptyView.isHidden {
                tableFooterView = emptyView
                let emptyImage: UIImage? = UITableViewTemp.emptyDelegate?.emptyImage?(self)
                if (emptyImage != nil) {
                    emptyView.imageView.image = emptyImage!
                }
                let emptyLabelAttributeString: NSAttributedString? = UITableViewTemp.emptyDelegate?.emptyTitle?(self)
                if (emptyLabelAttributeString != nil) {
                    emptyView.label.attributedText = emptyLabelAttributeString
                }
                
                let customView: UIView? = UITableViewTemp.emptyDelegate?.emptyCustomView?(self)
                if (customView != nil) {
                    emptyView.addSubview(customView!)
                    emptyView.imageView.isHidden = true
                    emptyView.label.isHidden = true
                    
                    customView?.center(view: emptyView.button)
                }
                
                emptyView.button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            }
        }
    }
    
    private var emptyView: EmptyView {
        get {
            return UITableViewTemp.emptyView
        }
        set {
            UITableViewTemp.emptyView = newValue
            
            if !UITableViewTemp.isInsertEmptyView {
                insertSubview(UITableViewTemp.emptyView, at: 0)
                UITableViewTemp.isInsertEmptyView = true
                
                UITableViewTemp.emptyView.center(view: self)
            }
        }
    }
    
    @objc func buttonClick() {
        UITableViewTemp.emptyDelegate?.emptyDidTap?(self)
    }
    // - 设置cell圆角
    // - Parameters:
    //  - cell: cell
    //  - indexPath: indexPath
    //  - tableView: tableView
    public func setCornerRadiusForSectionCell(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView, cornerRadius: CGFloat) {
        let sectionCount = tableView.numberOfRows(inSection: indexPath.section)
        //当前分区有多行数据时
        if sectionCount > 1 {
            switch indexPath.row {
            /** 如果是第一行,左上、右上角为圆角**/
            case 0:
                cell.createCorner(CGSize(width: cornerRadius, height: cornerRadius), UIRectCorner(rawValue: (UIRectCorner.topLeft.rawValue)|(UIRectCorner.topRight.rawValue)))
                break
    /** 如果是最后一行,左下、右下角为圆角**/
            case sectionCount - 1 :
                cell.createCorner(CGSize(width: cornerRadius,height: cornerRadius),UIRectCorner(rawValue: (UIRectCorner.bottomLeft.rawValue)|(UIRectCorner.bottomRight.rawValue)))
                break
            default:
                break
            }
        }
        //当前分区只有一行行数据时
        else {
            cell.createCorner(CGSize(width: cornerRadius, height: cornerRadius), UIRectCorner(rawValue: (UIRectCorner.bottomLeft.rawValue)|(UIRectCorner.bottomRight.rawValue)|(UIRectCorner.topLeft.rawValue)|(UIRectCorner.topRight.rawValue)))
        }
    }
    // - 设置带section的cell圆角（第一个上方不是圆角，最后一个是圆角）
    // - Parameters:
    //  - cell: cell
    //  - indexPath: indexPath
    //  - tableView: tableView
    public func setCornerRadiusWithSectionCell(cell: UITableViewCell, indexPath: IndexPath, cornerRadius: CGFloat) {
        let sectionCount = self.numberOfRows(inSection: indexPath.section)
        //当前分区有多行数据时
        if sectionCount > 1 {
            switch indexPath.row {
    /** 如果是最后一行,左下、右下角为圆角**/
            case sectionCount - 1 :
                cell.createCorner(CGSize(width: cornerRadius,height: cornerRadius),UIRectCorner(rawValue: (UIRectCorner.bottomLeft.rawValue)|(UIRectCorner.bottomRight.rawValue)))
                break
            default:
                break
            }
        }
        //当前分区只有一行行数据时
        else {
            cell.createCorner(CGSize(width: cornerRadius, height: cornerRadius), UIRectCorner(rawValue: (UIRectCorner.bottomLeft.rawValue)|(UIRectCorner.bottomRight.rawValue)))
        }
    }
    
    public func setShadowWithSectionCell(cell: UITableViewCell, indexPath: IndexPath) {
        let isFirst = indexPath.row==0
        let isLast = indexPath.row+1 == self.numberOfRows(inSection: indexPath.section)
        var shadowRect = cell.contentView.bounds.insetBy(dx: 0, dy: -10)
        if isFirst {
            shadowRect.origin.y += 10
        } else if isLast {
            shadowRect.size.height -= 15
        }
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 5).cgPath
        cell.layer.masksToBounds = false
            
        var maskRect = cell.contentView.bounds.insetBy(dx: -20, dy: 0)
        if isFirst {
            maskRect.origin.y -= 15
            maskRect.size.height += 15
        } else if isLast {
            maskRect.size.height += 15
        }
            
        // and finally add the shadow mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(rect: maskRect).cgPath
        cell.layer.mask = maskLayer
            
        //圆角
        var roundingCorners: UIRectCorner!
        if isFirst {
            roundingCorners =  [UIRectCorner.topLeft, UIRectCorner.topRight]
        } else if isLast {
            roundingCorners =  [UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
        } else {
            return
        }
        let maskPath = UIBezierPath(roundedRect: cell.contentView.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: 2, height: 2))
        let roundingLayer = CAShapeLayer()
        roundingLayer.frame = cell.contentView.bounds
        roundingLayer.path = maskPath.cgPath
        cell.contentView.layer.mask = roundingLayer
    }
    
    override public
    func styleDesign(_ design: DesignStyleProtocol) {
        super.styleDesign(design)
        
        if design.isScrollEnabled != nil {
            isScrollEnabled = design.isScrollEnabled as! Bool
        }
        
        if design.separatorStyle != nil {
            separatorStyle = design.separatorStyle as! UITableViewCell.SeparatorStyle
        }
        
        if design.separatorInset != nil {
            separatorInset = design.separatorInset as! UIEdgeInsets
        }
        
        if design.sectionHeaderHeight != nil {
            sectionHeaderHeight = design.sectionHeaderHeight as! CGFloat
        }
        
        if design.sectionFooterHeight != nil {
            sectionFooterHeight = design.sectionFooterHeight as! CGFloat
        }
    }
    
    public func separatorInset(_ separatorInsets: [CGFloat]) {
        self.separatorInset = UIEdgeInsets(
            top: separatorInsets.getCGFloat(0),
            left: separatorInsets.getCGFloat(1),
            bottom: separatorInsets.getCGFloat(2),
            right: separatorInsets.getCGFloat(3)
        )
    }
}

@objc public protocol EmptyDelegate {
    @objc optional func emptyImage(_ tableView: UITableView) -> UIImage
    @objc optional func emptyTitle(_ tableView: UITableView) -> NSAttributedString
    @objc optional func emptyCustomView(_ tableView: UITableView) -> UIView
    @objc optional func emptyDidTap(_ tableView: UITableView) -> Void
}

private class EmptyView: UIView {
    public let button: UIButton = UIButton(frame: .zero)
    public let imageView: UIImageView = UIImageView(frame: .zero)
    public let label: UILabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        a_UI()
        a_UIConfig()
        a_Layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func a_UI() {
        addSubviews(views: [button, imageView, label])
    }
    
    func a_UIConfig() {
        button.backgroundColor = .clear
        label.textAlignment = .center
    }
    
    func a_Layout() {
        label.width(width: 300)
        label.height(height: 30)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.point(points: [0, 0])
        button.size(sizes: [screenWidth(), noNavigationAndTabBarFrame.height])
        
        let image: UIImage = imageView.image!
        imageView.size(sizes: [image.size.width/2, image.size.height/2])
        imageView.centerX(view: button)
        
        label.centerX(view: button)
        
        let imageViewY: CGFloat = (button.height() - (imageView.height() + label.height())) / 2
        imageView.top(top: imageViewY)
        label.alignTop(view: imageView, offset: 10.0)
    }
}
