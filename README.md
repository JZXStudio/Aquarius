<div align="center">
  <img src="Sources/Aquarius.png" width='20%'>
  <br>
  <br>
  <img src="Sources/iOS-10.5-green.svg"> <img src="Sources/license-MIT-orange.svg"> <img src="Sources/swift-5.0-red.svg">
</div>

# 描述

Aquarius是以帮助独立开发者规范化开发流程，提高开发效率为目的而设计的Swift开发框架。

框架提供**高效率、低侵入式**的framework，既支持新的项目工程，也支持加入到老的工程中

框架本身不依赖任何三方类库，不会增大项目体积

框架以**MVVM设计模式**为核心，通过一系列定义的方法，提供新的开发方式

框架建议通过方法设置UI组件的属性，基于此原则，重新封装了大部分UI组件的属性

框架提供数据绑定功能，既支持变量间的动态数据更新，也支持变量与UI组件属性的动态数据更新

框架提供：

1. MVVM设计模式

2. 开发方法

3. 数据绑定

4. 处理UI的新方法

5. 深色模式切换

6. 格式转换

7. 通知

8. userDefaults

9. 内购

10. 日历/提醒

11. 位置

12. 依赖注入

13. 日志

14. Timer

15. 格式化属性

# MVVM设计模式

框架提供`AView`、`AViewController`、`AViewModel`，开发中，需基于此三个基类开始开发。例如：

**AView**

主要功能包括：

1. 键盘管理

2. 分层管理

3. 事件管理

4. Delegate管理

5. 通知管理

6. 数据绑定管理

7. 日志管理

8. 热更新管理

**代码示例：**

```swift
import Aquarius


class TestView: AView {

}
```

**AViewController**

主要功能包括：

1. 埋点

2. 导航条管理

3. 分层管理

4. 主题管理

5. 日志管理

6. 热更新管理

**代码示例：**

```swift
import Aquarius


class TestViewController: AViewController {

}
```

**AViewModel**

主要功能包括：

1. 分层管理

2. Delegate管理

3. 通知管理

4. 数据绑定管理

5. 日志管理

6. 热更新管理

```swift
import Aquarius


class TestVM: AViewModel {

}
```

框架提供了代码的低侵入性，可以在老的工程中引入`Aquarius`。引入后，新开发的功能继承`AView`、`AViewController`、`AViewModel`，老功能不受影响。

# 开发方法

`洋葱开发法`是作者为开发方法起的名字，方法主要将开发工作进行细分。

设计了多个方法，开发时只需要覆盖这些方法体，它们会自动执行。

## AViewController

初始化中执行的方法包括：

1. a_Preview：开始前执行

2. a_Begin：开始执行时调用

3. a_Navigation：定制化导航条

4. a_Delegate：设置delegate

5. updateThemeStyle：深色模式切换时调用

6. a_Notification：设置通知

7. a_Bind：设置数据绑定

8. a_Observe：设置Observe

9. a_Event：设置事件

viewDidLoad方法中执行的方法主要包括：

1. a_UI：设置UI组件

2. a_UIConfig：设置UI组件参数

3. a_Layout：设置UI组件的布局

4. a_Other：设置其它内容

5. a_End：代码末尾执行

6. a_Test：测试的代码函数，此函数值在debug模式下执行，发布后不执行

deinit方法中执行的方法包括：

1. a_Clear：销毁时执行

## AView

初始化中执行的方法包括：

1. a_Preview：开始前执行

2. a_Begin：开始执行时调用

3. a_UI：设置UI组件

4. a_UIConfig：设置UI组件参数

5. a_Layout：设置UI组件的布局

6. a_Notification：设置通知

7. a_Delegate：设置delegate

8. updateThemeStyle：深色模式切换时调用

9. a_Bind：设置数据绑定

10. a_Event：设置事件

11. a_Other：设置其它内容

12. a_End：代码末尾执行

13. a_Test：测试的代码函数，此函数值在debug模式下执行，发布后不执行

deinit方法中执行的方法包括：

1. a_Clear：销毁时执行

## AViewModel

