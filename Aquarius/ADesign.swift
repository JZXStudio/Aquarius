//
//  ADesign.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/4/17.
//

import UIKit
import Foundation

/// 自定义设计的接口
/// 接口通过UIDesign来实现
@objc
public protocol ADesign {
    /// 自定义的颜色
    @objc optional var colorDesign: DesignColorProtocol { get set }
}
/// 自定义颜色的接口
/// ```swift
/// import UIKit
/// import Foundation
///
/// import Aquarius
///
/// class ColorDesign: DesignColorProtocol {
///     //背景颜色
///     var bgColor: UIColor {
///        get {
///             AThemeStyle.getThemeColor([
///                .Light : 0xF5F5F5.a_color,
///                 .Dark : 0x151F2E.a_color
///             ])
///        }
///     }
/// }
/// ```
@objc
public protocol DesignColorProtocol {
    /// 背景颜色（可选）
    @objc optional var bgColor: UIColor { get }
    /// 阴影颜色（可选）
    @objc optional var shadowColor: UIColor { get }
    /* UINavigationController */
    /// 导航条背景颜色（可选）
    @objc optional var navigationBGColor: UIColor { get }
    /// 导航条标题颜色（可选）
    @objc optional var navigationTitleColor: UIColor { get }
    /* UITabBar */
    /// UITabBar背景颜色（可选）
    @objc optional var tabBarBGColor: UIColor { get }
    /* UITableViewCell */
    /// UITableViewCell的背景颜色（可选）
    @objc optional var cellBGColor: UIColor { get }
    /// UITableViewCell中选中的颜色（可选）
    @objc optional var cellSelectedColor: UIColor { get }
    /// UITableViewCell中name文字的颜色（可选）
    @objc optional var cellNameColor: UIColor { get }
    /// UITableViewCell中detail文字的颜色（可选）
    @objc optional var cellDetailColor: UIColor { get }
    /// UITableViewCell中border的颜色（可选）
    @objc optional var cellBorderColor: UIColor { get }
    /// UITableViewCell右侧箭头view颜色（可选）
    @objc optional var cellAccessoryViewColor: UIColor { get }
    
    /* UICollectionViewCell */
    /// UICollectionViewCell背景颜色（可选）
    @objc optional var collectionViewCellBGColor: UIColor { get }
    /// UICollectionViewCell中选中的颜色（可选）
    @objc optional var collectionViewCellSelectedColor: UIColor { get }
    /// UICollectionViewCell中name文字的颜色（可选）
    @objc optional var collectionViewCellNameColor: UIColor { get }
    /// UICollectionViewCell中detail文字的颜色（可选）
    @objc optional var collectionViewCellDetailColor: UIColor { get }
    /// UICollectionViewCell中border的颜色（可选）
    @objc optional var collectionViewCellBorderColor: UIColor { get }
    
