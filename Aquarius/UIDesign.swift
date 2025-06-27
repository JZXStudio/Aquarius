//
//  UIDesign.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/4/17.
//

import UIKit
import Foundation
/// 通过此类实现颜色和组件样式的统一管理
///
/// 需实现：
/// + DesignColorProtocol（管理颜色）
/// + DesignStyleProtocol（管理组件样式）
///
/// __BaseDesign.swift__
///
/// ```swift
/// import Foundation
///
/// import Aquarius
///
/// open class BaseDesign: UIDesign {
///     public let colorDesign: DesignColorProtocol = ColorDesign.shared
///
///     public let tableViewStyle: DesignStyleProtocol = Common_TableViewStyle.shared
/// }
/// ```
///
/// __ColorDesign.swift__
///
/// ```swift
/// import UIKit
/// import Foundation
///
/// import Aquarius
///
/// class ColorDesign: DesignColorProtocol {
///     //背景颜色
///     var bgColor: UIColor {
///         get {
///             AThemeStyle.getThemeColor([
///                .Light : 0xF5F5F5.a_color,
///                .Dark : 0x151F2E.a_color
///             ])
///         }
///     }
/// }
/// ```
///
/// __StyleDesign.swift__
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
///     public static let shared = Common_TableViewStyle()
/// }
/// ```
///
///实际使用代码：
///
/// ```swift
/// let design: BaseDesign = BaseDesign()
/// let tableView: UITableView = A.ui.tableView
/// tableView
///     .backgroundColor(design.colorDesign.bgColor)
///     .styleDesign(design.styleDesign.tableViewStyle)
/// ```
open class UIDesign: NSObject, ADesign {
    
}