初始化中执行的方法包括：

1. a_Preview：开始前执行

2. a_Begin：开始执行时调用

3. a_Notification：设置通知

4. a_Delegate：设置delegate

5. a_Observe：设置Observe

6. a_Other：设置其它内容

7. a_End：代码末尾执行

8. a_Test：测试的代码函数，此函数值在debug模式下执行，发布后不执行

deinit方法中执行的方法包括：

1. a_Clear：销毁时执行

## ATableViewCell

初始化中执行的方法包括：

1. a_Preview：开始前执行

2. a_Begin：开始执行时调用

3. a_UI：设置UI组件

4. a_UIConfig：设置UI组件参数

5. a_Layout：设置UI组件的布局

6. updateThemeStyle：深色模式切换时调用

7. a_Notification：设置通知

8. a_Delegate：设置delegate

9. a_Observe：设置Observe

10. a_Bind：设置数据绑定

11. a_Event：设置事件

12. a_Other：设置其它内容

13. a_End：代码末尾执行

14. configWithCell(cellData: Any)：cell接收数据时调用

deinit方法中执行的方法包括：

1. a_Clear：销毁时执行

# 数据绑定

框架中`AView`、`AViewModel`，提供了数据绑定功能，帮助实现完全解耦的数据更新。

数据绑定主要提供如下方法：

```swift
bindableFrom(_ dict: Dictionary<String, String>)
bindablesFrom(_ o: Array<Dictionary<String, String>>)
bindableTo(_ dict: Dictionary<String, String>)
bindablesTo(_ o: Array<Dictionary<String, String>>)
```

方法需要联动使用。

`bindableFrom、`、`bindablesFrom`，负责更新数据。

`bindableTo`、`bindalbesTo`，负责接收更新数据。

**TestView**使用方法如下：

```swift
import UIKit
import Foundation

import Aquarius

class TestView: AView {
    private let testButton: UIButton = A.ui.button

    @objc dynamic
    private var testString: String = ""

    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            testButton
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        testButton.prototypeDesign(.hollow)
        testButton.setTitle("测试数据绑定", for: .normal)
    }

    override func a_Layout() {
        super.a_Layout()

        testButton.size(sizes: [100, 150])
        testButton.point(points: [200, 400])
    }

    override func a_Bind() {
        super.a_Bind()

        bindableFrom([
            "bindKey" : #keyPath(testString)
        ])
    }

    override func a_Event() {
        super.a_Event()

        testButton.addTouchUpInsideBlock { [weak self] result in
            self?.testString = String.random(length: 16)
        }
    }
}
```

**TestVM**使用方法如下：

```swift
import Foundation

import Aquarius

class TestVM: AViewModel {
    @objc dynamic
    private var updateBindString: String = "" {
        willSet {
            A.log.info(newValue)
        }
    }

    override func a_Bind() {
        super.a_Bind()

        bindableTo([
            "bindKey" : #keyPath(updateBindString)
        ])
    }
}
```

# 处理UI的新方法

框架提供了一系列创建及处理UI组件的方法。方便开发者提高处理UI的效率。

## 快速初始化UI控件

```swift
A.ui.view//=UIView(frame: .zero)
A.ui.imageView//=UIImageView(frame: .zero)
A.ui.button//=UIButton(frame: .zero)
A.ui.label//=UILabel(frame: .zero)
A.ui.collectionView//=UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
A.ui.collectionViewCell//=UICollectionViewCell(frame: .zero)
A.ui.datePicker//=UIDatePicker(frame: .zero)
A.ui.navigationController//=UINavigationController()
A.ui.navigationItem//=UINavigationItem()
A.ui.pickerView//=UIPickerView(frame: .zero)
A.ui.scrollView//=UIScrollView(frame: .zero)
A.ui._switch//=UISwitch(frame: .zero)
A.ui.tabBarController//=UITabBarController()
A.ui.tabBarItem//=UITabBarItem()
A.ui.tableView//=UITableView(frame: .zero)
A.ui.tableViewCell//=UITableViewCell(frame: .zero)
A.ui.textField//=UITextField(frame: .zero)
A.ui.viewController//=UIViewController()
A.ui.searchBar//=UISearchBar(frame: .zero)
A.ui.textView//=UITextView(frame: .zero)
A.ui.refreshControl//=UIRefreshControl()
A.ui.activityIndicatorView//=UIActivityIndicatorView()
A.ui.webView//=WKWebView()
A.ui.progressView//=UIProgressView()
A.ui.alert//=UIAlertController(title: "", message: "", preferredStyle: .alert)
```

