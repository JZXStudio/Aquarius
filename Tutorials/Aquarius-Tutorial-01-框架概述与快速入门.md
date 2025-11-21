# Aquarius iOS 开发框架教程 01 - 框架概述与快速入门

> 📚 **Aquarius 教程系列：基础入门**  
> 🎯 **本教程目标**：全面了解 Aquarius 框架的核心概念和设计理念

---

## 📖 目录

1. [Aquarius 框架简介](#aquarius-框架简介)
2. [设计理念与核心特色](#设计理念与核心特色)
3. [架构优势](#架构优势)
4. [快速上手](#快速上手)
5. [第一个 Aquarius 应用](#第一个-aquarius-应用)
6. [学习路径](#学习路径)

---

## Aquarius 框架简介

### 什么是 Aquarius？

**Aquarius** 是一个专为独立开发者和中小型团队设计的 iOS 开发框架，旨在帮助开发者规范化开发流程，提高开发效率，构建高质量的 iOS 应用程序。

### 核心定位

- 🎯 **目标用户**：独立开发者、创业团队、学习者
- 🚀 **主要价值**：提高开发效率、降低技术门槛、规范化开发流程
- 💡 **核心理念**：简洁、高效、易维护
- 🏗️ **架构基础**：MVVM 设计模式 + 洋葱开发法

---

## 设计理念与核心特色

### 🧅 洋葱开发法 (Onion Architecture)

传统开发中，我们经常遇到这样的问题：

- ViewController 文件动辄几千行代码
- 代码职责混杂，难以维护
- 团队协作时难以理解和接手代码

**洋葱开发法** 将复杂的界面逻辑按照职责进行分层：

```swift
class ExampleViewController: AViewController {

    // 1. 初始化阶段
    override func a_Preview() {
        // 页面创建前的准备工作
    }

    override func a_Begin() {
        // 页面开始时的初始化工作
    }

    override func a_Navigation() {
        // 设置导航条
    }

    override func a_Delegate() {
        // 设置委托
    }

    override func updateThemeStyle() {
        // 主题更新
    }

    override func a_Notification() {
        // 设置通知
    }

    override func a_Bind() {
        // 设置数据绑定
    }

    override func a_Observe() {
        // 设置观察者
    }

    override func a_Event() {
        // 设置事件
    }

    // 2. 视图加载阶段
    override func a_UI() {
        // 添加 UI 组件
    }

    override func a_UIConfig() {
        // 配置 UI 属性
    }

    override func a_Layout() {
        // 设置布局
    }

    override func a_Other() {
        // 其他设置
    }

    override func a_End() {
        // 结尾设置
    }

    override func a_Test() {
        // 测试代码（仅 Debug 模式执行，Release下不执行）
    }

    // 3. 销毁阶段
    override func a_Clear() {
        // 清理资源
    }
}
```

### 🎨 设计特色

#### 1. 高效率

- **快速 UI 创建**：通过 `A.ui` 工具类一键创建常用 UI 组件
- **便捷布局系统**：简洁的布局调用方法，减少约束代码
- **丰富扩展方法**：数据类型转换、图片处理、格式化等

#### 2. 低侵入性

- **渐进式集成**：可在现有项目中逐步引入
- **无第三方依赖**：框架本身不依赖任何外部库
- **兼容现有代码**：老代码不受影响

#### 3. 模块化设计

- **职责分离**：每个类都有明确的职责边界
- **可测试性**：易于单元测试和集成测试
- **可维护性**：代码结构清晰，便于后期维护

#### 4. 现代化架构

- **MVVM 模式**：数据层与视图层分离
- **响应式编程**：KVO 数据绑定
- **主题系统**：支持深色模式和动态主题

---

## 架构优势

### 🏗️ MVVM + 洋葱架构的优势

| 传统 MVC              | Aquarius MVVM + 洋葱 |
| ------------------- | ------------------ |
| ViewController 职责过重 | 职责明确，分层清晰          |
| 数据和 UI 耦合严重         | 数据绑定，UI 自动更新       |
| 视图逻辑难以测试            | ViewModel 可独立测试    |
| 代码组织混乱              | 洋葱方法，结构化开发         |

### 📊 代码组织对比

**传统 MVC 方式：**

```swift
class TraditionalViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTable: UITableView!

    var dataArray: [String] = []
    var selectedIndex: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // 导航设置
        navigationItem.title = "标题"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "编辑", 
            style: .plain, 
            target: self, 
            action: #selector(editButtonTapped)
        )

        // UI 配置
        titleLabel.text = "页面标题"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)

        contentTable.delegate = self
        contentTable.dataSource = self
        contentTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        contentTable.frame = CGRect(x: 0, y: 200, width: view.bounds.width, height: 300)

        // 通知设置
        NotificationCenter.default.addObserver(
            self, 
            selector: #selector(dataUpdated), 
            name: Notification.Name("DataUpdated"), 
            object: nil
        )

        // 数据加载
        loadData()
    }

    @objc func editButtonTapped() {
        // 编辑逻辑
        selectedIndex = 0
        contentTable.reloadData()
    }

    @objc func dataUpdated() {
        // 处理数据更新
        loadData()
    }

    func loadData() {
        // 网络请求
        dataArray = ["数据1", "数据2", "数据3"]
        contentTable.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
```

**Aquarius 方式：**

```swift
class AquariusViewController: AViewController {
    private let viewModel: AquariusViewModel = AquariusViewModel()
    private let contentView: AquariusContentView = AquariusContentView()

    override func a_Navigation() {
        super.a_Navigation()

        navigation_Title = "标题"
        navigation_RightBarButtonText = "编辑"
        navigation_RigthBarButtonSelector {
            self.viewModel.enterEditMode()
        }
    }

    override func a_Notification() {
        super.a_Notification()

        Manage_SetNotification("DataUpdated")
    }

    override func a_Bind() {
        super.a_Bind()

        viewModel.bindsTo([
            "dataArray" : #keyPath(viewModel.dataArray)
        ])

        // 使用数据绑定处理数据更新
        contentView.bindsTo([
            "dataBind" : #keyPath(contentView.binding_data)
        ])

        contentView.bindsFrom([
            "dataBind" : #keyPath(viewModel.dataArray)
        ])
    }

    // ✅ 数据绑定自动处理UI更新，无需重复观察

    override func a_UI() {
        super.a_UI()

        addRootView(view: contentView)
    }

    override func a_Other() {
        super.a_Other()

        viewModel.loadData()
    }
}
```

---

## 快速上手

### 📋 系统要求

- **iOS 版本**：15.0+
- **Swift 版本**：5.0+
- **Xcode 版本**：13.0+

### 🚀 安装方式

#### 方式一：Swift Package Manager

1. 在 Xcode 中打开你的项目

2. 选择 `File` > `Add Package Dependencies`

3. 输入仓库 URL：
   
   ```
   https://github.com/JZXStudio/Aquarius.git
   ```

4. 选择版本（建议使用最新稳定版）

5. 点击 `Add Package`

#### 方式二：手动集成

1. 克隆仓库：
   
   ```bash
   git clone https://github.com/JZXStudio/Aquarius.git
   ```

2. 将 `Aquarius` 文件夹添加到你的项目中

3. 在项目设置中添加框架引用

---

## 第一个 Aquarius 应用

让我们创建一个简单的计数器应用来体验 Aquarius 框架的强大功能。

### 📱 项目结构

```
MyFirstAquariusApp/
├── MyFirstAquariusApp/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── ViewController.swift          // 传统 ViewController
│   ├── CounterViewController.swift   // Aquarius ViewController
│   ├── CounterView.swift            // Aquarius View
│   ├── CounterViewModel.swift       // Aquarius ViewModel
│   └── Main.storyboard
└── Package.swift
```

### 🎯 实现步骤

#### 1. 创建 ViewModel

```swift
// CounterViewModel.swift
import Foundation
import Aquarius

class CounterViewModel: AViewModel {

    // 计数器数据
    @objc dynamic var count: Int = 0 {
        willSet {
            A.log.info(newValue != 0 ? "计数增加：\(newValue)" : "计数重置：\(newValue)")
        }
    }

    override func a_Bind() {
        super.a_Bind()

        // 设置数据绑定
        bindsTo(dict: [
            "count" : #keyPath(count)
        ])
    }
}
```

#### 2. 创建 View

```swift
// CounterView.swift
import UIKit
import Aquarius

class CounterView: AView {

    // UI 组件
    private let titleLabel: UILabel = A.ui.label
    private let counterLabel: UILabel = A.ui.label
    private let incrementButton: UIButton = A.ui.button
    private let resetButton: UIButton = A.ui.button

    // 绑定数据
    @objc dynamic private var binding_count: Int = 0

    override func a_UI() {
        super.a_UI()

        // 添加子视图
        addSubviews(views: [
            titleLabel,
            counterLabel,
            incrementButton,
            resetButton
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        // 配置标题
        titleLabel.text = "计数器"
        titleLabel.font = 16.0.toFont
        titleLabel.textCenterAlignment()

        // 配置计数显示
        counterLabel.font = 16.0.toFont
        counterLabel.textCenterAlignment()
        counterLabel.text = "0"

        // 配置增加按钮
        incrementButton.setTitle("+1", for: .normal)
        incrementButton.layerCornerRadius(8)

        // 配置重置按钮
        resetButton.setTitle("重置", for: .normal)
        resetButton.layerCornerRadius(8)
    }

    override func updateThemeStyle() {
        super.updateThemeStyle()

        counterLabel.textColor = AppTheme.shared.primaryColor
        incrementButton.backgroundColor = AppTheme.shared.primaryColor
        resetButton.backgroundColor = AppTheme.shared.secondaryColor
    }

    override func a_Layout() {
        super.a_Layout()

        // 设置布局
        titleLabel.size(sizes: [screenWidth() - 40, 40])
        titleLabel.point(points: [20, 100])

        counterLabel.size(sizes: [screenWidth() - 40, 100])
        counterLabel.point(points: [20, titleLabel.bottom() + 20])

        incrementButton.size(sizes: [100, 44])
        incrementButton.point(points: [screenWidth() / 2 - 120, counterLabel.bottom() + 40])

        resetButton.size(sizes: [100, 44])
        resetButton.point(points: [screenWidth() / 2 + 20, counterLabel.bottom() + 40])
    }

    override func a_Bind() {
        super.a_Bind()

        // 设置数据源绑定
        bindsFrom(dict: [
            "count" : #keyPath(binding_count)
        ])
    }

    override func a_Event() {
        super.a_Event()

        // 设置按钮事件
        incrementButton.addTouchUpInsideBlock { [weak self] _ in
            self?.counterLabel.text = "\(self?.binding_count++ ?? 0)"
        }

        resetButton.addTouchUpInsideBlock { [weak self] _ in
            self?.binding_count = 0
            self?.counterLabel.text = "\(self?.binding_count ?? 0)"
        }
    }
}
```

#### 3. 创建 ViewController

```swift
// CounterViewController.swift
import UIKit
import Aquarius

class CounterViewController: AViewController {

    private let viewModel: CounterViewModel = CounterViewModel()
    private let counterView: CounterView = CounterView()

    override func a_Navigation() {
        super.a_Navigation()

        navigation_Title = "我的第一个 Aquarius 应用"
    }

    override func a_UI() {
        super.a_UI()

        addRootView(view: counterView)
    }
}
```

#### 4. 创建 App 主题

```swift
// AppTheme.swift
import UIKit
import Aquarius

class AppTheme: DesignColorProtocol {
    public static let shared = AppTheme()

    var primaryColor: UIColor {
        get {
            AThemeStyle.getThemeColor([
                .Light : 0x007AFF.toColor,
                .Dark : 0x0A84FF.toColor
            ])
        }
    }

    var secondaryColor: UIColor {
        get {
            AThemeStyle.getThemeColor([
                .Light : 0x5856D6.toColor,
                .Dark : 0x5E5CE6.toColor
            ])
        }
    }

    var textPrimaryColor: UIColor {
        get {
            AThemeStyle.getThemeColor([
                .Light : 0x000000.toColor,
                .Dark : 0xFFFFFF.toColor
            ])
        }
    }

    var backgroundColor: UIColor {
        get {
            AThemeStyle.getThemeColor([
                .Light : 0xF2F2F7.toColor,
                .Dark : 0x000000.toColor
            ])
        }
    }
    /*
    // 实现其他必需的属性...
    var secondaryColor: UIColor { get }
    var textSecondaryColor: UIColor { get }
    var textTertiaryColor: UIColor { get }
    var secondaryBackgroundColor: UIColor { get }
    var tertiaryBackgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    var opaqueSeparatorColor: UIColor { get }
    var fillColor: UIColor { get }
    var secondaryFillColor: UIColor { get }
    var tertiaryFillColor: UIColor { get }
    var linkColor: UIColor { get }
    var placeholderTextColor: UIColor { get }
    var labelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var tertiaryLabelColor: UIColor { get }
    var groupBackgroundColor: UIColor { get }
    var systemBackgroundColor: UIColor { get }
    var secondarySystemBackgroundColor: UIColor { get }
    var tertiarySystemBackgroundColor: UIColor { get }
    var systemFillColor: UIColor { get }
    var secondarySystemFillColor: UIColor { get }
    var tertiarySystemFillColor: UIColor { get }
    var systemGroupedBackgroundColor: UIColor { get }
    var secondarySystemGroupedBackgroundColor: UIColor { get }
    var tertiarySystemGroupedBackgroundColor: UIColor { get }
    var navigationBarColor: UIColor { get }
    var tabBarColor: UIColor { get }
    */
}
```

### 🎉 运行效果

启动应用后，你将看到一个简洁的计数器界面：

- **标题显示**："我的第一个 Aquarius 应用"
- **计数器标签**：显示当前数值
- **+1 按钮**：增加计数
- **重置按钮**：将计数归零
- **主题支持**：自动适配深色模式

### 💡 代码分析

这个简单的计数器应用展示了 Aquarius 框架的核心特点：

1. **洋葱开发法**：每个类都按照职责分组组织代码
2. **MVVM 架构**：数据逻辑与视图分离
3. **数据绑定**：View 的变化自动更新到 ViewModel
4. **主题支持**：自动适配系统主题

---

## 学习路径

### 🎯 完整学习计划

建议按照以下顺序学习 Aquarius 框架：

| 阶段        | 教程内容                | 学习目标         |
| --------- | ------------------- | ------------ |
| **基础入门**  | 框架概述与快速入门           | ✅ 了解核心概念     |
|           | MVVM 架构与洋葱开发法       | ✅ 理解设计理念     |
|           | 项目搭建与环境配置           | ✅ 掌握开发环境     |
| **核心架构**  | A 类全局工具详解           | ✅ 熟练使用工具类    |
|           | AViewController 类详解 | ✅ 掌握控制器开发    |
|           | AView 类详解           | ✅ 掌握视图开发     |
|           | AViewModel 类详解      | ✅ 掌握数据层开发    |
| **UI 开发** | AUI 快速创建组件          | ✅ 提高 UI 开发效率 |
|           | UI 布局系统详解           | ✅ 掌握响应式布局    |
|           | 主题与样式系统             | ✅ 实现统一样式     |
| **数据管理**  | 数据绑定系统详解            | ✅ 实现自动数据同步   |
|           | 通知管理系统              | ✅ 掌握组件间通信    |
|           | 本地存储与文件操作           | ✅ 实现数据持久化    |
| **高级特性**  | 扩展方法大全              | ✅ 提高开发效率     |
|           | 实用工具类详解             | ✅ 利用框架优势     |
|           | 性能优化与内存管理           | ✅ 编写高质量代码    |
| **实战项目**  | 完整项目开发              | ✅ 综合应用所有技能   |
|           | 最佳实践与优化             | ✅ 达到专业水准     |

### 📚 下一步学习

完成了本教程后，建议继续学习：

- 📖 **教程 02**：[MVVM 架构与洋葱开发法详解](./Aquarius-Tutorial-02-MVVM架构与洋葱开发法.md)
- 🔧 **实践项目**：尝试用 Aquarius 重构你的现有项目
- 💬 **社区交流**：小红书、微信、B站等平台搜索**JZXStudio**，与作者联系。你也可以加入到交流群，与Aquarius开发者一起讨论开发问题。

### 🌟 学习建议

1. **动手实践**：每个教程都要跟着编写代码
2. **循序渐进**：不要跳跃，按顺序学习
3. **深入理解**：不仅要知道怎么做，更要理解为什么
4. **举一反三**：尝试将学习的内容应用到自己的项目中
5. **持续更新**：关注框架版本更新和新特性

---

## 总结

恭喜你完成了 Aquarius 框架的第一个教程！通过本教程，你已经：

- ✅ **了解了 Aquarius 框架的核心特色和设计理念**
- ✅ **掌握了洋葱开发法的基本概念**
- ✅ **体验了 MVVM 架构的优势**
- ✅ **完成了第一个基于 Aquarius 的应用**

Aquarius 框架不仅仅是一个工具集，更是一套完整的开发方法论。它帮助你构建结构清晰、易于维护的 iOS 应用。

**下一步**：继续学习 [MVVM 架构与洋葱开发法详解](./Aquarius-Tutorial-02-MVVM架构与洋葱开发法.md)，深入理解框架的核心设计思想。

---

> **📝 教程信息**
> 
> - **版本**：v1.0
> - **更新日期**：2025年11月17日
> - **适用版本**：Aquarius 1.2.0+
> - **难度等级**：⭐⭐☆☆☆（入门）
> 
> **👨‍💻 作者**：JZXStudio  
> **📞 联系方式**：studio_jzx@163.com 
> 
> **🌐 项目地址**：https://github.com/JZXStudio/Aquarius