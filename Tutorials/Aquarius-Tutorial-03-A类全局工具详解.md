# Aquarius iOS 开发框架教程 03 - A 类全局工具详解

> 📚 **Aquarius 教程系列：核心架构**  
> 🎯 **本教程目标**：全面掌握 A 类的全局工具类和功能

---

## 📖 目录

1. [A 类概述](#a-类概述)
2. [全局工具访问](#全局工具访问)
3. [UI 工具详解](#ui-工具详解)
4. [颜色工具详解](#颜色工具详解)
5. [图片工具详解](#图片工具详解)
6. [数据存储工具详解](#数据存储工具详解)
7. [系统工具详解](#系统工具详解)
8. [实用技巧与最佳实践](#实用技巧与最佳实践)

---

## A 类概述

### 🏗️ 设计理念

A 类是 Aquarius 框架的全局入口点，采用了单例模式设计，为开发者提供了快速访问各种工具类的便捷接口。它就像一个功能齐全的工具箱，随时可以取用需要的工具。

```swift
public struct A {
    /// 只在 debug 模式时执行的函数体
    public static func DEBUG(_ block: (() -> Void))

    /// 分别在 debug 模式下执行和在 release 下执行的函数体
    public static func DEBUG(_ debug: (() -> Void), RELEASE: (() -> Void))

    // 全局主题配置
    public static let kApplicationDidEnterBackground: String
    public static let kApplicationWillEnterForeground: String
    public static let kApplicationWillTerminate: String
    public static let kApplicationDidBecomeActive: String

    // 工具类实例
    public static var ui: AUI
    public static var color: AColor
    public static var image: AImage
    public static var font: AFont
    public static var userDefaults: AUserDefaults
    public static var calendar: ACalendar
    public static var file: AFile
    public static var app: AApp
    public static var iap: AIap
    public static var log: ALogger
    public static var appstore: AAppStore
}
```

### 🎯 核心特点

1. **单例模式**：确保全局唯一性
2. **懒加载**：按需初始化，提高性能
3. **类型安全**：强类型接口，防止误用
4. **统一访问**：一致的调用方式
5. **扩展性强**：易于添加新的工具类

---

## 全局工具访问

### 🔧 快速访问模式

A 类的最大优势是提供了极其简洁的访问方式：

```swift
// 传统方式 - 繁琐且重复
let userDefaults = UserDefaults.standard
let color = UIColor()
let image = UIImage(named: "icon")

// Aquarius 方式 - 简洁统一
let userDefaults = A.userDefaults
let color = A.color.blackColor
let image = A.image.systemImage("phone.arrow.right.fill")
```

### 🎪 调试模式支持

```swift
// 仅在 Debug 模式下执行
A.DEBUG {
    printLog("这是调试信息")
    setupDebugTools()
}

// 区分 Debug 和 Release 模式
A.DEBUG({
    setupDebugMode()
}, RELEASE: {
    setupReleaseMode()
})
```

### 📱 应用生命周期监听

- **A.kApplicationDidBecomeActive**

- **A.kApplicationWillEnterForeground**

- **A.kApplicationDidEnterBackground**

- **A.kApplicationWillTerminate**

框架仅提供规范，实际开发中，需要在**AppDelegate**对应方法中发送此通知。

```swift
class MyViewController: AViewController {
    override func a_Notification() {
        super.a_Notification()

        // 监听应用生命周期事件
        Manage_SetNotifications([
            A.kApplicationDidBecomeActive,
            A.kApplicationWillEnterForeground,
            A.kApplicationDidEnterBackground,
            A.kApplicationWillTerminate
        ])
    }

    override func ANotificationReceive(notification: Notification) {
        super.ANotificationReceive(notification: notification)

        switch notification.name.rawValue {
        case A.kApplicationDidBecomeActive:
            A.log.info("App did become active")
            break
        case A.kApplicationWillEnterForeground:
            A.log.info("App will enter foreground")
            break
        case A.kApplicationDidEnterBackground:
            A.log.info("App did enter background")
            break
        case A.kApplicationWillTerminate:
            A.log.info("App will terminate")
            break
        default:
            A.log.warning("Unhandled notification: \(notification.name.rawValue)")
        }
    }
}
```

---

## UI 工具详解

### 🎨 AUI 核心功能

A.ui 是 UI 组件的快速创建工具，提供了大量便捷的创建方法：

```swift
public class AUI: NSObject {
    public static let shared = AUI()

    // MARK: - 基础视图组件
    public var view: UIView
    public var imageView: UIImageView
    public var button: UIButton
    public var label: UILabel
    public var aLabel: ALabel

    // MARK: - 容器组件
    public var scrollView: UIScrollView
    public var tableView: UITableView
    public var collectionView: UICollectionView

    // MARK: - 输入组件
    public var textField: UITextField
    public var textView: UITextView
    public var searchBar: UISearchBar
    public var datePicker: UIDatePicker

    // MARK: - 导航组件
    public var navigationController: UINavigationController
    public var tabBarController: UITabBarController

    // MARK: - 特殊组件
    public var webView: WKWebView
    public var mapView: MKMapView
    public var activityIndicatorView: UIActivityIndicatorView
}
```

### 🚀 快速 UI 创建示例

```swift
class QuickUIExample: AView {

    private lazy var titleLabel: UILabel = A.ui.label
    private lazy var contentTable: UITableView = A.ui.plainTableView
    private lazy var actionButton: UIButton = A.ui.button
    private lazy var searchBar: UISearchBar = A.ui.searchBar

    override func a_UI() {
        super.a_UI()

        // 快速创建并添加子视图
        addSubviews(views: [
            titleLabel,
            searchBar,
            contentTable,
            actionButton
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        // 快速配置标签
        titleLabel.text = "快速 UI 创建示例"
        titleLabel.font = 16.0.toFont
        titleLabel.textAlignment = .center

        // 快速配置按钮
        actionButton.setTitle("点击我", for: .normal)
        actionButton.layerCornerRadius(8)

        // 快速配置表格
        contentTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        contentTable.separatorStyle = .singleLine
    }

    override func a_Layout() {
        super.a_Layout()

        // 快速布局设置
        titleLabel.size(sizes: [screenWidth(), 60])
        titleLabel.point(points: [0, safeAreaHeaderHeight()])

        searchBar.size(sizes: [screenWidth(), 44])
        searchBar.point(points: [0, titleLabel.bottom()])

        contentTable.size(
            width: screenWidth(),
            height: screenHeight() - searchBar.bottom() - 100
        )
        contentTable.point(points: [0, searchBar.bottom()])

        actionButton.size(sizes: [screenWidth() - 40, 44])
        actionButton.point(points: [20, contentTable.bottom() + 10])
    }

    override func updateThemeStyle() {
        super.updateThemeStyle()

        actionButton.backgroundColor = A.color.blackColor
    }

    override func a_Event() {
        super.a_Event()

        // 快速设置按钮事件
        actionButton.addTouchUpInsideBlock { [weak self] _ in
            self?.showAlert("按钮被点击了！")
        }
    }
}
```

### 🔄 懒加载 vs 立即创建

```swift
class LazyLoadExample: AView {

    // 方式 1: 懒加载
    private lazy var lazyLabel: UILabel = A.ui.label
    private lazy var lazyButton: UIButton = A.ui.button

    // 方式 2: 立即创建（不推荐在复杂页面中使用）
    private let immediateView: UIView = A.ui.view

    override func a_UI() {
        super.a_UI()

        // 懒加载组件在首次访问时创建
        // 此处不要使用懒加载，因为页面加载时既调用此方法
        addSubviews(views: [
            immediateView // 立即创建
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        // 懒加载的优势：可以在这里进行复杂的初始化
        lazyLabel.text = "这是懒加载的标签"
        lazyLabel.font = 16.0.toFont

        // 立即创建的组件也可以正常配置
        immediateView.backgroundColor = A.color.secondary
    }
}
```

---

## 颜色工具详解

### 🌈 AColor 颜色管理

```swift
public class AColor: NSObject {
    public static let shared = AColor()

    // MARK: - UIColor颜色
    public var blackColor: UIColor
    public var whiteColor: UIColor
    public var darkGrayColor: UIColor
    public var lightGrayColor: UIColor
    public var grayColor: UIColor
    ...

    // MARK: - CGColor颜色
    public var blackCGColor: CGColor
    public var whiteCGColor: CGColor
    public var darkGrayCGColor: CGColor
    public var lightGrayCGColor: CGColor
    public var grayCGColor: CGColor
    ...
}
```

### 🎨 主题颜色系统

```swift
class ThemeColorExample: AView {

    private let primaryView: UIView = A.ui.view
    private let secondaryView: UIView = A.ui.view
    private let successView: UIView = A.ui.view
    private let errorView: UIView = A.ui.view

    override func a_UI() {
        super.a_UI()
        addSubviews(views: [
            primaryView,
            secondaryView,
            successView,
            errorView
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        // 添加边框以便区分
        [primaryView, secondaryView, successView, errorView].forEach {
            $0.layerBorderWidth(1)
            $0.layerBorderColor(.black)
        }
    }

    override func updateThemeStyle() {
        super.updateThemeStyle()

        // 使用主题颜色
        primaryView.backgroundColor = A.color.blackColor
        secondaryView.backgroundColor = A.color.grayColor
        successView.backgroundColor = A.color.darkGrayColor
        errorView.backgroundColor = A.color.lightGrayColor
    }

    override func a_Layout() {
        super.a_Layout()

        let screenWidth = self.screenWidth()
        let spacing: CGFloat = 20

        // 第一行
        primaryView.size(sizes: [(screenWidth - 3 * spacing) / 2, 60])
        primaryView.point(points: [spacing, safeAreaHeaderHeight() + 20])

        secondaryView.size(sizes: [(screenWidth - 3 * spacing) / 2, 60])
        secondaryView.point(points: [primaryView.right() + spacing, primaryView.top()])

        // 第二行
        successView.size(sizes: [(screenWidth - 3 * spacing) / 2, 60])
        successView.point(points: [spacing, primaryView.bottom() + spacing])

        errorView.size(sizes: [(screenWidth - 3 * spacing) / 2, 60])
        errorView.point(points: [successView.right() + spacing, successView.top()])
    }
}
```

---

## 图片工具详解

### 🖼️ AImage 图片管理

```swift
public class AImage: NSObject {
    public static let shared = AImage()

    // MARK: - 系统图片
    public func systemImage(systemName: String) -> UIImage?
```

---

## 数据存储工具详解

### 💾 AUserDefaults 数据存储

```swift
public class AUserDefaults: NSObject {
    public static let shared = AUserDefaults()

    init(appGroups: String? = nil) {
        // 支持 App Groups 扩展
    }

    // MARK: - 基础存储方法
    public func setValue(_ value: Any)
    public func getValue(_ key: String) -> Any?

    // MARK: - 常用类型存储
    public func getString(forKey key: String) -> String?
    public func getArrayValue(_ key: String) -> [Any]?
    public func getDictionaryValue(_ key: String) -> Dictionary<String, Any>?
    public func getDataValue(_ key: String) -> Data?
    public func getStringArrayValue(_ key: String) -> [String]?
    public func getIntValue(_ key: String) -> Int
    public func getIntegerValue(_ key: String) -> NSInteger
    public func getFloatValue(_ key: String) -> Float
    public func getDoubleValue(_ key: String) -> Double
    public func getBoolValue(_ key: String) -> Bool
    public func getURLValue(_ key: String) -> URL?
}
```

### 🗃️ 用户偏好设置

```swift
class UserPreferencesExample: AView {

    private let themeLabel: UILabel = A.ui.label
    private let languageLabel: UILabel = A.ui.label
    private let notificationsLabel: UILabel = A.ui.label

    private let themeSwitch: UISwitch = A.ui._switch
    private let languageSegment: UISegmentedControl = UISegmentedControl(items: ["中文", "English"])
    private let notificationsSwitch: UISwitch = A.ui._switch

    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            themeLabel,
            themeSwitch,
            languageLabel,
            languageSegment,
            notificationsLabel,
            notificationsSwitch
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        themeLabel.text = "深色主题"
        languageLabel.text = "语言设置"
        notificationsLabel.text = "推送通知"

        languageSegment.selectedSegmentIndex = A.userDefaults.getIntValue("selectedLanguage")
        themeSwitch.isOn = A.userDefaults.getBoolValue("isDarkTheme")
        notificationsSwitch.isOn = A.userDefaults.getBoolValue("isNotificationsEnabled")
    }

    override func a_Layout() {
        super.a_Layout()

        let spacing: CGFloat = 20
        var currentY: CGFloat = safeAreaHeaderHeight() + 20

        themeLabel.size(sizes: [200, 30])
        themeLabel.point(points: [20, currentY])

        themeSwitch.size(sizes: [50, 30])
        themeSwitch.point(points: [screenWidth() - 70, currentY])

        currentY += 60

        languageLabel.size(sizes: [200, 30])
        languageLabel.point(points: [20, currentY])

        languageSegment.size(sizes: [150, 30])
        languageSegment.point(points: [screenWidth() - 170, currentY])

        currentY += 60

        notificationsLabel.size(sizes: [200, 30])
        notificationsLabel.point(points: [20, currentY])

        notificationsSwitch.size(sizes: [50, 30])
        notificationsSwitch.point(points: [screenWidth() - 70, currentY])
    }

    override func a_Event() {
        super.a_Event()

        themeSwitch.addValueChangedBlock { [weak self] switchControl in
            self?.handleThemeToggle((switchControl as! UISwitch).isOn)
        }

        languageSegment.addValueChangedBlock { [weak self] segmentControl in
            self?.handleLanguageChange((segmentControl as! UISegmentedControl).selectedSegmentIndex)
        }

        notificationsSwitch.addValueChangedBlock { [weak self] switchControl in
            self?.handleNotificationsToggle((switchControl as! UISwitch).isOn)
        }
    }

    private func handleThemeToggle(_ isOn: Bool) {
        // 保存用户偏好
        A.userDefaults.forKey("isDarkTheme")
        A.userDefaults.setValue(isOn)

        // 应用主题
        let interfaceStyle: UIUserInterfaceStyle = isOn ? .dark : .light
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = interfaceStyle

        A.log.info("主题已设置为: \(isOn ? "深色" : "浅色")")
    }

    private func handleLanguageChange(_ index: Int) {
        // 保存用户偏好
        A.userDefaults.forKey("selectedLanguage")
        A.userDefaults.setValue(index)

        // 应用语言设置
        let languageCode = index == 0 ? "zh-Hans" : "en"
        A.log.info("语言已设置为: \(index == 0 ? "中文" : "English")")

        // 这里可以添加实际的语言切换逻辑
    }

    private func handleNotificationsToggle(_ isOn: Bool) {
        // 保存用户偏好
        A.userDefaults.forKey("isNotificationsEnabled")
        A.userDefaults.setValue(isOn)

        // 请求推送权限或取消订阅
        if isOn {
            requestNotificationPermission()
        }

        A.log.info("推送通知已\(isOn ? "启用" : "禁用")")
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    A.log.info("推送权限已获取")
                } else {
                    A.log.info("推送权限被拒绝")
                    self.notificationsSwitch.isOn = false
                    A.userDefaults.forKey("isNotificationsEnabled")
                    A.userDefaults.setValue(false)
                }
            }
        }
    }
}
```

### 📱 App Groups 数据共享

```swift
// App Groups 配置
class AppGroupsExample: AView {

    private let sharedDefaults: AUserDefaults = A.userDefaults("group.com.yourcompany.shared")

    override func a_Begin() {
        super.a_Begin()

        // 在 App 和 Extension 之间共享数据
        shareDataBetweenTargets()
    }

    private func shareDataBetweenTargets() {
        // 保存共享数据
        sharedDefaults.forKey("sharedKey")
        sharedDefaults.setValue("Shared Value")
        sharedDefaults.forKey("sharedNumber")
        sharedDefaults.setValue(42)

        // 从共享数据中读取
        let sharedValue = sharedDefaults.getStringValue("sharedKey")
        let sharedNumber = sharedDefaults.getIntValue("sharedNumber")

        A.log.info("共享数据: \(sharedValue ?? ""), \(sharedNumber)")
    }
}
```

---

## 系统工具详解

### 📅 ACalendar 日历管理

```swift
public class ACalendar: NSObject {
    public static let shared = ACalendar()

    public func today() -> Date
    public func tomorrow() -> Date
    public func nextWeek() -> Date
    public func day() -> Int?
    public func dayString() -> String
    public func month() -> Int?
    public func monthString() -> String
    public func year() -> Int?
    public func yearString() -> String
    public func futureDay(_ day: Int) -> Date
    public func pastDay(_ day: Int) -> Date
}
```

```swift
class CalendarExample: AView {

    private let currentDateLabel: UILabel = A.ui.label
    private let formattedDateLabel: UILabel = A.ui.label
    private let daysLabel: UILabel = A.ui.label

    private let addDayButton: UIButton = A.ui.button
    private let addWeekButton: UIButton = A.ui.button
    private let resetButton: UIButton = A.ui.button

    private var workingDate: Date = Date()

    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            currentDateLabel,
            formattedDateLabel,
            daysLabel,
            addDayButton,
            addWeekButton,
            resetButton
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        currentDateLabel.font = 16.0.toFont
        formattedDateLabel.font = 16.0.toFont
        daysLabel.font = 16.0.toFont

        addDayButton.setTitle("+1天", for: .normal)
        addDayButton.layerCornerRadius(8)

        addWeekButton.setTitle("+1月", for: .normal)
        addWeekButton.layerCornerRadius(8)

        resetButton.setTitle("重置", for: .normal)
        resetButton.layerCornerRadius(8)

        updateDateDisplay()
    }

    override func updateThemeStyle() {
        super.updateThemeStyle()

        addDayButton.backgroundColor = A.color.grayColor
        addWeekButton.backgroundColor = A.color.grayColor
        resetButton.backgroundColor = A.color.darkGrayColor
    }

    override func a_Layout() {
        super.a_Layout()

        currentDateLabel.size(sizes: [screenWidth() - 40, 30])
        currentDateLabel.point(points: [20, safeAreaHeaderHeight() + 20])

        formattedDateLabel.size(sizes: [screenWidth() - 40, 30])
        formattedDateLabel.point(points: [20, currentDateLabel.bottom() + 10])

        daysLabel.size(sizes: [screenWidth() - 40, 30])
        daysLabel.point(points: [20, formattedDateLabel.bottom() + 10])

        addDayButton.size(sizes: [100, 44])
        addDayButton.point(points: [20, daysLabel.bottom() + 30])

        addWeekButton.size(sizes: [100, 44])
        addWeekButton.point(points: [140, daysLabel.bottom() + 30])

        resetButton.size(sizes: [100, 44])
        resetButton.point(points: [260, daysLabel.bottom() + 30])
    }

    override func a_Event() {
        super.a_Event()

        addDayButton.addTouchUpInsideBlock { [weak self] _ in
            self?.addOneDay()
        }

        addWeekButton.addTouchUpInsideBlock { [weak self] _ in
            self?.addOneWeek()
        }

        resetButton.addTouchUpInsideBlock { [weak self] _ in
            self?.resetDate()
        }
    }

    private func updateDateDisplay() {
        // 当前日期
        currentDateLabel.text = "当前日期: \(A.calendar.today())"
    }

    private func addOneDay() {
        workingDate = A.calendar.nextDay()
        updateDateDisplay()
    }

    private func addOneWeek() {
        workingDate = A.calendar.nextWeek()
        updateDateDisplay()
    }

    private func resetDate() {
        workingDate = Date()
        updateDateDisplay()
    }
}
```

### 📱 AApp 应用信息

```swift
public class AApp: NSObject {
    public static let shared = AApp()

    // MARK: - 应用信息
    public var appName: String
    public var version: String
    public var build: String
    public var isIOS26: Bool
}
```

```swift
class AppInfoExample: AView {

    private let appInfoLabel: UILabel = A.ui.label
    private let systemInfoLabel: UILabel = A.ui.label
    private let deviceInfoLabel: UILabel = A.ui.label
    private let networkInfoLabel: UILabel = A.ui.label

    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            appInfoLabel,
            systemInfoLabel,
            deviceInfoLabel,
            networkInfoLabel
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        appInfoLabel.font = 16.0.toFont
        appInfoLabel.numberOfLines = 0

        systemInfoLabel.font = 16.0.toFont
        systemInfoLabel.numberOfLines = 0

        deviceInfoLabel.font = 16.0.toFont
        deviceInfoLabel.numberOfLines = 0

        networkInfoLabel.font = 16.0.toFont
        networkInfoLabel.numberOfLines = 0
    }

    override func a_Layout() {
        super.a_Layout()

        let spacing: CGFloat = 10
        var currentY: CGFloat = safeAreaHeaderHeight() + 20

        appInfoLabel.size(sizes: [screenWidth() - 40, 80])
        appInfoLabel.point(points: [20, currentY])

        currentY += 80 + spacing

        systemInfoLabel.size(sizes: [screenWidth() - 40, 60])
        systemInfoLabel.point(points: [20, currentY])

        currentY += 60 + spacing

        deviceInfoLabel.size(sizes: [screenWidth() - 40, 80])
        deviceInfoLabel.point(points: [20, currentY])

        currentY += 80 + spacing

        networkInfoLabel.size(sizes: [screenWidth() - 40, 60])
        networkInfoLabel.point(points: [20, currentY])
    }

    override func a_Other() {
        super.a_Other()

        displayAppInfo()
    }

    private func displayAppInfo() {
        appInfoLabel.text = """
        应用信息:
        名称: \(A.app.appName)
        版本: \(A.app.version)
        构建号: \(A.app.build)
        iOS26系统: \(A.app.isIOS26 ? "是" : "否")
        """
    }
}
```

---

## 实用技巧与最佳实践

### 🎯 性能优化技巧

#### 1. 懒加载和缓存策略

```swift
class PerformanceExample: AView {

    // 1. 正确使用懒加载
    private lazy var cachedImageView: UIImageView = {
        let imageView = A.ui.imageView
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    // 2. 避免在主线程进行耗时操作
    override func a_Other() {
        super.a_Other()

        // 在后台线程加载图片
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let image = self?.loadImageFromDisk()

            // 回到主线程更新UI
            DispatchQueue.main.async {
                self?.cachedImageView.image = image
            }
        }
    }

    private func loadImageFromDisk() -> UIImage? {
        // 从磁盘加载图片的示例实现
        guard let imagePath = Bundle.main.path(forResource: "sample", ofType: "png") else {
            return nil
        }
        return UIImage(contentsOfFile: imagePath)
    }
}
```

#### 2. 组件复用与模块化

```swift
class ComponentReuseExample: AView {

    // 定义可复用的组件
    private lazy var cardView: CardComponent = CardComponent()
    private lazy var progressView: ProgressComponent = ProgressComponent()

    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            cardView,
            progressView
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        // 配置卡片组件
        cardView.configure(
            title: "性能监控",
            subtitle: "实时应用性能指标",
            icon: "chart.bar.fill"
        )

        // 配置进度组件
        progressView.configure(progress: 0.75, title: "下载进度")
    }
}

// 可复用的卡片组件
class CardComponent: AView {

    private let iconImageView: UIImageView = A.ui.imageView
    private let titleLabel: UILabel = A.ui.label
    private let subtitleLabel: UILabel = A.ui.label

    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            iconImageView,
            titleLabel,
            subtitleLabel
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        titleLabel.font = A.font.systemFont(ofSize: 16)
        subtitleLabel.font = A.font.systemFont(ofSize: 14)
        subtitleLabel.textColor = A.color.grayColor
    }

    func configure(title: String, subtitle: String, icon: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconImageView.image = A.image.systemImage(systemName: icon)
        iconImageView.tintColor = A.color.darkGrayColor
    }
}

// 可复用的进度组件
class ProgressComponent: AView {

    private let progressView: UIProgressView = UIProgressView(progressViewStyle: .bar)
    private let titleLabel: UILabel = A.ui.label

    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            titleLabel,
            progressView
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        titleLabel.font = A.font.systemFont(ofSize: 14)
        progressView.progressTintColor = A.color.darkGrayColor
        progressView.trackTintColor = A.color.lightGrayColor
    }

    func configure(progress: Float, title: String) {
        titleLabel.text = title
        progressView.progress = progress
    }
}
```

#### 3. 内存管理最佳实践

```swift
class MemoryManagementExample: AView {

    // 使用 weak 引用避免循环引用
    private weak var delegate: MemoryManagementDelegate?
    private var cancellables: [Any] = []

    // 正确使用懒加载
    private lazy var heavyDataProcessor: DataProcessor = {
        let processor = DataProcessor()
        processor.delegate = self
        return processor
    }()

    override func a_Other() {
        super.a_Other()

        setupDataProcessing()
    }

    private func setupDataProcessing() {
        // 使用 AGCD 在后台线程处理数据
        AGCD.async { [weak self] in
            self?.processHeavyData()
        }
    }

    private func processHeavyData() {
        // 处理大量数据
        let largeDataSet = generateLargeDataSet()

        // 在完成后回到主线程
        AGCD.main { [weak self] in
            self?.updateUI(with: largeDataSet)
        }
    }

    private func generateLargeDataSet() -> [String] {
        // 模拟大量数据处理
        return (0..<10000).map { "Item \($0)" }
    }

    private func updateUI(with data: [String]) {
        // 更新UI
        A.log.info("数据处理完成，共 \(data.count) 项")
    }

    deinit {
        // 清理资源
        A.log.info("MemoryManagementExample 已释放")
    }
}

protocol MemoryManagementDelegate: AnyObject {
    func didFinishProcessing()
}

class DataProcessor {
    weak var delegate: MemoryManagementDelegate?

    deinit {
        A.log.info("DataProcessor 已释放")
    }
}
```

#### 4. 线程安全与异步处理

```swift
class ThreadSafetyExample: AView {

    private var counter: Int = 0
    private let dispatchQueue = DispatchQueue(label: "com.example.counter", attributes: .concurrent)
    private let semaphore = DispatchSemaphore(value: 1)

    private let incrementButton: UIButton = A.ui.button
    private let decrementButton: UIButton = A.ui.button
    private let resultLabel: UILabel = A.ui.label

    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            incrementButton,
            decrementButton,
            resultLabel
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        incrementButton.setTitle("递增", for: .normal)
        incrementButton.layerCornerRadius(8)

        decrementButton.setTitle("递减", for: .normal)
        decrementButton.layerCornerRadius(8)

        resultLabel.font = A.font.systemFont(ofSize: 24)
        resultLabel.textAlignment = .center
        resultLabel.text = "0"
    }

    override func updateThemeStyle() {
        super.updateThemeStyle()

        incrementButton.backgroundColor = A.color.grayColor
        decrementButton.backgroundColor = A.color.grayColor
    }

    override func a_Layout() {
        super.a_Layout()

        let spacing: CGFloat = 20
        let buttonWidth: CGFloat = (screenWidth() - 3 * spacing) / 2

        incrementButton.size(sizes: [buttonWidth, 44])
        incrementButton.point(points: [spacing, safeAreaHeaderHeight() + 20])

        decrementButton.size(sizes: [buttonWidth, 44])
        decrementButton.point(points: [incrementButton.right() + spacing, incrementButton.top()])

        resultLabel.size(sizes: [screenWidth() - 40, 60])
        resultLabel.point(points: [20, incrementButton.bottom() + 50])
    }

    override func a_Event() {
        super.a_Event()

        incrementButton.addTouchUpInsideBlock { [weak self] _ in
            self?.incrementCounter()
        }

        decrementButton.addTouchUpInsideBlock { [weak self] _ in
            self?.decrementCounter()
        }
    }

    private func incrementCounter() {
        // 使用串行队列确保线程安全
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.semaphore.wait()
            defer { self?.semaphore.signal() }

            self?.counter += 1

            DispatchQueue.main.async {
                self?.resultLabel.text = "\(self?.counter ?? 0)"
            }
        }
    }

    private func decrementCounter() {
        // 使用串行队列确保线程安全
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.semaphore.wait()
            defer { self?.semaphore.signal() }

            self?.counter = max(0, self?.counter ?? 0 - 1)

            DispatchQueue.main.async {
                self?.resultLabel.text = "\(self?.counter ?? 0)"
            }
        }
    }
}
```

### 🚀 高级日志系统

```swift
class AdvancedLoggingExample: AView {

    private let logButton: UIButton = A.ui.button
    private let errorButton: UIButton = A.ui.button
    private let warningButton: UIButton = A.ui.button
    private let infoButton: UIButton = A.ui.button

    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            logButton,
            errorButton,
            warningButton,
            infoButton
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        logButton.setTitle("Debug 日志", for: .normal)
        errorButton.setTitle("Error 日志", for: .normal)
        warningButton.setTitle("Warning 日志", for: .normal)
        infoButton.setTitle("Info 日志", for: .normal)

        [logButton, errorButton, warningButton, infoButton].forEach {
            $0.layerCornerRadius(8)
        }
    }

    override func updateThemeStyle() {
        super.updateThemeStyle()

        logButton.backgroundColor = A.color.lightGrayColor
        errorButton.backgroundColor = A.color.darkGrayColor
        warningButton.backgroundColor = A.color.grayColor
        infoButton.backgroundColor = A.color.blackColor
    }

    override func a_Layout() {
        super.a_Layout()

        let spacing: CGFloat = 20
        let buttonWidth: CGFloat = (screenWidth() - 5 * spacing) / 4
        let startY = safeAreaHeaderHeight() + 20

        logButton.size(sizes: [buttonWidth, 44])
        logButton.point(points: [spacing, startY])

        errorButton.size(sizes: [buttonWidth, 44])
        errorButton.point(points: [logButton.right() + spacing, startY])

        warningButton.size(sizes: [buttonWidth, 44])
        warningButton.point(points: [errorButton.right() + spacing, startY])

        infoButton.size(sizes: [buttonWidth, 44])
        infoButton.point(points: [warningButton.right() + spacing, startY])
    }

    override func a_Event() {
        super.a_Event()

        logButton.addTouchUpInsideBlock { [weak self] _ in
            self?.generateDebugLogs()
        }

        errorButton.addTouchUpInsideBlock { [weak self] _ in
            self?.generateErrorLogs()
        }

        warningButton.addTouchUpInsideBlock { [weak self] _ in
            self?.generateWarningLogs()
        }

        infoButton.addTouchUpInsideBlock { [weak self] _ in
            self?.generateInfoLogs()
        }
    }

    private func generateDebugLogs() {
        A.log.debug("调试信息：用户执行了操作", tag: "UserAction")
        A.log.debug("当前时间：\(Date())", tag: "Debug")
        A.log.debug("内存使用情况：\(getMemoryUsage())", tag: "Performance")
    }

    private func generateErrorLogs() {
        A.log.error("网络请求失败", tag: "Network")
        A.log.error("数据解析错误：JSON 格式不正确", tag: "DataParsing")
        A.log.error("权限被拒绝", tag: "Permission")
    }

    private func generateWarningLogs() {
        A.log.warning("内存使用率较高：85%", tag: "Performance")
        A.log.warning("网络连接不稳定", tag: "Network")
        A.log.warning("磁盘空间不足", tag: "Storage")
    }

    private func generateInfoLogs() {
        A.log.info("应用启动完成", tag: "AppLifecycle")
        A.log.info("用户登录成功", tag: "Auth")
        A.log.info("数据同步完成", tag: "Sync")
    }

    private func getMemoryUsage() -> String {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4

        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        if kerr == KERN_SUCCESS {
            let memoryInMB = Double(info.resident_size) / (1024 * 1024)
            return String(format: "%.1f MB", memoryInMB)
        }

        return "无法获取内存使用情况"
    }
}
```

---

## 📋 总结

通过本教程的学习，我们深入了解了 Aquarius 框架中 A 类的全局工具功能：

### 🎯 核心要点

1. **统一访问**：通过 A 类提供一致的全局工具访问接口
2. **工具完整**：涵盖了 UI、颜色、图片、存储、系统等各个方面
3. **性能优化**：采用懒加载和缓存策略提高性能

### 🚀 实践建议

1. **熟练掌握**：深入理解每个工具类的核心功能
2. **实际应用**：在项目中有意识地使用这些工具
3. **性能监控**：持续关注应用的性能和内存使用
4. **错误处理**：建立完善的错误处理和日志记录机制
5. **代码规范**：遵循既定的编码规范和最佳实践

### 📚 下一步学习

- 深入学习 AViewController 和 AViewModel 的高级特性
- 探索 Aquarius 框架的主题系统和自定义机制
- 学习数据绑定的高级用法
- 掌握性能优化和调试技巧的更多细节

通过系统性地掌握 A 类全局工具，你将能够更加高效地进行 iOS 开发，构建出高质量的应用程序。记住，工具只是手段，优秀的代码架构和用户体验才是目标。

---

> 🎉 **恭喜！** 你已经完成了 Aquarius iOS 开发框架第三课的学习。下一课我们将深入探讨 AViewController 类的详解内容。