属性主要用于在UIView中快速的初始化UI控件。

创建方式如下：

```swift
import UIKit
import Foundation

import Aquarius

class TestView: AView {
    private let testButton: UIButton = A.ui.button
    private let testLabel: UILabel = A.ui.label
    private let testTableView: UITableView = A.ui.tableView
    ...
}
```

## UI布局

**基础布局**

UI控件提供如下基础布局属性和方法：

```swift
//获取UI控件顶端y值
func y() -> CGFloat
func top() -> CGFloat
//获取UI控件底端y值
func bottom() -> CGFloat
//获取UI控件左侧x值
func x() -> CGFloat
func left() -> CGFloat
//获取UI控件右侧y值
func right() -> CGFloat
//获取UI控件宽度
func width() -> CGFloat
//获取UI控件高度
func height() -> CGFloat
//获取UI控件的size
func size() -> CGSize
//获取UI控件的frame
func frame() -> CGRect
//获取UI控件中间点x坐标
func centerX() -> CGFloat
//获取UI控件中间点y坐标
func centerY() -> CGFloat
//获取屏幕的Size
func screenSize() -> CGSize
//获取屏幕的宽度
func screenWidth() -> CGFloat
//获取屏幕的高度
func screenHeight() -> CGFloat
//获取屏幕（去掉状态栏）的高度
func screenHeightNoStatus() -> CGFloat
//获取屏幕（去掉导航条）的高度
func screenHeightNoNavigation() -> CGFloat
//获取屏幕（去掉状态栏和导航条）的高度
func screenHeightNoStatusNoNavigation() -> CGFloat
//获取屏幕（去掉底部安全区域）的高度
func screenHeightNoSafeAreaFooter() -> CGFloat
//获取屏幕（去掉底部tabBar）的高度
func screenHeightNoTabBar() -> CGFloat
//获取屏幕（去掉底部安全区域和tabBar）的高度
func screenHeightNoStatusNoSafeAreaFooter() -> CGFloat
//获取屏幕（去掉状态栏和tabBar）的高度
func screenHeightNoStatusNoTabBar() -> CGFloat
//获取屏幕（去掉状态栏、底部安全区域和tabBar）的高度
func screenHeightNoStatusNoSafeAreaFooterNoTabBar() -> CGFloat
//获取屏幕（去掉导航条和底部安全区域）的高度
func screenHeightNoNavigationNoSafeAreaFooter() -> CGFloat
//获取屏幕（去掉导航条和tabBar）的高度
func screenHeightNoNavigationNoTabBar() -> CGFloat
//获取屏幕（去掉导航条、底部安全区域和tabBar）的高度
func screenHeightNoNavigationNoSafeAreaFooterNoTabBar() -> CGFloat
//获取屏幕（去掉状态栏、导航条和底部安全区域）的高度
func screenHeightNoStatusNoNavigationNoSafeAreaFooter() -> CGFloat
//获取屏幕（去掉状态栏、导航条和tabBar）的高度
func screenHeightNoStatusNoNavigationNoTabBar() -> CGFloat
//获取屏幕（去掉状态栏、导航条、底部安全区域和tabBar）的高度
func screenHeightNoStatusNoNavigationNoSafeAreaFooterNoTabBar() -> CGFloat
//获取顶部安全区域高度
func safeAreaHeaderHeight() -> CGFloat
//获取底部安全区域高度
func safeAreaFooterHeight() -> CGFloat
//获取状态栏高度
func statusBarHeight() -> CGFloat
//获取导航条高度
func navigationBarHeight() -> CGFloat
//获取tabBar高度
func tabBarHeight() -> CGFloat
```