    /* UISearchBar */
    /// UISearchBar背景颜色（可选）
    @objc optional var searchBGColor: UIColor { get }
    /// UISearchBar placeholder颜色（可选）
    @objc optional var searchPlaceholderColor: UIColor { get }
    /// UISearchBar文本颜色（可选）
    @objc optional var searchTextColor: UIColor { get }
    /// UISearchBar边框颜色（可选）
    @objc optional var searchBorderColor: UIColor { get }
    /* Tag */
    /// 标签默认背景颜色（可选）
    @objc optional var tagDefaultBGColor: UIColor { get }
    /// 标签选中时背景颜色（可选）
    @objc optional var tagSelectedBGColor: UIColor { get }
    /// 标签默认文本颜色（可选）
    @objc optional var tagTextColor: UIColor { get }
    /// 标签选中文本颜色（可选）
    @objc optional var tagSelectedTextColor: UIColor { get }
    /* UIButton */
    /// button1背景颜色（可选）
    @objc optional var button1BGColor: UIColor { get }
    /// button1文本颜色（可选）
    @objc optional var button1TextColor: UIColor { get }
    /// button1边框颜色（可选）
    @objc optional var button1BorderColor: UIColor { get }
    /// button2背景颜色（可选）
    @objc optional var button2BGColor: UIColor { get }
    /// button2文本颜色（可选）
    @objc optional var button2TextColor: UIColor { get }
    /// button2边框颜色（可选）
    @objc optional var button2BorderColor: UIColor { get }
    /// button3背景颜色（可选）
    @objc optional var button3BGColor: UIColor { get }
    /// button3文本颜色（可选）
    @objc optional var button3TextColor: UIColor { get }
    /// button3边框颜色（可选）
    @objc optional var button3BorderColor: UIColor { get }
    /// button4背景颜色（可选）
    @objc optional var button4BGColor: UIColor { get }
    /// button4文本颜色（可选）
    @objc optional var button4TextColor: UIColor { get }
    /// button4边框颜色（可选）
    @objc optional var button4BorderColor: UIColor { get }
    /// button5背景颜色（可选）
    @objc optional var button5BGColor: UIColor { get }
    /// button5文本颜色（可选）
    @objc optional var button5TextColor: UIColor { get }
    /// button5边框颜色（可选）
    @objc optional var button5BorderColor: UIColor { get }
    /// 主颜色（可选）
    @objc optional  var primaryColor: UIColor { get }
    /// 辅助1颜色（可选）
    @objc optional var auxiliary1Color: UIColor { get }
    /// 辅助2颜色（可选）
    @objc optional  var auxiliary2Color: UIColor { get }
    /// 辅助3颜色（可选）
    @objc optional var auxiliary3Color: UIColor { get }
    /// 辅助4颜色（可选）
    @objc optional var auxiliary4Color: UIColor { get }
    /// 辅助5颜色（可选）
    @objc optional var auxiliary5Color: UIColor { get }
    /// 文字主颜色（可选）
    @objc optional var textPrimaryColor: UIColor { get }
    /// 文字辅助色1（可选）
    @objc optional var textAuxiliary1Color: UIColor { get }
    /// 文字辅助色2（可选）
    @objc optional var textAuxiliary2Color: UIColor { get }
    /// 文字辅助色3（可选）
    @objc optional var textAuxiliary3Color: UIColor { get }
    /// 文字辅助色4（可选）
    @objc optional var textAuxiliary4Color: UIColor { get }
    /// 文字辅助色5（可选）
    @objc optional var textAuxiliary5Color: UIColor { get }
    /// 过渡色1（可选）
    @objc optional var gradient1Color: Array<UIColor> { get }
    /// 过渡色2（可选）
    @objc optional var gradient2Color: Array<UIColor> { get }
    /// 过渡色3（可选）
    @objc optional var gradient3Color: Array<UIColor> { get }
    /// 过渡色4（可选）
    @objc optional var gradient4Color: Array<UIColor> { get }
    /// 过渡色5（可选）
    @objc optional var gradient5Color: Array<UIColor> { get }
    
}
/// 自定义控件属性接口
///
/// 此接口用于为单独的组件设置属性
/// 例如：此代码实例中为tableView设置通用的属性。
/// 设置的属性包括：
/// + separatorStyle
/// + separatorInset
/// + sectionHeaderHeight
/// + sectionFooterHeight
///
/// ```swift
/// import UIKit
/// import Foundation
///
/// import Aquarius
///
/// class Common_TableViewStyle: DesignStyleProtocol {
///     var separatorStyle: Any = UITableViewCell.SeparatorStyle.none
///     var separatorInset: Any = UIEdgeInsets.zero
///     var sectionHeaderHeight: Any = 1.0
///     var sectionFooterHeight: Any = 8.0
///
///    public static let shared = Common_TableViewStyle()
/// }
/// ```
///
/// 使用时，调用组件的styleDesign方法
/// 例如：
/// ```swift
/// let tableView: UITableView = A.ui.tableView
/// tableView.styleDesign(Common_TableViewStyle.shared)
/// ```
@objc
public protocol DesignStyleProtocol {
    /// 圆角（可选）
    @objc optional var radius: Any { get set }
    /// 边框线宽度（可选）
    @objc optional var borderWidth: Any { get set }
    /// 边框线颜色（可选）
    @objc optional var borderColor: Any { get set }
    /// tint颜色（可选）
    @objc optional var tintColor: Any { get set }
    /// 阴影（可选）
    @objc optional var shadow: Any { get set }
    /// 字体（可选）
    @objc optional var font: Any { get set }
    /// 文本（可选）
    @objc optional var text: Any { get set }
    /// 文本颜色（可选）
    @objc optional var textColor: Any { get set }
    /// 文本对齐（可选）
    @objc optional var textAlignment: Any { get set }
    /// 粗体（可选）
    @objc optional var bold: Any { get set }
    /// 斜体（可选）
    @objc optional var italic: Any { get set }
    /// 下划线（可选）
    @objc optional var underline: Any { get set }
    /// 删除线（可选）
    @objc optional var deleteline: Any { get set }
    /// 默认显示文字（可选）
    @objc optional var placeholder: Any { get set }
    /// 默认显示文字颜色（可选）
    @objc optional var placeholderColor: Any { get set }
    /// 是否滚动（可选）
    @objc optional var isScrollEnabled: Any { get set }
    /// 边框线类型（可选）
    @objc optional var separatorStyle: Any { get set }
    /// 边框线布局（可选）
    @objc optional var separatorInset: Any { get set }
    /// 背景颜色（可选）
    @objc optional var backgroundColor: Any { get set }
    /// 遮罩（可选）
    @objc optional var maskToBounds: Any { get set }
    /// tableView的section的头部高度（可选）
    @objc optional var sectionHeaderHeight: Any { get set }
    /// tableView的section的尾部高度（可选）
    @objc optional var sectionFooterHeight: Any { get set }
    /// barTint颜色（可选）
    @objc optional var barTintColor: Any { get set }
    /// 背景图片（可选）
    @objc optional var backgroundImage: Any { get set }
    /// 普通的图片（可选）
    @objc optional var normalImage: Any { get set }
    /// 高亮的图片（可选）
    @objc optional var highlightedImage: Any { get set }
    /// 内容纵向对齐（可选）
    @objc optional var contentVerticalAlignment: Any { get set }
    /// 内容横向对齐（可选）
    @objc optional var contentHorizontalAlignment: Any { get set }
    /// 图片内部间距（可选）
    @objc optional var imageEdgeInsets: Any { get set }
    /// 普通文本（可选）
    @objc optional var normalTitle: Any { get set }
    /// 高亮文本（可选）
    @objc optional var highlightedTitle: Any { get set }
    /// 普通文本颜色（可选）
    @objc optional var normalTitleColor: Any { get set }
    /// 高亮文本颜色（可选）
    @objc optional var highlightedTitleColor: Any { get set }
    /// 视图周围的颜色（可选）
    @objc optional var layoutMargins: Any { get set }
    /// 过渡颜色（可选）
    @objc optional var gradientColor: Any { get set }
    /// 文本字体（可选）
    @objc optional var titleFont: Any { get set }
    /// 图片（可选）
    @objc optional var image: Any { get set }
    /// 箭头类型（可选）
    @objc optional var accessoryType: Any { get set }
    /// 是否隐藏（可选）
    @objc optional var isHidden: Any { get set }
    /// 图片和文本的间距（可选）
    @objc optional var imageAndTitlePadding: Any { get set }
    /// Label字体（可选）
    @objc optional var textLabelFont: Any { get set }
    /// Label颜色（可选）
    @objc optional var textLabelColor: Any { get set }
    /// Label文本（可选）
    @objc optional var textLabelText: Any { get set }
    /// 详细Label字体（可选）
    @objc optional var detailTextLabelFont: Any { get set }
    /// 详细Label颜色（可选）
    @objc optional var detailTextLabelColor: Any { get set }
    /// 详细Label文本（可选）
    @objc optional var detailTextLabelText: Any { get set }
    /// 设置开关（可选）
    @objc optional var setOn: Any { get set }
    /// 设置动画开关（可选）
    @objc optional var setAnimatedOn: Any { get set }
    /// 开关的颜色（可选）
    @objc optional var onTintColor: Any { get set }
    /// 滑块的背景颜色（可选）
    @objc optional var thumbTintColor: Any { get set }
    /// 是否可点击（可选）
    @objc optional var isEnabled: Any { get set }
}
