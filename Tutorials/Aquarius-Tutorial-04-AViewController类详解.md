# Aquarius iOS 开发框架教程 04 - AViewController 类详解

> 📚 **Aquarius 教程系列：UI 开发**  
> 🎯 **本教程目标**：深入掌握 AViewController 的生命周期和核心功能

---

## 📖 目录

1. [AViewController 概述](#aviewcontroller-概述)
2. [生命周期方法详解](#生命周期方法详解)
3. [导航管理详解](#导航管理详解)
4. [视图管理详解](#视图管理详解)
5. [事件处理详解](#事件处理详解)
6. [数据绑定详解](#数据绑定详解)
7. [实用技巧与最佳实践](#实用技巧与最佳实践)

---

## AViewController 概述

### 🏗️ 设计理念

AViewController 是 Aquarius 框架的核心基类，它融合了 MVVM 架构模式和洋葱开发法的优势，提供了统一且规范化的控制器开发模式。

```swift
open class AViewController: AViewBase, ANotificationDelegate {
    // MARK: - 核心属性
    public var navigation_Title: String = ""
    public var navigation_Subtitle: String = ""
    public var navigation_Hidden: Bool = false
    public var navigation_BarTintColor: UIColor?
    public var navigation_TintColor: UIColor?

    // MARK: - 导航按钮
    public var navigation_LeftBarButtonText: String = ""
    public var navigation_RightBarButtonText: String = ""
    public var navigation_LeftBarButtonSelector: (() -> Void)?
    public var navigation_RigthBarButtonSelector: (() -> Void)?

    // MARK: - 视图管理
    public var rootView: UIView?
    public var a_view: AView = AView()

    // MARK: - 核心管理器
    internal var delegateManagers: Array<Dictionary<String, AnyObject>> = []
    internal var coreNotification: ANotification = ANotification()
}
```

### 🎯 核心特点

1. **洋葱开发法支持**：提供了完整的生命周期方法
2. **MVVM 架构集成**：内置数据绑定和观察者机制
3. **自动化管理**：委托、通知、内存管理自动化
4. **导航系统集成**：简化导航栏配置和管理
5. **主题系统支持**：无缝集成主题切换功能

---

## 生命周期方法详解

### 🔄 完整生命周期流程

AViewController 遵循严格的生命周期管理，确保代码执行顺序的一致性：

```swift
class LifecycleExampleViewController: AViewController {

    // ========== 第1层：初始化层 ==========

    override func a_Preview() {
        printLog("1. a_Preview() - 页面预览")

        // 检查必要条件
        guard checkPrerequisites() else {
            printWarning("页面预览失败，终止初始化")
            return
        }

        // 环境检查
        checkEnvironment()
    }

    override func a_Begin() {
        printLog("2. a_Begin() - 页面开始")

        // 埋点设置
        setupAnalytics()

        // 变量初始化
        initializeVariables()
    }

    // ========== 第2层：配置层 ==========

    override func a_Navigation() {
        printLog("3. a_Navigation() - 导航配置")

        navigation_Title = "生命周期演示"
        navigation_RightBarButtonText = "设置"
        navigation_RigthBarButtonSelector {
            self.showSettings()
        }
    }

    override func a_Delegate() {
        printLog("4. a_Delegate() - 委托设置")

        // 设置各种委托
        setupDelegates()
    }

    override func a_Notification() {
        printLog("5. a_Notification() - 通知设置")

        Manage_SetNotification("DataUpdated")
        Manage_SetNotification(A.kApplicationWillEnterForeground)
    }

    override func a_Bind() {
        printLog("6. a_Bind() - 数据绑定")

        // 设置数据绑定
        setupDataBinding()
    }

    override func a_Observe() {
        printLog("7. a_Observe() - 观察者设置")

        // 设置属性观察
        setupObservers()
    }

    override func a_Event() {
        printLog("8. a_Event() - 事件设置")

        // 设置事件监听
        setupEventListeners()
    }

    // ========== 第3层：视图层 ==========

    override func a_UI() {
        printLog("9. a_UI() - UI 创建")

        // 创建 UI 组件
        createUIElements()
    }

    override func a_UIConfig() {
        printLog("10. a_UIConfig() - UI 配置")

        // 配置 UI 属性
        configureUIElements()
    }

    override func a_Layout() {
        printLog("11. a_Layout() - UI 布局")

        // 设置布局约束
        setupLayout()
    }

    // ========== 第4层：业务层 ==========

    override func a_Other() {
        printLog("12. a_Other() - 其他业务")

        // 执行业务逻辑
        performBusinessLogic()
    }

    override func a_End() {
        printLog("13. a_End() - 结尾处理")

        // 最终设置
        finalizeSetup()
    }

    override func a_Test() {
        printLog("14. a_Test() - 测试代码 (仅 Debug)")

        // 仅在 Debug 模式下执行
        validateFunctionality()
    }

    // ========== 第5层：清理层 ==========

    override func a_Clear() {
        printLog("15. a_Clear() - 清理资源")

        // 资源清理
        cleanupResources()
    }

    deinit {
        printLog("16. deinit - 对象释放")
    }
}
```

### 🔍 关键方法详细说明

#### 1. a_Preview() - 洋葱开发法第一个方法入口

```swift
override func a_Preview() {
    super.a_Preview()

    // 检查用户权限
    guard checkUserPermissions() else {
        showPermissionError()
        return
    }

    // 检查必要数据
    guard validateRequiredData() else {
        showDataError()
        return
    }

    printLog("预览检查通过，开始初始化")
}

private func checkUserPermissions() -> Bool {
    // 检查相机权限
    let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
    guard cameraStatus == .authorized else {
        requestCameraPermission()
        return false
    }

    // 检查位置权限
    let locationStatus = CLLocationManager.authorizationStatus()
    guard locationStatus != .denied else {
        requestLocationPermission()
        return false
    }

    return true
}
```

#### 2. a_Begin() - 初始化开始（大部分代码写在这里）

```swift
override func a_Begin() {
    super.a_Begin()

    // 设置分析埋点
    setupAnalytics()

    // 初始化配置
    initializeConfiguration()

    // 设置全局样式
    setupGlobalStyles()
}

private func setupAnalytics() {
    // 页面曝光埋点
    AnalyticsManager.trackPageView(screenName: String(describing: self))

    // 用户行为埋点
    AnalyticsManager.setUserProperties([
        "view_controller_type": "lifecycle_demo"
    ])
}

private func initializeConfiguration() {
    // 从配置文件中读取设置
    let config = AppConfiguration.shared
    self.requestTimeout = config.requestTimeout
    self.maxRetryCount = config.maxRetryCount
}
```

#### 3. a_Other() - 其他业务逻辑处理

```swift
override func a_Other() {
    super.a_Other()

    // 加载初始数据
    loadInitialData()

    // 设置定时器
    setupTimers()

    // 监听系统通知
    setupSystemObservers()
}

private func loadInitialData() {
    // 如果有 ViewModel，加载数据
    if let viewModel = self as? DataLoadable {
        viewModel.loadData { [weak self] result in
            switch result {
            case .success:
                self?.handleDataLoaded()
            case .failure(let error):
                self?.handleDataLoadError(error)
            }
        }
    }
}

private func setupTimers() {
    // 设置定时刷新
    refreshTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
        self?.performPeriodicRefresh()
    }
}

private func setupSystemObservers() {
    // 监听应用状态变化
    Manage_SetNotification(A.kApplicationDidEnterBackground)
    Manage_SetNotification(A.kApplicationWillEnterForeground)
}
```

---

## 导航管理详解

### 🎯 导航栏配置

AViewController 提供了简洁的导航栏配置接口：

```swift
class NavigationExampleViewController: AViewController {

    override func a_Navigation() {
        super.a_Navigation()

        // 1. 基本标题配置
        navigation_Title = "导航演示"

        // 2. 导航栏样式
        navigation_Hidden = false
        navigation_BarTintColor = .black

        navigation_TintColor = .white

        // 3. 左右按钮配置
        navigation_LeftBarButtonText = "返回"
        navigation_RightBarButtonText = "更多"

        // 4. 按钮事件
        navigation_LeftBarButtonSelector {
            self.handleBackButton()
        }

        navigation_RigthBarButtonSelector {
            self.showMoreOptions()
        }
    }

    private func handleBackButton() {
        // 自定义返回逻辑
        if hasUnsavedChanges() {
            showUnsavedChangesAlert()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func showMoreOptions() {
        let actionSheet = UIAlertController(title: "更多选项", message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "分享", style: .default) { _ in
            self.shareContent()
        })

        actionSheet.addAction(UIAlertAction(title: "设置", style: .default) { _ in
            self.showSettings()
        })

        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel))

        present(actionSheet, animated: true)
    }

    private func hasUnsavedChanges() -> Bool {
        // 检查是否有未保存的更改
        return false
    }
}
```

### 🔄 动态导航更新

```swift
class DynamicNavigationViewController: AViewController {

    private var isEditing: Bool = false

    override func a_Navigation() {
        super.a_Navigation()

        updateNavigationForMode()
    }

    private func updateNavigationForMode() {
        if isEditing {
            // 编辑模式
            navigation_Title = "编辑资料"
            navigation_LeftBarButtonText = "取消"
            navigation_RightBarButtonText = "保存"

            navigation_LeftBarButtonSelector {
                self.cancelEditing()
            }

            navigation_RigthBarButtonSelector {
                self.saveChanges()
            }
        } else {
            // 浏览模式
            navigation_Title = "个人资料"
            navigation_LeftBarButtonText = "返回"
            navigation_RightBarButtonText = "编辑"

            navigation_LeftBarButtonSelector {
                self.goBack()
            }

            navigation_RigthBarButtonSelector {
                self.enterEditingMode()
            }
        }

        // 动画更新导航栏
        UIView.transition(with: navigationController?.navigationBar ?? UIView(), duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.navigationController?.navigationBar.setNeedsLayout()
        })
    }

    private func enterEditingMode() {
        isEditing = true
        updateNavigationForMode()

        // 启用编辑控件
        enableEditingControls()
    }

    private func cancelEditing() {
        isEditing = false
        updateNavigationForMode()

        // 恢复原始数据
        restoreOriginalData()

        // 禁用编辑控件
        disableEditingControls()
    }

    private func saveChanges() {
        // 保存更改
        saveDataToServer { [weak self] result in
            switch result {
            case .success:
                self?.isEditing = false
                self?.updateNavigationForMode()
                self?.disableEditingControls()
                self?.showMessage("保存成功")
            case .failure(let error):
                self?.showError("保存失败: \(error.localizedDescription)")
            }
        }
    }
}
```

### 🎨 自定义导航栏

```swift
class CustomNavigationViewController: AViewController {

    override func a_Navigation() {
        super.a_Navigation()

        // 隐藏默认导航栏，使用自定义导航栏
        navigation_Hidden = true
    }

    override func a_UI() {
        super.a_UI()

        // 创建自定义导航栏
        createCustomNavigationBar()
    }

    private func createCustomNavigationBar() {
        // 自定义导航栏背景
        let navBackground = UIView()
        navBackground.backgroundColor = .white
        navBackground.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: 88)

        // 添加毛玻璃效果
        let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffect.frame = navBackground.bounds
        navBackground.addSubview(blurEffect)

        // 导航标题
        let titleLabel = UILabel()
        titleLabel.text = "自定义导航"
        titleLabel.textColor = .white
        titleLabel.font = 16.0.toFont
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 60, y: 50, width: screenWidth() - 120, height: 30)

        // 返回按钮
        let backButton = UIButton(type: .system)
        backButton.setTitle("返回", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.frame = CGRect(x: 20, y: 50, width: 60, height: 30)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)

        // 更多按钮
        let moreButton = UIButton(type: .system)
        moreButton.setTitle("•••", for: .normal)
        moreButton.setTitleColor(.white, for: .normal)
        moreButton.frame = CGRect(x: screenWidth() - 60, y: 50, width: 40, height: 30)
        moreButton.addTarget(self, action: #selector(handleMoreButton), for: .touchUpInside)

        navBackground.addSubviews(views: [titleLabel, backButton, moreButton])
        view.addSubview(navBackground)
    }

    @objc private func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handleMoreButton() {
        showMoreOptions()
    }
}
```

---

## 视图管理详解

### 📱 根视图管理

```swift
class RootViewExampleViewController: AViewController {

    private let mainContentView: UIView = A.ui.view
    private let loadingView: UIView = A.ui.view
    private let errorView: UIView = A.ui.view

    private var currentState: ViewState = .loading {
        didSet {
            updateViewState()
        }
    }

    enum ViewState {
        case loading
        case content
        case error
    }

    override func a_UI() {
        super.a_UI()

        // 设置根视图
        setRootView(mainContentView)

        // 创建加载视图
        createLoadingView()

        // 创建错误视图
        createErrorView()
    }

    private func setRootView(_ view: UIView) {
        // 使用框架提供的根视图设置方法
        addRootView(view: view)
    }

    private func createLoadingView() {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()

        let loadingLabel = UILabel()
        loadingLabel.text = "加载中..."
        loadingLabel.font = A.font.bodyFont
        loadingLabel.textAlignment = .center

        loadingView.addSubviews(views: [indicator, loadingLabel])

        // 布局加载视图
        indicator.size(sizes: [50, 50])
        indicator.point(points: [screenWidth() / 2 - 25, 100])

        loadingLabel.size(sizes: [screenWidth() - 40, 30])
        loadingLabel.point(points: [20, indicator.bottom() + 20])

        loadingView.isHidden = true
    }

    private func createErrorView() {
        let errorImage = UIImageView(image: A.image.errorImage)
        let errorLabel = UILabel()
        errorLabel.text = "加载失败，请重试"
        errorLabel.font = A.font.bodyFont
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0

        let retryButton = UIButton(type: .system)
        retryButton.setTitle("重试", for: .normal)
        retryButton.backgroundColor = A.color.primary
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layerCornerRadius(8)
        retryButton.addTarget(self, action: #selector(retryLoading), for: .touchUpInside)

        errorView.addSubviews(views: [errorImage, errorLabel, retryButton])

        // 布局错误视图
        errorImage.size(sizes: [80, 80])
        errorImage.point(points: [screenWidth() / 2 - 40, 80])

        errorLabel.size(sizes: [screenWidth() - 40, 60])
        errorLabel.point(points: [20, errorImage.bottom() + 20])

        retryButton.size(sizes: [120, 44])
        retryButton.point(points: [screenWidth() / 2 - 60, errorLabel.bottom() + 30])

        errorView.isHidden = true
    }

    private func updateViewState() {
        loadingView.isHidden = currentState != .loading
        mainContentView.isHidden = currentState != .content
        errorView.isHidden = currentState != .error
    }

    @objc private func retryLoading() {
        currentState = .loading

        // 重新加载数据
        loadData()
    }

    private func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            // 模拟加载成功
            self?.currentState = .content
        }
    }
}
```

### 🎨 子视图管理

```swift
class SubviewManagementViewController: AViewController {

    private let headerView: UIView = A.ui.view
    private let contentScrollView: UIScrollView = A.ui.scrollView
    private let footerView: UIView = A.ui.view

    override func a_UI() {
        super.a_UI()

        // 创建头部视图
        createHeaderView()

        // 创建内容滚动视图
        createContentScrollView()

        // 创建底部视图
        createFooterView()
    }

    private func createHeaderView() {
        let titleLabel = UILabel()
        titleLabel.text = "头部视图"
        titleLabel.font = A.font.titleFont
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = A.color.primary
        titleLabel.textColor = .white

        headerView.addSubview(titleLabel)

        // 设置布局
        titleLabel.size(sizes: [screenWidth(), 60])
        titleLabel.point(points: [0, 0])

        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: 60)
    }

    private func createContentScrollView() {
        contentScrollView.isPagingEnabled = false
        contentScrollView.showsVerticalScrollIndicator = true
        contentScrollView.showsHorizontalScrollIndicator = false

        // 添加内容到滚动视图
        createScrollContent()
    }

    private func createScrollContent() {
        let contentHeight: CGFloat = 800
        contentScrollView.contentSize = CGSize(width: screenWidth(), height: contentHeight)

        // 创建多个内容块
        for i in 0..<5 {
            let contentBlock = createContentBlock(index: i)
            contentBlock.point(points: [0, CGFloat(i) * 160])
            contentScrollView.addSubview(contentBlock)
        }
    }

    private func createContentBlock(index: Int) -> UIView {
        let block = UIView()
        block.backgroundColor = A.color.surface
        block.layerCornerRadius(8)
        block.layerBorderWidth(1)
        block.layerBorderColor(.lightGray)

        let label = UILabel()
        label.text = "内容块 \(index + 1)"
        label.font = A.font.bodyFont
        label.textAlignment = .center

        let button = UIButton(type: .system)
        button.setTitle("点击我", for: .normal)
        button.backgroundColor = A.color.accent
        button.setTitleColor(.white, for: .normal)
        button.layerCornerRadius(6)
        button.addTarget(self, action: #selector(handleContentButtonTapped(_:)), for: .touchUpInside)
        button.tag = index

        block.addSubviews(views: [label, button])

        // 布局
        label.size(sizes: [screenWidth() - 40, 40])
        label.point(points: [20, 20])

        button.size(sizes: [100, 30])
        button.point(points: [screenWidth() / 2 - 50, 80])

        block.frame = CGRect(x: 20, y: CGFloat(index) * 160, width: screenWidth() - 40, height: 130)

        return block
    }

    private func createFooterView() {
        let footerLabel = UILabel()
        footerLabel.text = "底部视图"
        footerLabel.font = 16.0.toFOnt
        footerLabel.textAlignment = .center
        footerLabel.backgroundColor = .gray
        footerLabel.textColor = .white

        footerView.addSubview(footerLabel)

        footerLabel.size(sizes: [screenWidth(), 50])
        footerLabel.point(points: [0, 0])

        footerView.frame = CGRect(x: 0, y: screenHeight() - 50 - safeAreaFooterHeight(), width: screenWidth(), height: 50)
    }

    override func a_Layout() {
        super.a_Layout()

        // 头部视图
        headerView.point(points: [0, safeAreaHeaderHeight()])

        // 滚动视图
        contentScrollView.size(
            width: screenWidth(),
            height: screenHeight() - headerView.height() - footerView.height() - safeAreaHeaderHeight() - safeAreaFooterHeight()
        )
        contentScrollView.point(points: [0, headerView.bottom()])

        // 底部视图
        footerView.point(points: [0, contentScrollView.bottom()])
    }

    @objc private func handleContentButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        showAlert("点击了内容块 \(index + 1)")
    }
}
```

---

## 总结

AViewController 是 Aquarius 框架的核心组件，它通过以下特性为 iOS 开发提供了强大的支持：

### 🎯 核心优势

1. **洋葱开发法**：提供清晰的生命周期管理
2. **MVVM 集成**：内置数据绑定和观察者机制
3. **自动化管理**：委托、通知、内存管理自动化
4. **主题支持**：无缝集成主题切换功能
5. **调试友好**：丰富的调试和测试支持

### 💡 最佳实践

1. **严格遵循生命周期**：按照洋葱开发法的层次组织代码
2. **合理使用懒加载**：避免不必要的初始化
3. **注意内存管理**：使用弱引用避免循环引用
4. **做好错误处理**：根据错误类型进行相应处理
5. **利用调试工具**：在开发阶段充分使用调试功能

### 🔄 持续改进

通过合理使用 AViewController，可以显著提高代码质量和开发效率。建议在项目中：

1. 建立统一的代码规范
2. 制定错误处理策略
3. 设置调试和监控机制
4. 持续优化性能表现
5. 分享和复用最佳实践

掌握了 AViewController，就掌握了 Aquarius 框架的核心精髓，能够高效地进行 iOS 应用开发。