**UI控件设置布局**

UI控件提供如下设置布局的方法：

```swift
//设置UI控件的y位置或顶部位置（支持动画）
func y(y: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
func top(top: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的底部位置（支持动画）
func bottom(bottom: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的x位置或左侧位置（支持动画）
func x(x: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
func left(left: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的右侧位置（支持动画）
func right(right: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的宽度（支持动画）
func width(width: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的高度（支持动画）
func height(height: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的size（设置宽和高）（支持动画）
func size(width: CGFloat, height: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的size（数组形式设置，0为宽度，1为高度）（支持动画）
func size(sizes: Array<CGFloat>, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的size（直接设置size）（支持动画）
func size(size: CGSize, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的size（宽和高相同）（支持动画）
func size(widthHeight: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的frame （支持动画）
func frame(frame: CGRect, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的frame（数组形式设置，0为x，1为y，2为width，3为height） （支持动画）
func frame(frames: Array<CGFloat>, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的frame（x和y相同，width和height相同时） （支持动画）
func frame(xy: CGFloat, widthHeight: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//设置UI控件的frame （支持动画）
func frame(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
```

**控件间布局方法**

UI控件提供如下控件间布局的方法：

```swift
//UI控件顶部在view的底部，offset为间距（支持动画）
func alignTop(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件底部在view的顶部，offset为间距（支持动画）
func alignBottom(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件左侧在view的右侧，offset为间距（支持动画）
func alignLeft(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件右侧在view的左侧，offset为间距（支持动画）
func alignRight(view: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件顶部等于target顶部，offset为间距（支持动画）
func equalTop(target: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件底部等于target底部，offset为间距（支持动画）
func equalBottom(target: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件左侧等于target左侧，offset为间距（支持动画）
func equalLeft(target: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件右侧等于target右侧，offset为间距（支持动画）
func equalRight(target: UIView, offset: CGFloat = 0, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件size等于target的size（支持动画）
func equalSize(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件point等于target的point（支持动画）
func equalPoint(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件宽度等于target的宽度（支持动画）
func equalWidth(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件高度等于target的高度（支持动画）
func equalHeight(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件rect等于target的rect（支持动画）
func equalRect(target: UIView, animate: Bool = false, duration: TimeInterval = UIView.a_duration)
//UI控件左侧位置为0
func equalZeroLeft()
//UI控件顶部位置为0
func equalZeroTop()
//UI控件左侧和顶部均为0
func equalZeroTopAndLeft()
//UI控件size等于屏幕的size
func equalScreenSize()
//UI控件宽度等于屏幕宽度（offset为内间距）
func equalScreenWidth(_ offset: CGFloat=0.0)
//UI控件高度等于屏幕高度（offset为内间距）
func equalScreenHeight(_ offset: CGFloat=0.0)
```

**批量布局**

当两个控件间有多个属性相同，可以采用批量布局的方法

方法如下：

```swift
private let testLabel: UILabel = A.ui.lable
private let testButton: UIButton = A.ui.button

override func a_Layout() {
    super.a_layout()

    testLabel.size(widthHeight: 100.0)
    testLabel.top(top: 50.0)
    testLabel.left(left: 100.0)
    testLabel.target(testButton)
    testLabel.a_equals([
        .width,
        .height,
        .top,
        .left
    ])
}
```

支持批量设置的属性包括：

`width`、`height`、`left`、`top`、`right`、`bottom`、`point`、`size`、`rect`、`backgroundColor`、`isHidden`、`alpha`

**layer相关属性的快速设置**

```swift
func layerCornerRadius(_ cornerRadius: CGFloat)
func layerCornerCurve(_ cornerCurve: CALayerCornerCurve)
func layerMasksToBounds(_ masksToBounds: Bool=true)
func layerBorderWidth(_ borderWidth: CGFloat)
func layerBorderColor(_ borderColor: UIColor)
```

**背景颜色的快速设置**

```swift
func clearBackgroundColor()
func whiteBackgroundColor()
func blackBackgroundColor()
func darkGrayBackgroundColor()
func lightGrayBackgroundColor()
func grayBackgroundColor()
func redBackgroundColor()
func greenBackgroundColor()
func blueBackgroundColor()
func cyanBackgroundColor()
func yellowBackgroundColor()
func magentaBackgroundColor()
func orangeBackgroundColor()
func purpleBackgroundColor()
func brownBackgroundColor()
//设置随机背景色
func testBackgroundColor()
```

## 批量设置UI控件

当多个UI控件具有相同的属性，可以将多个UI控件放入一个数组中，并直接处理数组。

示例代码：

```swift
override func a_UIConfig() {
    super.a_UIConfig()

    let uiArray: [UIView] = [testButton, testLabel]
    uiArray.layerCornerRadius(8.0)
    uiArray.backgroundColor(0xFFFFFF.toColor)
}
```

支持批量设置的方法参见：**Array++.swift**

## UI控件的添加和删除

框架支持单独添加UI控件和批量添加UI控件。在实际开发中，建议使用批量添加UI控件的方法。

示例：

```swift
private let testLabel: UILabel = A.ui.lable
private let testButton: UIButton = A.ui.button

override func a_UI() {
    super.a_UI()

    addSubViews(views:[
        testLabel,
        testButton
    ])
}
```

UITableViewCell也支持单独添加UI控件和批量添加UI控件。在实际开发中，建议使用批量添加UI控件的方法。

示例：

```swift
private let testLabel: UILabel = A.ui.lable
private let testButton: UIButton = A.ui.button

override func a_UI() {
    super.a_UI()

    addSubviewInContentView(views:[
        testLabel,
        testButton
    ])
}
```

## 导航条的相关设置

继承于`AViewController`的`UIViewController`可以快速的设置导航条

框架提供的方法包括：

```swift
public var navigation_Title: String
public var navigation_TitleView: UIView?
public var navigation_LeftBarButton: UIButton?
public var navigation_LeftBarButtonText: String?
public var navigation_LeftBarButtonImage: UIImage?
public var navigation_LeftBarButtonTintColor: UIColor?
public var navigation_LeftBarButtonAction: Selector?
public func navigation_LeftBarButtonSelector(executeBlock: (() -> Void)?)
public var navigation_RightBarButton: UIButton?
public var navigation_RightBarButtonText: String?
public var navigation_RightBarButtonImage: UIImage?
public var navigation_RightBarButtonTintColor: UIColor?
public var navigation_RightBarButtonAction: Selector?
public func navigation_RigthBarButtonSelector(executeBlock: (() -> Void)?)
```

# 深色模式切换

框架提供了支持模式切换的功能。开发过程中，建议使用主题文件的形式。

实现模式切换的步骤如下：

1. 制作主题类

2. 重写updateThemeStyle方法

## 制作主题类

主题类需继承`DesignColorProtocol`协议。

`DesignColorProtocol`协议提供了标准的颜色定义。详细请查看**DesignColorProtocol**中的定义。

主题类示例：

```swift
import UIKit
import Foundation

import Aquarius

class ColorDesign: DesignColorProtocol {
    var textPrimaryColor: UIColor {
        get {
            AThemeStyle.getThemeColor([
                //普通模式颜色
                .Light : 0xF2F2F2.toColor,
                //深色模式颜色
                .Dark : 0x151F2E.toColor
            ])
        }
    }

    var primaryColor: UIColor {
        get {
            AThemeStyle.getThemeColor([
                .Light : 0xF2F2F2.toColor,
                .Dark : 0x151F2E.toColor
            ])
        }
    }

    public static let shared = ColorDesign()
}
```

## updateThemeStyle方法

定义主题类后，`AViewController`和`AView`提供了**updateThemeStyle**方法。

再此方法中更新主题。

示例代码：

```swift
import UIKit
import Foundation

import Aquarius

class MainView: AView {
    public let testLabel: UILabel = A.ui.label
    public let testButton: UIButton = A.ui.button

    override func a_UI() {
        super.a_UI()

        addSubviews(views:[
            testLabel,
            testButton
        ])
    }

    override func updateThemeStyle() {
        super.updateThemeStyle()

        testLabel.textColor = ColorDesign.shared.textPrimaryColor
        testButton.backgroundColor = ColorDesign.shared.primaryColor
    }
}
```

示例中，当系统由普通模式转换为深色模式，或者由深色模式转换为普通模式时，继承`AView`或者`AViewController`的类将自动执行**updateThemeStyle**方法。

方法体将重新设置`testLabel`的**textColor**和`testButton`的**backgroundColor**属性。

`textPrimaryColor`和`primaryColor`将会根据主题类中的设置，自动判断是普通模式还是深色模式，并返回对应的颜色值。

## getThemeColor方法

不使用主题类的情况下，可以直接通过**getThemeColor**方法设置颜色

```swift
static func getThemeColor(_ themeColorDict: [AThemeStyleDarkModeType : UIColor]) -> UIColor
```

示例代码：

```swift
import UIKit
import Foundation

import Aquarius

class MainView: AView {
    public let testLabel: UILabel = A.ui.label
    public let testButton: UIButton = A.ui.button

    override func a_UI() {
        super.a_UI()

        addSubviews(views:[
            testLabel,
            testButton
        ])
    }

    override func updateThemeStyle() {
        super.updateThemeStyle()

        testLabel.textColor = AThemeStyle.getThemeColor([
            .Light : 0xF2F2F2.toColor,
            .Dark : 0x151F2E.toColor
        ])
        testButton.backgroundColor = ColorDesign.shared.primaryColor
    }
}
```

# 格式转换

框架提供大部分的格式想换转换的简写方法。

示例代码：

```swift
//颜色转换
let color: UIColor = 0xFFFFFF.toColor
//Int字号转换
let font1: UIFont = 18.toFont
let font2: UIFont = 18.toBoldFont
//Int转CGFloat
let f: CGFloat = 18.toCGFloat
//Int转NSNumber
let n: NSNumber = 18.toNumber
//Int转Double
let double: Double = 18.toDouble
//字符串转日期（默认为完整日期，包括日期+时间）
let date1: Date = "2025-05-10 18:00:00".toDate()
//字符串转日期
let date2: Date = "2025-05-10".toShortDate()
//字符串转日期（包括日期+时间）
let date3: Date = "2025-05-10".toLongDate()
//字符串转图片
let image1: UIImage = "name.png".toContentsOfFileImage()
let image2: UIImage = "name.png".toNamedImage()
let image3: UIImage = "setting.png".toSystemNameImage()
//字符串转Int
let data: Int? = "1".toInt()
//字符串转Bool
let flag: Bool = "1".toBool()
//字符串转CGFloat
let f: CGFloat = "1".toCGFloat()
//字符串转Double
let double: Double = "18.85".toDouble()
//CGFloat转Font
let font1: UIFont = 18.0.toFont
let font2: UIFont = 18.0.toBoldFont
//CGFloat转字符串
let string: String = 18.0.toString()
//日期转String
let string1: String = Date().toString()
let string2: String = Date().toShortEnglishString()
let string3: String = Date().toShortChineseString()
let string4: String = Date().toLongEnglishString()
let string5: String = Date().toLongChineseString()
let yearString: String = Date().toYearString()
let year: Int? = Date().toYear()
let monthString: String = Date().toMonthString()
let month: Int? = Date().toMonth()
let dayString: String = Date().toDayString()
let day: Int? = Date().toDay()
let time: String = Date().toTimeString()
let hourString: String = Date().toHourString()
let hour: Int? = Date().toHour()
let minuteString: String = Date().toMinuteString()
let minute: Int? = Date().toMinute()
let secondString: String = Date().toSecondString()
let second: Int? = Date().toSecond()
//Bool转Int
let flag: Int = false.toInt()
//Bool转String
let flagString: String = false.toString()
//UIColor转String
let colorString: String = 0xFFFFFF.toHexString()
//UIImage转Data
let data1: Data? = image.toJPEGData()
let data2: Data? = image.toPNGData()
//Data转UIImage
let image: UIImage? = data.toImage()
```