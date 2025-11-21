# Aquarius iOS 开发框架教程 02 - MVVM 架构与洋葱开发法

> 📚 **Aquarius 教程系列：基础入门**  
> 🎯 **本教程目标**：深入理解 MVVM 架构和洋葱开发法的核心思想

---

## 📖 目录

1. [MVVM 架构详解](#mvvm-架构详解)
2. [洋葱开发法深度解析](#洋葱开发法深度解析)
3. [架构对比分析](#架构对比分析)
4. [实战架构设计](#实战架构设计)
5. [最佳实践指南](#最佳实践指南)
6. [常见问题解答](#常见问题解答)

---

## MVVM 架构详解

### 🏗️ MVVM 架构基础

MVVM (Model-View-ViewModel) 是一种软件架构模式，由微软在 2005 年提出。它是 MVC (Model-View-Controller) 模式的演进版本，特别适用于现代 GUI 应用开发。

#### 核心组件

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│      Model      │    │   ViewModel     │    │      View       │
│                 │    │                 │    │                 │
│ • 数据模型       │────│ • 业务逻辑        │────│ • UI 表现        │
│ • 数据操作       │    │ • 数据处理        │    │ • 用户交互       │
│ • 网络请求       │    │ • 状态管理        │    │ • 界面更新       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 📊 组件职责详解

#### 1. Model（数据模型）

负责数据的存储、获取和操作。

```swift
import Foundation

//User.swift - 数据模型
@objc class User: NSObject {
    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var avatarURL: String? = nil

    func User(id: Int, name: String, email: String, avatarURL: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
    }

    // 数据验证
    var isValid: Bool {
        return !name.isEmpty && !email.isEmpty && email.contains("@")
    }
}

// 网络响应模型
class UserResponse: NSObject {
    var users: [User] = []
    var totalCount: Int = 0
    var page: Int = 0

    // 使用初始化器来初始化属性
    init(users: [User], totalCount: Int, page: Int) {
        self.users = users
        self.totalCount = totalCount
        self.page = page
    }
}
```

#### 2. ViewModel（视图模型）

处理业务逻辑、数据转换和状态管理。

```swift
// UserListViewModel.swift
import Foundation
import Aquarius

class UserListViewModel: AViewModel {

    // MARK: - Properties
    @objc dynamic var users: [User] = []
    @objc dynamic var isLoading: Bool = false
    @objc dynamic var errorMessage: String = ""
    @objc dynamic var searchQuery: String = ""

    private let userService: UserServiceProtocol

    // MARK: - Initialization
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        super.init()
    }

    // MARK: - Data Binding
    override func a_Bind() {
        super.a_Bind()

        bindsTo(dict: [
            "users" : #keyPath(users),
            "loading" : #keyPath(isLoading),
            "error" : #keyPath(errorMessage),
            "searchQuery" : #keyPath(searchQuery)
        ])
    }

    // MARK: - Business Logic
    func loadUsers() {
        isLoading = true
        errorMessage = ""

        userService.fetchUsers { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {
            case .success(let response):
                self.users = response.users
                self.printInfo("成功加载 \(response.users.count) 个用户")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.printError("加载用户失败: \(error)")
            }
        }
    }

    func searchUsers(query: String) {
        searchQuery = query

        if query.isEmpty {
            loadUsers()
        } else {
            let filteredUsers = users.filter { user in
                user.name.localizedCaseInsensitiveContains(query) ||
                user.email.localizedCaseInsensitiveContains(query)
            }
            users = filteredUsers
        }
    }

    func deleteUser(at index: Int) {
        guard index >= 0 && index < users.count else { return }

        let user = users[index]
        userService.deleteUser(id: user.id) { [weak self] result in
            switch result {
            case .success:
                self?.users.remove(at: index)
                self?.printInfo("删除用户: \(user.name)")
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.printError("删除用户失败: \(error)")
            }
        }
    }
}
```

#### 3. View（视图）

负责 UI 展示和用户交互。

```swift
// UserListView.swift
import UIKit
import Foundation
import Aquarius

class UserListView: AView {

    // MARK: - UI Components
    private let searchBar: UISearchBar = A.ui.searchBar
    private let tableView: UITableView = A.ui.plainTableView
    private let loadingIndicator: UIActivityIndicatorView = A.ui.activityIndicatorView
    private let errorLabel: UILabel = A.ui.label

    // MARK: - Data Binding
    @objc dynamic private var binding_users: [User] = []
    @objc dynamic private var binding_isLoading: Bool = false
    @objc dynamic private var binding_errorMessage: String = ""
    @objc dynamic private var binding_searchQuery: String = ""

    // MARK: - Lifecycle
    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            searchBar,
            tableView,
            loadingIndicator,
            errorLabel
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        // 配置搜索栏
        searchBar.placeholder = "搜索用户..."
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no

        // 配置表格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.separatorStyle = .singleLine

        // 配置错误标签
        errorLabel.textAlignment = .center
        errorLabel.textColor = .red
        errorLabel.isHidden = true

        // 配置加载指示器
        loadingIndicator.style = .large
        loadingIndicator.isHidden = true
    }

    override func a_Layout() {
        super.a_Layout()

        searchBar.size(sizes: [screenWidth(), 44])
        searchBar.point(points: [0, safeAreaHeaderHeight()])

        tableView.size(
            width: screenWidth(),
            height: screenHeight() - searchBar.bottom() - safeAreaFooterHeight()
        )
        tableView.point(points: [0, searchBar.bottom()])

        loadingIndicator.size(sizes: [50, 50])
        loadingIndicator.point(points: [
            screenWidth() / 2 - 25,
            screenHeight() / 2 - 25
        ])

        errorLabel.size(sizes: [screenWidth() - 40, 40])
        errorLabel.point(points: [20, screenHeight() / 2 - 20])
    }

    override func a_Delegate() {
        super.a_Delegate()

        Manage_SetDelegate(
            targetObject: searchBar,
            delegateName: AProtocol.delegate,
            object: self
        )

        Manage_SetDelegate(
            targetObject: tableView,
            delegateNames: AProtocol.delegateAndDataSource,
            object: self
        )
    }

    override func a_Bind() {
        super.a_Bind()

        bindsFrom(dict: [
            "users" : #keyPath(binding_users),
            "loading" : #keyPath(binding_isLoading),
            "error" : #keyPath(binding_errorMessage),
            "searchQuery" : #keyPath(binding_searchQuery)
        ])

        // 使用Aquarius框架数据绑定 - 无需混合其他机制
        bindsTo(dict: [
            "usersBind" : #keyPath(binding_users),
            "loadingBind" : #keyPath(binding_isLoading),
            "errorBind" : #keyPath(binding_errorMessage)
        ])
    }
}

// MARK: - UITableViewDataSource
extension UserListView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return binding_users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = binding_users[indexPath.row]

        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 发送删除事件
            Manage_PostNotification("DeleteUser", object: ["index": indexPath.row])
        }
    }
}

// MARK: - UITableViewDelegate
extension UserListView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // 发送选中事件
        Manage_PostNotification("SelectUser", object: ["index": indexPath.row])
    }
}

// MARK: - UISearchBarDelegate
extension UserListView: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        binding_searchQuery = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        binding_searchQuery = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
}
```

#### 4. ViewController（协调器）

协调 View 和 ViewModel 之间的交互。

```swift
// UserListViewController.swift
import UIKit
import Aquarius

class UserListViewController: AViewController {

    private let viewModel: CounterViewModel = CounterViewModel()
        private let userListView: CounterView = CounterView()

        override func a_Navigation() {
            super.a_Navigation()

            navigation_Title = "用户列表"
            navigation_RightBarButtonText = "刷新"
            navigation_RigthBarButtonSelector {
                self.viewModel.loadUsers()
            }
        }

        override func a_UI() {
            super.a_UI()

            addRootView(view: userListView)
        }

        override func a_Other() {
            super.a_Other()

            viewModel.loadUsers()
        }

        private func showUserDetail(for index: Int) {
            let userDetailVC = UserDetailViewController()
            userDetailVC.userIndex = index
            navigationController?.pushViewController(userDetailVC, animated: true)
        }
}
```

### 🔄 数据流向

MVVM 架构中的数据流向：

```
View ───→ ViewModel ───→ Model
 ↑                           ↓
 └── ViewModel ←── Model ←──┘
```

#### 1. 用户操作流向

```
User Input → View → ViewModel → Model → 数据更新
```

#### 2. 数据更新流向

```
Model Data Changed → ViewModel → View → UI Updated
```

#### 3. 双向绑定

```
View <-> ViewModel <-> Model
```

### 💪 MVVM 的优势

1. **职责分离**
   
   - View 专注 UI 展示
   - ViewModel 专注业务逻辑
   - Model 专注数据操作

2. **可测试性**
   
   - ViewModel 可独立测试
   - 无需依赖 UI 框架

3. **可维护性**
   
   - 代码结构清晰
   - 修改影响范围可控

4. **可重用性**
   
   - ViewModel 可被多个 View 重用
   - View 可适配不同 ViewModel

---

## 洋葱开发法深度解析

### 🧅 洋葱概念

洋葱开发法是一种代码组织方法，它将复杂的功能按照职责进行分层，像洋葱一样一层一层剥开，每一层都有明确的职责。

### 📊 分层结构

```swift
class ExampleViewController: AViewController {

    // ========== 第1层：初始化层 ==========

    /// 页面预览（最内层）
    override func a_Preview() {
        super.a_Preview()
        // 页面创建前的准备工作
        // 例如：权限检查、网络检查、环境配置
        A.log.info("a_Preview - 页面预览")

        if !NetworkStatusManager.shared.isNetworkAvailable() {
            showNetworkError()
            return
        }
    }

    /// 页面开始
    override func a_Begin() {
        super.a_Begin()
        // 页面开始时的初始化工作
        // 例如：设置埋点、初始化变量
        A.log.info("a_Begin - 页面开始")

        // 设置分析埋点
        setupAnalytics()

        // 初始化变量
        initializeVariables()
    }

    // ========== 第2层：配置层 ==========

    /// 导航条配置
    override func a_Navigation() {
        super.a_Navigation()
        // 配置导航条相关设置
        A.log.info("a_Navigation - 导航条配置")

        navigation_Title = "页面标题"
        navigation_RightBarButtonText = "设置"
        navigation_RigthBarButtonSelector { [weak self] in
            self?.showSettings()
        }
    }

    /// 委托设置
    override func a_Delegate() {
        super.a_Delegate()
        // 设置各种委托
        A.log.info("a_Delegate - 委托设置")

        viewModel.Manage_SetDelegate(
            targetObject: tableView,
            delegateNames: AProtocol.delegateAndDataSource,
            object: self
        )
    }

    /// 主题更新
    override func updateThemeStyle() {
        super.updateThemeStyle()
        // 主题切换时的处理
        A.log.info("updateThemeStyle - 主题更新")

        view.backgroundColor = AppTheme.shared.backgroundColor
        navigationController?.navigationBar.barTintColor = AppTheme.shared.navigationBarColor
    }

    /// 通知设置
    override func a_Notification() {
        super.a_Notification()
        // 注册通知
        A.log.info("a_Notification - 通知设置")

        Manage_SetNotification("DataUpdated")
        Manage_SetNotification(A.kApplicationWillEnterForeground)
    }

    /// 数据绑定
    override func a_Bind() {
        super.a_Bind()
        // 设置数据绑定
        A.log.info("a_Bind - 数据绑定")

        viewModel.bindsTo(dict: [
            "data" : #keyPath(viewModel.dataArray),
            "loading" : #keyPath(viewModel.isLoading)
        ])
    }

    /// 事件设置
    override func a_Event() {
        super.a_Event()
        // 设置各种事件监听
        A.log.info("a_Event - 事件设置")

        setupButtonEvents()
        setupGestureRecognizers()
    }

    // ========== 第3层：UI层 ==========

    /// UI 组件创建
    override func a_UI() {
        super.a_UI()
        // 创建 UI 组件
        A.log.info("a_UI - UI组件创建")

        createAndAddSubviews()
    }

    /// UI 配置
    override func a_UIConfig() {
        super.a_UIConfig()
        // 配置 UI 组件属性
        A.log.info("a_UIConfig - UI配置")

        configureUIElements()
    }

    /// UI 布局
    override func a_Layout() {
        super.a_Layout()
        // 设置 UI 布局
        A.log.info("a_Layout - UI布局")

        setupLayoutConstraints()
    }

    // ========== 第4层：业务层 ==========

    /// 其他业务逻辑
    override func a_Other() {
        super.a_Other()
        // 其他业务相关设置
        A.log.info("a_Other - 其他业务逻辑")

        loadInitialData()
        setupObservers()
    }

    /// 结尾处理
    override func a_End() {
        super.a_End()
        // 页面设置的最后收尾工作
        A.log.info("a_End - 结尾处理")

        finalizeSetup()
        triggerInitialLoad()
    }

    /// 测试代码（仅 Debug 模式，发布后此代码不执行）
    override func a_Test() {
        super.a_Test()
        // 仅在调试模式下执行的测试代码
        A.log.info("a_Test - 测试代码")

        validateLayout()
        simulateUserActions()
    }

    // ========== 第5层：清理层 ==========

    /// 清理资源（最外层）
    override func a_Clear() {
        super.a_Clear()
        // 页面销毁时的清理工作
        A.log.info("a_Clear - 清理资源")

        removeObservers()
        cleanupResources()
        cancelNetworkRequests()
    }
}
```

### 🎯 层次说明

#### 1. 初始化层（Initialization Layer）

负责页面创建前的准备工作。

```swift
override func a_Preview() {
    super.a_Preview()
    // 检查必要条件
    if !checkPrerequisites() {
        return
    }

    // 环境检查
    checkEnvironment()
}

override func a_Begin() {
    super.a_Begin()
    // 初始化工作
    initializeComponents()
    setupBasicConfiguration()
}
```

#### 2. 配置层（Configuration Layer）

负责各种配置和设置。

```swift
override func a_Navigation() {
    super.a_Navigation()

    configureNavigationBar()
    setupNavigationButtons()
}

override func a_Delegate() {
    super.a_Delegate()

    setupTableViewDelegates()
    setupScrollViewDelegate()
}

override func a_Notification() {
    super.a_Notification()

    registerNotifications()
}

override func a_Bind() {
    super.a_Bind()

    setupDataBinding()
}

override func a_Observe() {
    super.a_Observe()

    setupPropertyObservers()
}
```

#### 3. UI 层（UI Layer）

负责 UI 相关的操作。

```swift
override func a_UI() {
    super.a_UI()

    createUIElements()
}

override func a_UIConfig() {
    super.a_UIConfig()

    configureUIElements()
}

override func a_Layout() {
    super.a_Layout()

    setupLayoutConstraints()
}
```

#### 4. 业务层（Business Layer）

处理业务逻辑。

```swift
override func a_Other() {
    super.a_Other()

    performBusinessLogic()
}

override func a_End() {
    super.a_End()

    finalizeBusinessSetup()
}
```

#### 5. 清理层（Cleanup Layer）

负责资源清理。

```swift
override func a_Clear() {
    super.a_Clear()

    cleanupResources()
}
```

### 🚀 执行顺序

Aquarius 框架的执行顺序：

```
1. a_Preview()      → 页面预览
2. a_Begin()        → 开始初始化
3. a_Navigation()   → 导航配置
4. a_Delegate()     → 委托设置
5. updateThemeStyle() → 主题更新
6. a_Notification() → 通知设置
7. a_Bind()         → 数据绑定
8. a_Observe()      → 观察者设置
9. a_Event()        → 事件设置

10. viewDidLoad()    → 视图加载
    ↓
11. a_UI()          → UI 创建
12. a_UIConfig()    → UI 配置
13. a_Layout()      → UI 布局
14. a_Other()       → 其他业务
15. a_End()         → 结尾处理
16. a_Test()        → 测试代码（Debug 模式）

17. a_Clear()       → 清理资源（dealloc 时）
```

### 💡 最佳实践

#### 1. 严格按层次组织代码

```swift
// ❌ 错误示例：混合层次
class BadExample: AViewController {
    override func a_UI() {
        super.a_UI()

        // 不应该在 a_UI 中设置通知
        Manage_SetNotification("DataUpdated")  // ❌ 应该在 a_Notification 中

        // 不应该在 a_UI 中设置数据绑定
        viewModel.bindsTo(dict: [...])  // ❌ 应该在 a_Bind 中
    }
}

// ✅ 正确示例：层次分明
class GoodExample: AViewController {
    override func a_Notification() {
        super.a_Notification()

        Manage_SetNotification("DataUpdated")  // ✅ 正确的层次
    }

    override func a_Bind() {
        super.a_Bind()

        viewModel.bindsTo(dict: [...])  // ✅ 正确的层次
    }

    override func a_UI() {
        super.a_UI()
        // ✅ 只创建 UI 组件
        addSubviews(views: [myView])
    }
}
```

#### 2. 使用适当的层次

```swift
// ✅ 使用 a_Preview 进行预检查
override func a_Preview() {
    super.a_Preview()

    // 检查网络连接
    guard NetworkStatusManager.shared.isNetworkAvailable() else {
        showNetworkError()
        return
    }

    // 检查用户权限
    guard checkUserPermissions() else {
        showPermissionError()
        return
    }
}

// ✅ 使用 a_Begin 进行初始化
override func a_Begin() {
    super.a_Begin()

    // 设置埋点
    setupAnalytics()

    // 初始化配置
    initializeConfiguration()
}
```

#### 3. 错误处理策略

```swift
// ✅ 在适当层次处理错误
override func a_Preview() {
    super.a_Preview()

    // 如果关键条件不满足，直接返回
    if !essentialCondition {
        return  // 不继续执行后续初始化
    }
}

override func a_End() {
    super.a_End()

    // 如果是可选的设置，可以在这里处理错误
    doOptionalSetup()

    // 但是仍要保证基本功能可用
    ensureBasicFunctionality()
}
```

---

## 架构对比分析

### 📊 MVC vs MVVM vs 洋葱架构

| 特性        | 传统 MVC | MVVM | MVVM + 洋葱 |
| --------- | ------ | ---- | --------- |
| **代码量**   | 少      | 中等   | 稍多        |
| **学习成本**  | 低      | 中等   | 中等        |
| **可维护性**  | 低      | 中等   | 高         |
| **测试友好性** | 低      | 高    | 高         |
| **团队协作**  | 困难     | 中等   | 容易        |
| **代码复用**  | 困难     | 中等   | 高         |
| **复杂度**   | 低      | 中等   | 中等        |
| **文件数量**  | 少      | 中等   | 中等        |

### 🔍 详细对比

#### 传统 MVC 模式

```swift
// 传统 MVC - 所有逻辑在一个文件中
class TraditionalViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTable: UITableView!

    var dataArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // 导航设置
        navigationItem.title = "标题"

        // UI 配置
        titleLabel.text = "页面标题"
        titleLabel.font = UIFont.systemFont(ofSize: 18)

        // 委托设置
        contentTable.delegate = self
        contentTable.dataSource = self

        // 通知设置
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataUpdated),
            name: NSNotification.Name("DataUpdated"),
            object: nil
        )

        // 数据加载
        loadData()
    }

    @objc func dataUpdated() {
        loadData()
    }

    func loadData() {
        // 网络请求逻辑
        dataArray = ["数据1", "数据2", "数据3"]
        contentTable.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TraditionalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
}
```

#### MVVM + 洋葱架构

```swift
// ViewModel - 专注业务逻辑
class ModernViewModel: AViewModel {
    @objc dynamic var dataArray: [String] = []

    override func a_Bind() {
        super.a_Bind()

        bindsTo(dict: [
            "dataArray" : #keyPath(dataArray)
        ])
    }

    override func a_Other() {
        super.a_Other()

        loadData()
    }

    private func loadData() {
        // 业务逻辑
        dataArray = ["数据1", "数据2", "数据3"]
    }
}

// View - 专注 UI
class ModernView: AView {
    private let titleLabel: UILabel = A.ui.label
    private let contentTable: UITableView = A.ui.plainTableView

    override func a_UI() {
        super.a_UI()

        addSubviews(views: [titleLabel, contentTable])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        titleLabel.font = 16.0.toFont
    }

    override func a_Layout() {
        super.a_Layout()

        titleLabel.size(sizes: [screenWidth(), 44])
        contentTable.size(
            width: screenWidth(),
            height: screenHeight() - 44
        )
    }

    override func a_Delegate() {
        super.a_Delegate()

        contentTable.dataSource = self
    }
}

extension ModernView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
}

// ViewController - 协调器
class ModernViewController: AViewController {
    private let viewModel: ModernViewModel = ModernViewModel()
    private let modernView: ModernView = ModernView()

    override func a_Navigation() {
        super.a_Navigation()

        navigation_Title = "标题"
    }

    override func a_UI() {
        super.a_UI()

        addRootView(view: modernView)
    }

    override func a_Other() {
        super.a_Other()

        // 直接调用ViewModel方法加载数据
        viewModel.loadData()
    }
}
```

### 📈 优势分析

#### 1. 职责分离优势

| 方面       | 传统 MVC   | MVVM + 洋葱         |
| -------- | -------- | ----------------- |
| **可读性**  | 差：逻辑混杂   | 好：层次清晰            |
| **可维护性** | 差：牵一发动全身 | 好：局部修改影响小         |
| **可测试性** | 差：UI 依赖强 | 好：ViewModel 可独立测试 |
| **团队协作** | 困难：代码冲突多 | 容易：分工明确           |

#### 2. 代码质量对比

```swift
// 传统 MVC - 问题
class BadViewController: UIViewController {
    func handleButtonTap() {
        // 混合了多种职责
        // 1. UI 更新
        button.isEnabled = false

        // 2. 业务逻辑
        dataManager.updateData()

        // 3. 界面跳转
        let nextVC = NextViewController()
        navigationController?.pushViewController(nextVC, animated: true)

        // 4. 通知发送
        NotificationCenter.default.post(name: NSNotification.Name("DataUpdated"), object: nil)

        // 5. 数据持久化
        UserDefaults.standard.set(newValue, forKey: "lastUpdate")
    }
}

// MVVM + 洋葱 - 职责分离
class GoodViewModel: AViewModel {
    @objc dynamic var isUpdating: Bool = false

    func updateData() {
        isUpdating = true

        dataService.updateData { [weak self] result in
            self?.isUpdating = false

            switch result {
            case .success:
                self?.Manage_PostNotification("DataUpdated")
                self?.persistData()
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }

    private func persistData() {
        dataStorage.saveLastUpdate(Date())
    }

    private func handleError(_ error: Error) {
        printError("更新失败: \(error)")
        // 错误处理逻辑
    }
}

class GoodViewController: AViewController {
    private let viewModel: GoodViewModel = GoodViewModel()

    override func a_Event() {
        super.a_Event()

        actionButton.addTouchUpInsideBlock { [weak self] _ in
            self?.viewModel.updateData()
        }
    }
}
```

---

## 实战架构设计

### 🎯 项目架构规划

让我们设计一个完整的社交应用架构：

```
SocialApp/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppTheme.swift              # 全局主题
├── Core/
│   ├── Models/                     # 数据模型
│   │   ├── User.swift
│   │   ├── Post.swift
│   │   └── Comment.swift
│   ├── Services/                   # 服务层
│   │   ├── NetworkService.swift
│   │   ├── StorageService.swift
│   │   └── AuthService.swift
│   └── Utils/                      # 工具类
│       ├── ImageLoader.swift
│       └── DateFormatter.swift
├── Features/
│   ├── Authentication/            # 认证模块
│   │   ├── Login/
│   │   │   ├── LoginViewController.swift
│   │   │   ├── LoginView.swift
│   │   │   └── LoginViewModel.swift
│   │   └── Register/
│   ├── Profile/                   # 用户资料模块
│   │   ├── ProfileViewController.swift
│   │   ├── ProfileView.swift
│   │   └── ProfileViewModel.swift
│   ├── Feed/                      # 动态流模块
│   │   ├── FeedViewController.swift
│   │   ├── FeedView.swift
│   │   └── FeedViewModel.swift
│   └── Profile/                   # 个人资料模块
├── Shared/
│   ├── Components/                # 共享组件
│   │   ├── PostCell.swift
│   │   ├── ProfileHeaderView.swift
│   │   └── LoadingView.swift
│   └── Extensions/                # 共享扩展
└── Resources/
    ├── Assets.xcassets
    └── Localizable.strings
```

### 📱 认证模块实现

#### 1. 登录服务

```swift
// AuthService.swift
protocol AuthServiceProtocol {
    func login(email: String, password: String) -> Result<User, Error>
    func logout() -> Result<Void, Error>
    func isLoggedIn() -> Bool
    func getCurrentUser() -> User?
}

class AuthService: AuthServiceProtocol {
    private let networkService: NetworkService
    private let storageService: StorageService

    init(networkService: NetworkService = NetworkService(),
         storageService: StorageService = StorageService()) {
        self.networkService = networkService
        self.storageService = storageService
    }

    func login(email: String, password: String) -> Result<User, Error> {
        // 网络请求登录
        let result = networkService.request("/auth/login",
                                          method: .POST,
                                          parameters: ["email": email, "password": password])

        switch result {
        case .success(let data):
            guard let user = parseUser(from: data) else {
                return .failure(AuthError.invalidResponse)
            }

            // 保存用户信息
            storageService.save(user, forKey: "currentUser")

            return .success(user)

        case .failure(let error):
            return .failure(error)
        }
    }

    func logout() -> Result<Void, Error> {
        storageService.removeObject(forKey: "currentUser")
        return .success(())
    }

    func isLoggedIn() -> Bool {
        return getCurrentUser() != nil
    }

    func getCurrentUser() -> User? {
        return storageService.load(User.self, forKey: "currentUser")
    }

    private func parseUser(from data: Data) -> User? {
        // 解析用户数据的逻辑
        return try? JSONDecoder().decode(User.self, from: data)
    }
}

enum AuthError: Error {
    case invalidEmail
    case invalidPassword
    case networkError
    case invalidResponse
    case userNotFound
}
```

#### 2. 登录 ViewModel

```swift
// LoginViewModel.swift
import Foundation

import Aquarius

class LoginViewModel: AViewModel {

    // MARK: - Properties
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var isLoading: Bool = false
    @objc dynamic var errorMessage: String = ""
    @objc dynamic var isLoggedIn: Bool = false

    private let authService: AuthServiceProtocol

    // MARK: - Initialization
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        super.init()
    }

    // MARK: - Data Binding
    override func a_Bind() {
        super.a_Bind()
        bindsTo(dict: [
            "email" : #keyPath(email),
            "password" : #keyPath(password),
            "loading" : #keyPath(isLoading),
            "error" : #keyPath(errorMessage),
            "loggedIn" : #keyPath(isLoggedIn)
        ])

        bindsFrom(dict: [
            "emailInput" : #keyPath(email),
            "passwordInput" : #keyPath(password)
        ])
    }

    // MARK: - Business Logic
    func validateEmail() -> Bool {
        guard !email.isEmpty else {
            errorMessage = "请输入邮箱地址"
            return false
        }

        guard email.contains("@") else {
            errorMessage = "邮箱格式不正确"
            return false
        }

        errorMessage = ""
        return true
    }

    func validatePassword() -> Bool {
        guard !password.isEmpty else {
            errorMessage = "请输入密码"
            return false
        }

        guard password.count >= 6 else {
            errorMessage = "密码长度不能少于6位"
            return false
        }

        errorMessage = ""
        return true
    }

    func login() {
        // 验证输入
        guard validateEmail() && validatePassword() else {
            return
        }

        // 开始登录
        isLoading = true
        errorMessage = ""

        let result = authService.login(email: email, password: password)

        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false

            switch result {
            case .success(let user):
                self?.isLoggedIn = true
                self?.printInfo("登录成功: \(user.name)")

                // 发送登录成功通知
                self?.Manage_PostNotification("LoginSuccess", object: ["user": user])

            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.printError("登录失败: \(error)")
            }
        }
    }

    func logout() {
        let result = authService.logout()

        switch result {
        case .success:
            isLoggedIn = false
            email = ""
            password = ""
            printInfo("登出成功")

        case .failure(let error):
            errorMessage = error.localizedDescription
            printError("登出失败: \(error)")
        }
    }

    override func a_Other() {
        super.a_Other()

        // 检查是否已登录
        isLoggedIn = authService.isLoggedIn()

        if isLoggedIn {
            // 如果已登录，自动发送登录成功通知
            if let user = authService.getCurrentUser() {
                Manage_PostNotification("LoginSuccess", object: ["user": user])
            }
        }
    }
}
```

#### 3. 登录 View

```swift
// LoginView.swift
import UIKit
import Foundation

import Aquarius

class LoginView: AView {

    // MARK: - UI Components
    private let logoImageView: UIImageView = A.ui.imageView
    private let titleLabel: UILabel = A.ui.label
    private let emailTextField: UITextField = A.ui.textField
    private let passwordTextField: UITextField = A.ui.textField
    private let loginButton: UIButton = A.ui.button
    private let registerButton: UIButton = A.ui.button
    private let loadingIndicator: UIActivityIndicatorView = A.ui.activityIndicatorView
    private let errorLabel: UILabel = A.ui.label

    // MARK: - Data Binding
    @objc dynamic private var binding_email: String = ""
    @objc dynamic private var binding_password: String = ""
    @objc dynamic private var binding_isLoading: Bool = false
    @objc dynamic private var binding_errorMessage: String = ""
    @objc dynamic private var binding_isLoggedIn: Bool = false

    // MARK: - Lifecycle
    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            logoImageView,
            titleLabel,
            emailTextField,
            passwordTextField,
            loginButton,
            registerButton,
            loadingIndicator,
            errorLabel
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        // Logo
        logoImageView.image = "your image name".toNamedImage()
        logoImageView.contentMode = .scaleAspectFit

        // 标题
        titleLabel.text = "欢迎回来"
        titleLabel.font = 16.0.toFont
        titleLabel.textAlignment = .center

        // 邮箱输入框
        emailTextField.placeholder = "邮箱地址"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no

        // 密码输入框
        passwordTextField.placeholder = "密码"
        passwordTextField.isSecureTextEntry = true

        // 登录按钮
        loginButton.setTitle("登录", for: .normal)
        loginButton.layerCornerRadius(8)

        // 注册按钮
        registerButton.setTitle("没有账号？立即注册", for: .normal)

        // 错误标签
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        // 加载指示器
        loadingIndicator.style = .large
        loadingIndicator.isHidden = true
    }

    override func updateThemeStyle() {
        super.updateThemeStyle()

        loginButton.backgroundColor = AppTheme.shared.primaryColor
        registerButton.setTitleColor(AppTheme.shared.secondaryColor, for: .normal)
        registerButton.backgroundColor = .clear
        errorLabel.textColor = .red
    }

    override func a_Layout() {
        super.a_Layout()

        let screenWidth = self.screenWidth()
        let screenHeight = self.screenHeight()

        // Logo
        logoImageView.size(sizes: [80, 80])
        logoImageView.point(points: [screenWidth / 2 - 40, 100])

        // 标题
        titleLabel.size(sizes: [screenWidth - 40, 40])
        titleLabel.point(points: [20, logoImageView.bottom() + 30])

        // 邮箱输入框
        emailTextField.size(sizes: [screenWidth - 40, 44])
        emailTextField.point(points: [20, titleLabel.bottom() + 30])

        // 密码输入框
        passwordTextField.size(sizes: [screenWidth - 40, 44])
        passwordTextField.point(points: [20, emailTextField.bottom() + 15])

        // 登录按钮
        loginButton.size(sizes: [screenWidth - 40, 44])
        loginButton.point(points: [20, passwordTextField.bottom() + 30])

        // 注册按钮
        registerButton.size(sizes: [screenWidth - 40, 30])
        registerButton.point(points: [20, loginButton.bottom() + 15])

        // 加载指示器
        loadingIndicator.size(sizes: [50, 50])
        loadingIndicator.point(points: [
            screenWidth / 2 - 25,
            screenHeight / 2 - 25
        ])

        // 错误标签
        errorLabel.size(sizes: [screenWidth - 40, 60])
        errorLabel.point(points: [20, registerButton.bottom() + 20])
    }

    override func a_Bind() {
        super.a_Bind()

        bindsFrom(dict: [
            "email" : #keyPath(binding_email),
            "password" : #keyPath(binding_password),
            "loading" : #keyPath(binding_isLoading),
            "error" : #keyPath(binding_errorMessage),
            "loggedIn" : #keyPath(binding_isLoggedIn)
        ])
    }

    override func a_Event() {
        super.a_Event()

        // 邮箱输入事件
        emailTextField.addEventBlock(.editingChanged) { [weak self] control in
            if let textField = control as? UITextField {
                self?.binding_email = textField.text ?? ""
            }
        }

        // 密码输入事件
        passwordTextField.addEventBlock(.editingChanged) { [weak self] control in
            if let textField = control as? UITextField {
                self?.binding_password = textField.text ?? ""
            }
        }

        // 登录按钮点击事件
        loginButton.addTouchUpInsideBlock { [weak self] _ in
            self?.binding_email = self?.emailTextField.text ?? ""
            self?.binding_password = self?.passwordTextField.text ?? ""
            self?.Manage_PostNotification("LoginButtonTapped")
        }

        // 注册按钮点击事件
        registerButton.addTouchUpInsideBlock { [weak self] _ in
            self?.Manage_PostNotification("RegisterButtonTapped")
        }
    }

    // ✅ 绑定后的属性专注于数据更新，无需重复观察
    // 绑定负责数据同步，通知负责事件处理

    override func a_Delegate() {
        super.a_Delegate()

        // 设置文本字段代理
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    // MARK: - Private Methods
    private func updateLoadingState(_ isLoading: Bool) {
        loginButton.isEnabled = !isLoading
        emailTextField.isEnabled = !isLoading
        passwordTextField.isEnabled = !isLoading
        registerButton.isEnabled = !isLoading

        loadingIndicator.isHidden = !isLoading

        if isLoading {
            loadingIndicator.startAnimating()
            loginButton.setTitle("登录中...", for: .normal)
        } else {
            loadingIndicator.stopAnimating()
            loginButton.setTitle("登录", for: .normal)
        }
    }

    private func showSuccessMessage() {
        let successLabel = UILabel()
        successLabel.text = "登录成功！"
        successLabel.textColor = .green
        successLabel.textAlignment = .center
        successLabel.font = 16.0.toFont

        addSubview(successLabel)
        successLabel.size(sizes: [screenWidth() - 40, 30])
        successLabel.point(points: [20, errorLabel.bottom() + 10])

        // 动画显示
        successLabel.alpha = 0
        UIView.animate(withDuration: 0.3) {
            successLabel.alpha = 1
        }

        // 2秒后移除
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.3, animations: {
                successLabel.alpha = 0
            }, completion: { _ in
                successLabel.removeFromSuperview()
            })
        }
    }

    private func showErrorMessage(_ message: String) {
        errorLabel.shake() // 假设有shake扩展方法
    }
}

// MARK: - UITextFieldDelegate
extension LoginView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            // 触发登录
            binding_email = emailTextField.text ?? ""
            binding_password = passwordTextField.text ?? ""
            Manage_PostNotification("LoginButtonTapped")
        }

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            binding_email = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        } else if textField == passwordTextField {
            binding_password = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        }

        return true
    }
}
```

#### 4. 登录 ViewController

```swift
// LoginViewController.swift
import UIKit
import Foundation

import Aquarius

class LoginViewController: AViewController {

    private let viewModel: LoginViewModel = LoginViewModel()
    private let loginView: LoginView = LoginView()

    override func a_Navigation() {
        super.a_Navigation()

        hidesBottomBarWhenPushed = true // 登录页面通常隐藏导航栏
    }

    override func a_Observe() {
        super.a_Observe()

        // 使用不同的属性进行观察，避免重复绑定同一变量
        viewModel.kvo = viewModel.observe(\.isLoggedIn, options: .new) { [weak self] _, change in
            let isLoggedIn = change.newValue ?? false
            if isLoggedIn {
                self?.handleLoginSuccess()
            }
        }
    }

    override func a_Notification() {
        super.a_Notification()

        // 用于UI事件的通知机制，与数据绑定分工明确
        // 框架原生支持，页面销毁后，自动删除通知监听，避免内存泄漏
        Manage_SetNotifications([
            "LoginButtonTapped",
            "RegisterButtonTapped",
            "LoginSuccess"
        ])
    }

    override func a_UI() {
        super.a_UI()
        addRootView(view: loginView)
    }

    override func a_Other() {
        super.a_Other()

        // 移除键盘手势
        setupKeyboardHandling()
    }

    override func ANotificationReceive(notification: Notification) {
        super.ANotificationReceive(notification: notification)

        switch notification.name.rawValue {
        case "LoginButtonTapped":
            viewModel.login()

        case "RegisterButtonTapped":
            showRegisterScreen()

        case "LoginSuccess":
            if let userInfo = notification.object as? [String: Any],
               let user = userInfo["user"] as? User {
                handleLoginSuccess(user)
            } else {
                handleLoginSuccess()
            }

        default:
            break
        }
    }

    private func setupKeyboardHandling() {
        // 监听键盘显示/隐藏
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleKeyboardShow(notification)
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleKeyboardHide(notification)
        }
    }

    private func handleKeyboardShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height

            // 调整视图布局，避免键盘遮挡
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight / 3
            }
        }
    }

    private func handleKeyboardHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }

    private func handleLoginSuccess(_ user: User? = nil) {
        printInfo("登录成功，跳转到主页面")

        // 跳转到主应用
        let mainTabBarController = MainTabBarController()

        // 设置根视图控制器
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = mainTabBarController
            window.makeKeyAndVisible()
        }
    }

    private func showRegisterScreen() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
```

### 🏗️ Feed 流模块架构

让我们继续实现动态流模块，展示更复杂的业务场景：

#### 1. Feed ViewModel

```swift
// FeedViewModel.swift
import Aquarius

class FeedViewModel: AViewModel {

    // MARK: - Properties
    @objc dynamic var posts: [Any] = []
    @objc dynamic var isLoading: Bool = false
    @objc dynamic var isRefreshing: Bool = false
    @objc dynamic var errorMessage: String = ""
    @objc dynamic var currentPage: Int = 1
    @objc dynamic var hasMoreData: Bool = true

    private let postService: PostServiceProtocol
    private let imageLoader: ImageLoader

    // MARK: - Initialization
    init(postService: PostServiceProtocol = PostService(),
         imageLoader: ImageLoader = ImageLoader.shared) {
        self.postService = postService
        self.imageLoader = imageLoader
        super.init()
    }

    // MARK: - Data Binding
    override func a_Bind() {
        super.a_Bind()

        bindsTo(dict: [
            "posts" : #keyPath(posts),
            "loading" : #keyPath(isLoading),
            "refreshing" : #keyPath(isRefreshing),
            "error" : #keyPath(errorMessage),
            "page" : #keyPath(currentPage),
            "hasMore" : #keyPath(hasMoreData)
        ])
    }

    // MARK: - Business Logic
    func loadPosts(refresh: Bool = false) {
        if refresh {
            isRefreshing = true
            currentPage = 1
        } else {
            isLoading = true
        }

        errorMessage = ""

        postService.fetchPosts(page: currentPage, perPage: 20) { [weak self] result in
            DispatchQueue.main.async {
                if refresh {
                    self?.isRefreshing = false
                } else {
                    self?.isLoading = false
                }

                switch result {
                case .success(let response):
                    self.handlePostsResponse(response, refresh: refresh)
                    self.printInfo("成功加载 \(response.posts.count) 条动态")

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.printError("加载动态失败: \(error)")
                }
            }
        }
    }

    func loadMorePosts() {
        guard hasMoreData && !isLoading else { return }

        currentPage += 1
        loadPosts()
    }

    func refreshPosts() {
        loadPosts(refresh: true)
    }

    func likePost(at index: Int) {
        guard index >= 0 && index < posts.count else { return }

        let post = posts[index]
        let newLikeCount = post.liked ? post.likeCount - 1 : post.likeCount + 1
        let newIsLiked = !post.liked

        // 乐观更新
        var updatedPost = post
        updatedPost.likeCount = newLikeCount
        updatedPost.liked = newIsLiked
        posts[index] = updatedPost

        // 网络请求
        postService.toggleLike(postID: post.id) { [weak self] result in
            switch result {
            case .success(let isLiked):
                // 确认服务器状态
                var finalPost = updatedPost
                finalPost.liked = isLiked
                self?.posts[index] = finalPost

                self?.printInfo("\(isLiked ? "点赞" : "取消点赞")成功")

            case .failure(let error):
                // 回滚到原始状态
                self?.posts[index] = post
                self?.errorMessage = error.localizedDescription
                self?.printError("点赞操作失败: \(error)")
            }
        }
    }

    func sharePost(at index: Int) {
        guard index >= 0 && index < posts.count else { return }

        let post = posts[index]

        // 发送分享通知
        Manage_PostNotification("SharePost", object: [
            "post": post,
            "index": index
        ])

        A.log.info("分享动态: \(post.content)")
    }

    func deletePost(at index: Int) {
        guard index >= 0 && index < posts.count else { return }

        let post = posts[index]

        // 确认删除
        Manage_PostNotification("ConfirmDeletePost", object: [
            "post": post,
            "index": index
        ])
    }

    func reportPost(at index: Int, reason: String) {
        guard index >= 0 && index < posts.count else { return }

        let post = posts[index]

        postService.reportPost(postID: post.id, reason: reason) { [weak self] result in
            switch result {
            case .success:
                self?.printInfo("举报成功")
                self?.Manage_PostNotification("ReportSuccess", object: ["index": index])

            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.printError("举报失败: \(error)")
            }
        }
    }

    private func handlePostsResponse(_ response: PostResponse, refresh: Bool) {
        if refresh {
            posts = response.posts
        } else {
            posts.append(contentsOf: response.posts)
        }

        hasMoreData = response.hasMore
    }

    override func a_Other() {
        super.a_Other()

        // 初始加载
        loadPosts()
    }

    override func a_Notification() {
        super.a_Notification()

        Manage_SetNotifications([
            "PullToRefresh",
            "LoadMore"
        ])
    }

    override func ANotificationReceive(notification: Notification) {
        super.ANotificationReceive(notification: notification)

        switch notification.name.rawValue {
        case "PullToRefresh":
            refreshPosts()

        case "LoadMore":
            loadMorePosts()

        default:
            break
        }
    }
}
```

#### 2. Feed View

```swift
// FeedView.swift
import UIKit
import Foundation

import Aquarius

class FeedView: AView {

    // MARK: - UI Components
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let tableView: UITableView = A.ui.plainTableView
    private let loadingIndicator: UIActivityIndicatorView = A.ui.activityIndicatorView
    private let errorLabel: UILabel = A.ui.label
    private let emptyView: UIView = UIView()

    // MARK: - Data Binding
    @objc dynamic private var binding_posts: [Any] = []
    @objc dynamic private var binding_isLoading: Bool = false
    @objc dynamic private var binding_isRefreshing: Bool = false
    @objc dynamic private var binding_errorMessage: String = ""

    // MARK: - Lifecycle
    override func a_UI() {
        super.a_UI()

        addSubviews(views: [
            tableView,
            loadingIndicator,
            errorLabel,
            emptyView
        ])
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        // 配置表格
        tableView.register(FeedPostCell.self, forCellReuseIdentifier: "FeedPostCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension

        // 配置下拉刷新
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        // 配置加载指示器
        loadingIndicator.style = .large
        loadingIndicator.isHidden = true

        // 配置错误标签
        errorLabel.textAlignment = .center
        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        // 配置空状态视图
        setupEmptyView()
    }

    override func a_Layout() {
        super.a_Layout()

        tableView.size(
            width: screenWidth(),
            height: screenHeight()
        )
        tableView.point(points: [0, 0])

        loadingIndicator.size(sizes: [50, 50])
        loadingIndicator.point(points: [
            screenWidth() / 2 - 25,
            screenHeight() / 2 - 25
        ])

        errorLabel.size(sizes: [screenWidth() - 40, 100])
        errorLabel.point(points: [20, screenHeight() / 2 - 50])

        emptyView.size(
            width: screenWidth(),
            height: 200
        )
        emptyView.point(points: [
            0,
            screenHeight() / 2 - 100
        ])
    }

    override func a_Bind() {
        super.a_Bind()

        bindsFrom(dict: [
            "posts" : #keyPath(binding_posts),
            "loading" : #keyPath(binding_isLoading),
            "refreshing" : #keyPath(binding_isRefreshing),
            "error" : #keyPath(binding_errorMessage)
        ])
    }

    override func a_Delegate() {
        super.a_Delegate()

        Manage_SetDelegate(
            targetObject: tableView,
            delegateNames: AProtocol.delegateAndDataSource,
            object: self
        )
    }

    // MARK: - Private Methods
    private func setupEmptyView() {
        let imageView = UIImageView(image: "emptyFeed".toNamedImage())
        let label = UILabel()

        label.text = "暂无动态"
        label.font = 16.0.toFont
        label.textAlignment = .center
        label.textColor = .gray

        emptyView.addSubview(imageView)
        emptyView.addSubview(label)

        imageView.size(sizes: [80, 80])
        imageView.point(points: [screenWidth() / 2 - 40, 20])

        label.size(sizes: [screenWidth() - 40, 30])
        label.point(points: [20, imageView.bottom() + 10])

        emptyView.isHidden = true
    }

    private func updateEmptyView(_ posts: [Any]) {
        emptyView.isHidden = !posts.isEmpty
    }

    @objc private func handleRefresh() {
        Manage_PostNotification("PullToRefresh")
    }

    private func handleScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        // 触发上拉加载更多
        if offsetY > contentHeight - screenHeight - 100 {
            Manage_PostNotification("LoadMore")
        }
    }

    private func showActionSheet(for index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let likeAction = UIAlertAction(title: "点赞", style: .default) { [weak self] _ in
            self?.Manage_PostNotification("LikePost", object: ["index": index])
        }

        let shareAction = UIAlertAction(title: "分享", style: .default) { [weak self] _ in
            self?.Manage_PostNotification("SharePost", object: ["index": index])
        }

        let reportAction = UIAlertAction(title: "举报", style: .destructive) { [weak self] _ in
            self?.showReportDialog(for: index)
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel)

        actionSheet.addAction(likeAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)

        // 显示操作表
        if let viewController = getViewController() {
            viewController.present(actionSheet, animated: true)
        }
    }

    private func showReportDialog(for index: Int) {
        let alert = UIAlertController(title: "举报动态", message: "请选择举报原因", preferredStyle: .alert)

        let reasons = ["垃圾信息", "不实内容", "恶意营销", "其他"]

        for reason in reasons {
            let action = UIAlertAction(title: reason, style: .default) { [weak self] _ in
                self?.Manage_PostNotification("ReportPost", object: [
                    "index": index,
                    "reason": reason
                ])
            }
            alert.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(cancelAction)

        if let viewController = getViewController() {
            viewController.present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension FeedView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return binding_posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedPostCell", for: indexPath) as! FeedPostCell

        let post = binding_posts[indexPath.row]
        cell.configure(with: post)

        // 设置事件回调
        cell.onLikeTapped = { [weak self] in
            self?.Manage_PostNotification("LikePost", object: ["index": indexPath.row])
        }

        cell.onCommentTapped = { [weak self] in
            self?.Manage_PostNotification("CommentPost", object: ["index": indexPath.row])
        }

        cell.onShareTapped = { [weak self] in
            self?.Manage_PostNotification("SharePost", object: ["index": indexPath.row])
        }

        cell.onMoreTapped = { [weak self] in
            self?.showActionSheet(for: indexPath.row)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension FeedView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // 跳转到动态详情
        Manage_PostNotification("PostDetail", object: ["index": indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
```

#### 3. Feed Post Cell

```swift
// FeedPostCell.swift
import UIKit

import Aquarius

class FeedPostCell: ATableViewCell {

    // MARK: - UI Components
    private let avatarImageView: UIImageView = A.ui.imageView
    private let nameLabel: UILabel = A.ui.label
    private let timeLabel: UILabel = A.ui.label
    private let contentLabel: UILabel = A.ui.label
    private let postImageView: UIImageView = A.ui.imageView
    private let likeButton: UIButton = A.ui.button
    private let commentButton: UIButton = A.ui.button
    private let shareButton: UIButton = A.ui.button
    private let moreButton: UIButton = A.ui.button
    private let likeCountLabel: UILabel = A.ui.label

    // MARK: - Callbacks
    var onLikeTapped: (() -> Void)?
    var onCommentTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    var onMoreTapped: (() -> Void)?

    override func a_UI() {
        super.a_UI()

        addSubviewInContentView(view: [
            avatarImageView,
            nameLabel,
            timeLabel,
            contentLabel,
            postImageView,
            likeButton,
            commentButton,
            shareButton,
            moreButton,
            likeCountLabel
        ])

        setupStyles()
    }

    override func a_UIConfig() {
        super.a_UIConfig()

        avatarImageView.layerCornerRadius(20)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true

        postImageView.isHidden = true

        // 姓名样式
        nameLabel.font = 16.0.toFont

        // 时间样式
        timeLabel.font = 16.0.toFont

        // 内容样式
        contentLabel.font = 16.0.toFont
        contentLabel.numberOfLines = 0

        // 动态图片样式
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.layerCornerRadius(8)

        // 按钮样式
        likeButton.setTitle("👍", for: .normal)
        commentButton.setTitle("💬", for: .normal)
        shareButton.setTitle("📤", for: .normal)
        moreButton.setTitle("⋮", for: .normal)

        // 点赞数样式
        likeCountLabel.font = 16.0.toFont
        likeCountLabel.isHidden = true
    }

    override func a_Layout() {
        super.a_Layout()
        // 头像
        avatarImageView.size(sizes: [40, 40])
        avatarImageView.point(points: [15, 15])

        // 姓名
        nameLabel.size(sizes: [200, 20])
        nameLabel.point(points: [65, 15])

        // 时间
        timeLabel.size(sizes: [100, 15])
        timeLabel.point(points: [65, 37])

        // 内容
        contentLabel.size(sizes: [screenWidth() - 30, 0]) // 动态高度
        contentLabel.point(points: [15, 65])

        // 动态图片
        postImageView.size(sizes: [0, 0]) // 动态尺寸
        postImageView.point(points: [15, contentLabel.bottom() + 10])

        // 点赞按钮
        likeButton.size(sizes: [30, 30])
        likeButton.point(points: [15, postImageView.isHidden ? contentLabel.bottom() + 20 : postImageView.bottom() + 20])

        // 评论按钮
        commentButton.size(sizes: [30, 30])
        commentButton.point(points: [55, likeButton.top()])

        // 分享按钮
        shareButton.size(sizes: [30, 30])
        shareButton.point(points: [95, likeButton.top()])

        // 更多按钮
        moreButton.size(sizes: [30, 30])
        moreButton.point(points: [screenWidth() - 45, likeButton.top()])

        // 点赞数
        likeCountLabel.size(sizes: [100, 20])
        likeCountLabel.point(points: [likeButton.right() + 10, likeButton.top() + 5])
    }

    override func a_Event() {
        super.a_Event()

        likeButton.addTouchUpInside(self, selector: #selector(handleLikeTapped))
        commentButton.addTouchUpInside(self, selector: #selector(handleCommentTapped))
        shareButton.addTouchUpInside(self, selector: #selector(handleShareTapped))
        moreButton.addTouchUpInside(self, selector: #selector(handleMoreTapped))
    }

    override func updateThemeStyle() {
        super.updateThemeStyle()
        // 头像样式
        avatarImageView.backgroundColor = .lightGray
        nameLabel.textColor = .black
        timeLabel.textColor = .gray
        contentLabel.textColor = .black
        likeCountLabel.textColor = .gray
    }

    // MARK: - Configuration
    func configure(with post: Post) {
        // 配置头像
        if let avatarURL = post.user.avatarURL {
            loadImage(from: avatarURL, into: avatarImageView)
        }

        // 配置姓名和时间
        nameLabel.text = post.user.name
        timeLabel.text = formatTime(post.createdAt)

        // 配置内容
        contentLabel.text = post.content

        // 配置图片
        if let imageURL = post.imageURL {
            postImageView.isHidden = false
            loadImage(from: imageURL, into: postImageView)

            // 重新计算布局
            setNeedsLayout()
            layoutIfNeeded()
        } else {
            postImageView.isHidden = true
        }

        // 配置点赞状态
        updateLikeButtonState(post.liked)
        likeCountLabel.text = "\(post.likeCount)"
        likeCountLabel.isHidden = post.likeCount == 0
    }

    private func updateLikeButtonState(_ isLiked: Bool) {
        likeButton.setTitle(isLiked ? "❤️" : "👍", for: .normal)
        likeButton.setTitleColor(isLiked ? .red : .gray, for: .normal)
    }

    private func loadImage(from url: String, into imageView: UIImageView) {
        // 这里应该使用真实的图片加载库，如 SDWebImage 或 Kingfisher
        // 为了演示，我们使用占位符
        imageView.image = "placeholder".toNamedImage()

        // 异步加载图片
        DispatchQueue.global().async {
            if let imageURL = URL(string: url),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {

                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    // MARK: - Event Handlers
    @objc private func handleLikeTapped() {
        onLikeTapped?()
    }

    @objc private func handleCommentTapped() {
        onCommentTapped?()
    }

    @objc private func handleShareTapped() {
        onShareTapped?()
    }

    @objc private func handleMoreTapped() {
        onMoreTapped?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // 重置状态
        avatarImageView.image = nil
        postImageView.image = nil
        postImageView.isHidden = true
        contentLabel.text = nil
        likeCountLabel.isHidden = true
    }
}
```

---

## 最佳实践指南

### 🎯 设计原则

#### 1. 单一职责原则（SRP）

每个类、方法、模块只负责一种职责。

```swift
// ❌ 违反SRP - 混合了多种职责
class BadViewModel: AViewModel {
    func handleUserLogin() {
        // 1. 数据验证（验证职责）
        guard validateInput() else { return }

        // 2. 网络请求（网络职责）
        let result = networkService.login()

        // 3. 数据存储（存储职责）
        storageService.save(result)

        // 4. 界面更新（UI职责）
        updateUI()
    }
}

// ✅ 遵循SRP - 职责分离
class GoodViewModel: AViewModel {
    private let validator: InputValidator
    private let networkService: NetworkService
    private let storageService: StorageService

    func handleUserLogin() {
        guard validator.validateInput() else {
            showValidationError()
            return
        }

        performLogin()
    }

    private func performLogin() {
        networkService.login { [weak self] result in
            switch result {
            case .success(let user):
                self?.storageService.save(user)
                self?.notifyLoginSuccess(user)
            case .failure(let error):
                self?.handleLoginError(error)
            }
        }
    }
}

class InputValidator {
    func validateInput() -> Bool {
        // 只负责验证
        return true
    }
}
```

#### 2. 开闭原则（OCP）

对扩展开放，对修改封闭。

```swift
// ✅ 支持扩展的架构
protocol PostServiceProtocol {
    func fetchPosts(page: Int, perPage: Int, completion: @escaping (Result<PostResponse, Error>) -> Void)
    func toggleLike(postID: Int, completion: @escaping (Result<Bool, Error>) -> Void)
}

// 基础实现
class PostService: PostServiceProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchPosts(page: Int, perPage: Int, completion: @escaping (Result<PostResponse, Error>) -> Void) {
        let endpoint = PostEndpoint.list(page: page, perPage: perPage)
        networkClient.request(endpoint, completion: completion)
    }

    func toggleLike(postID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = PostEndpoint.like(postID: postID)
        networkClient.request(endpoint) { (result: Result<ToggleLikeResponse, Error>) in
            completion(result.map { $0.isLiked })
        }
    }
}

// 缓存实现（扩展功能）
class CachedPostService: PostServiceProtocol {
    private let postService: PostServiceProtocol
    private let cache: CacheService

    init(postService: PostServiceProtocol = PostService(), cache: CacheService = CacheService()) {
        self.postService = postService
        self.cache = cache
    }

    func fetchPosts(page: Int, perPage: Int, completion: @escaping (Result<PostResponse, Error>) -> Void) {
        // 先尝试从缓存获取
        let cacheKey = "posts_page_\(page)"

        if let cachedResponse: PostResponse = cache.load(forKey: cacheKey) {
            completion(.success(cachedResponse))
            return
        }

        // 缓存未命中，调用网络服务
        postService.fetchPosts(page: page, perPage: perPage) { [weak self] result in
            switch result {
            case .success(let response):
                self?.cache.save(response, forKey: cacheKey)
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func toggleLike(postID: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        postService.toggleLike(postID: postID, completion: completion)
    }
}
```

#### 3. 里氏替换原则（LSP）

子类应该能够替换父类使用。

```swift
// ✅ 良好的继承设计
class BaseViewModel: AViewModel {
    @objc dynamic var isLoading: Bool = false
    @objc dynamic var errorMessage: String = ""

    func startLoading() {
        isLoading = true
    }

    func stopLoading() {
        isLoading = false
    }

    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
    }

    // 可被子类重写
    func performAction() {
        // 基础实现
    }
}

class FeedViewModel: BaseViewModel {
    @objc dynamic var posts: [Post] = []

    override func performAction() {
        startLoading()

        // Feed 特定的逻辑
        fetchFeedData()
    }

    private func fetchFeedData() {
        // 实现逻辑
        stopLoading()
    }
}

class ProfileViewModel: BaseViewModel {
    @objc dynamic var user: User?

    override func performAction() {
        startLoading()

        // Profile 特定的逻辑
        fetchUserData()
    }

    private func fetchUserData() {
        // 实现逻辑
        stopLoading()
    }
}

// 客户端代码
func executeViewModel(_ viewModel: BaseViewModel) {
    viewModel.performAction() // 任何子类都可以替换使用
}
```

### 📋 代码规范

#### 1. 命名规范

```swift
// ✅ 清晰的命名
class UserProfileViewModel: AViewModel {

    // MARK: - Properties
    @objc dynamic private(set) var userInfo: UserInfo
    @objc dynamic var isUpdatingProfile: Bool = false
    @objc dynamic var profileUpdateError: String = ""

    private let userService: UserServiceProtocol
    private let imageUploadService: ImageUploadServiceProtocol

    // MARK: - Initialization
    init(
        userService: UserServiceProtocol = UserService(),
        imageUploadService: ImageUploadServiceProtocol = ImageUploadService()
    ) {
        self.userService = userService
        self.imageUploadService = imageUploadService
        super.init()
    }

    // MARK: - Public Methods
    func updateProfile(name: String, bio: String?, avatarImage: UIImage?) async {
        isUpdatingProfile = true
        profileUpdateError = ""

        do {
            // 上传头像
            var avatarURL: String?
            if let image = avatarImage {
                avatarURL = try await uploadAvatar(image)
            }

            // 更新用户信息
            let updatedUser = try await userService.updateProfile(
                name: name,
                bio: bio,
                avatarURL: avatarURL
            )

            userInfo = UserInfo(from: updatedUser)

        } catch {
            profileUpdateError = error.localizedDescription
        }

        isUpdatingProfile = false
    }

    // MARK: - Private Methods
    private func uploadAvatar(_ image: UIImage) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            imageUploadService.uploadImage(image) { result in
                switch result {
                case .success(let url):
                    continuation.resume(returning: url)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
```

#### 2. 注释规范

```swift
class NetworkService {

    /// 执行 HTTP 请求
    /// - Parameters:
    ///   - endpoint: API 端点
    ///   - method: HTTP 方法
    ///   - parameters: 请求参数
    ///   - headers: 请求头
    ///   - completion: 完成回调
    /// - Returns: 请求标识符，可用于取消请求
    @discardableResult
    func request<T: Codable>(
        _ endpoint: Endpoint,
        method: HTTPMethod = .GET,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> UUID {
        // 实现逻辑
        return UUID()
    }

    /// 上传文件到服务器
    /// - Parameters:
    ///   - fileData: 文件数据
    ///   - fileName: 文件名
    ///   - mimeType: MIME 类型
    ///   - progress: 上传进度回调
    ///   - completion: 完成回调
    func uploadFile(
        fileData: Data,
        fileName: String,
        mimeType: String,
        progress: ((Double) -> Void)? = nil,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        // 实现逻辑
    }
}
```

#### 3. 错误处理规范

```swift
// ✅ 统一的错误处理
enum NetworkError: LocalizedError {
    case invalidURL
    case noInternetConnection
    case serverError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的 URL"
        case .noInternetConnection:
            return "网络连接不可用"
        case .serverError(let statusCode):
            return "服务器错误 (状态码: \(statusCode))"
        case .decodingError(let error):
            return "数据解析错误: \(error.localizedDescription)"
        case .unknown(let error):
            return "未知错误: \(error.localizedDescription)"
        }
    }
}

// 使用示例
class UserService {
    func fetchUser(id: Int) async throws -> User {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidURL
            }

            switch httpResponse.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                return try decoder.decode(User.self, from: data)
            case 400...499:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            case 500...599:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            default:
                throw NetworkError.unknown(NSError(domain: "Unknown", code: -1))
            }

        } catch let error as NetworkError {
            throw error
        } catch {
            if error is DecodingError {
                throw NetworkError.decodingError(error)
            } else {
                throw NetworkError.unknown(error)
            }
        }
    }
}
```

### 🚀 性能优化

#### 1. 内存管理

```swift
class FeedViewModel: AViewModel {

    // 使用弱引用避免循环引用
    private weak var delegate: FeedViewModelDelegate?
    private var cancellables: Set<AnyCancellable> = []

    func bindToView(_ view: FeedView) {
        // 使用 [weak self] 避免循环引用
        $posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] posts in
                self?.updateView(with: posts)
            }
            .store(in: &cancellables)
    }

    private func updateView(with posts: [Post]) {
        delegate?.didUpdatePosts(posts)
    }

    deinit {
        // 清理资源
        cancellables.removeAll()
        printInfo("FeedViewModel 已释放")
    }
}
```

#### 2. 异步操作

```swift
// 使用 Async/Await
class ImageLoader {
    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadImage(from url: String) async throws -> UIImage {
        // 先检查缓存
        if let cachedImage = cache.object(forKey: NSString(string: url)) {
            return cachedImage
        }

        // 网络请求
        guard let imageURL = URL(string: url) else {
            throw ImageError.invalidURL
        }

        let (data, _) = try await session.data(from: imageURL)

        guard let image = UIImage(data: data) else {
            throw ImageError.decodingFailed
        }

        // 缓存图片
        cache.setObject(image, forKey: NSString(string: url))

        return image
    }
}

// 使用示例
class PostCell: UITableViewCell {
    func loadImage(from url: String) {
        Task {
            do {
                let image = try await ImageLoader.shared.loadImage(from: url)
                await MainActor.run {
                    postImageView.image = image
                }
            } catch {
                await MainActor.run {
                    postImageView.image = A.image.placeholder
                }
            }
        }
    }
}
```

---

## 常见问题解答

### ❓ 架构相关问题

**Q1: MVVM 和 MVC 相比有什么优势？**

A: MVVM 相比传统 MVC 的主要优势：

1. **更好的职责分离**
   
   - MVC 中 Controller 往往承担过多职责
   - MVVM 将业务逻辑完全转移到 ViewModel

2. **更好的可测试性**
   
   - ViewModel 不依赖 UI 框架
   - 可以独立测试业务逻辑

3. **数据绑定支持**
   
   - 自动同步 ViewModel 和 View
   - 减少样板代码

4. **更好的可维护性**
   
   - 修改 UI 不影响业务逻辑
   - 修改业务逻辑不影响 UI

**Q2: 什么时候应该使用 MVVM？**

A: 适合使用 MVVM 的场景：

1. **复杂的交互界面**
   
   - 多个组件间需要数据同步
   - 表单验证和实时反馈

2. **需要单元测试的项目**
   
   - 业务逻辑需要独立测试
   - 希望减少 UI 测试依赖

3. **大型团队协作项目**
   
   - 需要明确的分工和职责划分
   - 多人并行开发减少冲突

**Q3: 洋葱开发法的执行顺序为什么很重要？**

A: 严格的执行顺序保证了：

1. **依赖关系正确**
   
   - 先有数据再绑定
   - 先有控件再配置
   - 先有配置再布局

2. **初始化流程清晰**
   
   - 预览检查 → 基础配置 → UI创建 → 业务逻辑 → 清理资源
   - 每个层次都有明确的作用

3. **避免初始化错误**
   
   - 防止在控件还没创建时就设置委托
   - 防止在还没数据时就绑定UI

**Q4: 如何处理复杂的业务逻辑？**

A: 处理复杂业务逻辑的策略：

```swift
// 1. 使用多个ViewModel组合
class ComplexViewModel: AViewModel {
    private let dataViewModel: DataViewModel
    private let validationViewModel: ValidationViewModel
    private let stateViewModel: StateViewModel

    func processData(_ input: InputData) {
        // 委托给专门的ViewModel处理
        let validationResult = validationViewModel.validate(input)
        guard validationResult.isValid else {
            handleValidationError(validationResult.errors)
            return
        }

        let processedData = dataViewModel.process(input)
        stateViewModel.updateState(.completed)
    }
}

// 2. 使用命令模式封装操作
protocol Command {
    func execute() -> Result<Void, Error>
}

class LoadDataCommand: Command {
    private let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
    }

    func execute() -> Result<Void, Error> {
        return dataService.loadData()
    }
}

// 3. 使用状态机管理复杂状态
enum ViewState {
    case loading
    case loaded([Data])
    case error(Error)
    case empty

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

class StateManagementViewModel: AViewModel {
    @objc dynamic var state: ViewState = .loading

    func loadData() {
        state = .loading

        dataService.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                if data.isEmpty {
                    self?.state = .empty
                } else {
                    self?.state = .loaded(data)
                }
            case .failure(let error):
                self?.state = .error(error)
            }
        }
    }
}
```

**Q5: 如何优化Aquarius框架的性能？**

A: 性能优化的关键策略：

```swift
// 1. 合理使用数据绑定
class OptimizedViewModel: AViewModel {
    @objc dynamic var allData: [Data] = []
    @objc dynamic var filteredData: [Data] = []
    @objc dynamic var searchQuery: String = ""

    override func a_Bind() {
        super.a_Bind()

        // 只绑定必要的属性，避免过度绑定
        bindsTo(dict: [
            "filteredData" : #keyPath(filteredData),
            "searchQuery" : #keyPath(searchQuery)
        ])
    }

    override func a_Other() {
        super.a_Other()

        // 在后台线程处理大量数据
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.filterData(query: query)
            }
            .store(in: &cancellables)
    }

    private func filterData(query: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let filtered = self?.allData.filter { item in
                item.title.localizedCaseInsensitiveContains(query)
            } ?? []

            DispatchQueue.main.async {
                self?.filteredData = filtered
            }
        }
    }
}

// 2. 懒加载和缓存
class CachedImageViewModel: AViewModel {
    private var imageCache: [String: UIImage] = [:]

    func loadImage(for post: Post) async -> UIImage? {
        if let cachedImage = imageCache[post.id] {
            return cachedImage
        }

        do {
            let image = try await ImageService.shared.loadImage(from: post.imageURL)
            imageCache[post.id] = image
            return image
        } catch {
            printError("加载图片失败: \(error)")
            return nil
        }
    }
}
```

**Q6: 错误处理和用户体验如何平衡？**

A: 平衡错误处理和用户体验的原则：

```swift
class ErrorHandlingViewModel: AViewModel {
    @objc dynamic var errorMessage: String = ""
    @objc dynamic var isShowingError: Bool = false
    @objc dynamic var isRetrying: Bool = false

    func handleNetworkError(_ error: NetworkError) {
        switch error {
        case .noInternetConnection:
            errorMessage = "网络连接不可用，请检查网络设置"
            isShowingError = true

        case .serverError(let statusCode):
            if statusCode == 500 {
                errorMessage = "服务器暂时不可用，请稍后重试"
            } else {
                errorMessage = "请求失败，请重试"
            }
            isShowingError = true

        case .timeout:
            errorMessage = "请求超时，请检查网络连接"
            isShowingError = true

        case .decodingError:
            errorMessage = "数据解析错误，请联系技术支持"
            isShowingError = true
        }
    }

    func retryLastOperation() {
        isRetrying = true
        isShowingError = false

        // 模拟重试逻辑
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.performLastOperation()
            self?.isRetrying = false
        }
    }
}

// 在View中处理错误显示
extension ErrorHandlingView {
    override func a_Bind() {
        super.a_Bind()

        bindsFrom(dict: [
            "errorMessage" : #keyPath(errorLabel.text),
            "isShowingError" : #keyPath(errorView.isHidden),
            "isRetrying" : #keyPath(retryButton.isEnabled)
        ])
    }

    private func showRetryAlert() {
        let alert = UIAlertController(title: "操作失败", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "重试", style: .default) { [weak self] _ in
            self?.viewModel.retryLastOperation()
        })
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))

        viewController?.present(alert, animated: true)
    }
}
```

**Q7: 如何在Aquarius中实现模块化开发？**

A: 模块化开发的最佳实践：

```swift
// 1. 功能模块封装
protocol FeedModuleProtocol {
    func present(in navigationController: UINavigationController)
    func presentDetail(for post: Post)
}

class FeedModule: FeedModuleProtocol {
    private let viewController: FeedViewController

    init(coordinator: FeedCoordinator? = nil) {
        self.viewController = FeedViewController()
    }

    func present(in navigationController: UINavigationController) {
        navigationController.pushViewController(viewController, animated: true)
    }

    func presentDetail(for post: Post) {
        let detailModule = PostDetailModule(post: post)
        detailModule.present(in: navigationController)
    }
}

// 2. 模块间通信
protocol FeedModuleDelegate: AnyObject {
    func feedModuleDidSelectPost(_ post: Post)
    func feedModuleDidRequestLogin()
}

class FeedCoordinator {
    weak var delegate: FeedModuleDelegate?

    func handlePostSelection(_ post: Post) {
        delegate?.feedModuleDidSelectPost(post)
    }
}

// 3. 主题系统模块化
protocol ThemeProtocol {
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
}

struct LightTheme: ThemeProtocol {
    let primaryColor = UIColor.systemBlue
    let secondaryColor = UIColor.systemGray
    let backgroundColor = UIColor.systemBackground
    let textColor = UIColor.label
}

struct DarkTheme: ThemeProtocol {
    let primaryColor = UIColor.systemBlue
    let secondaryColor = UIColor.systemGray2
    let backgroundColor = UIColor.systemBackground
    let textColor = UIColor.label
}

class ThemeManager {
    static let shared = ThemeManager()
    private(set) var currentTheme: ThemeProtocol = LightTheme()

    func switchTheme() {
        currentTheme = currentTheme is LightTheme ? DarkTheme() : LightTheme()
        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }
}
```

**Q8: 测试策略如何设计？**

A: 完整的测试策略：

```swift
// 1. ViewModel单元测试
class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockAuthService: MockAuthService!

    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        viewModel = LoginViewModel(authService: mockAuthService)
    }

    func testLoginWithValidCredentials() {
        // Given
        mockAuthService.result = .success(TestData.user)

        // When
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        viewModel.login()

        // Then
        XCTAssertTrue(viewModel.isLoggedIn)
        XCTAssertEqual(viewModel.errorMessage, "")
    }

    func testLoginWithInvalidEmail() {
        // Given
        mockAuthService.result = .failure(AuthError.invalidEmail)

        // When
        viewModel.email = "invalid-email"
        viewModel.password = "password123"
        viewModel.login()

        // Then
        XCTAssertFalse(viewModel.isLoggedIn)
        XCTAssertEqual(viewModel.errorMessage, "邮箱格式不正确")
    }
}

// 2. View集成测试
class LoginViewTests: XCTestCase {
    var view: LoginView!
    var viewModel: LoginViewModel!

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
        view = LoginView()
        view.viewModel = viewModel
    }

    func testUIBindsToViewModel() {
        // Given
        viewModel.email = "test@example.com"

        // Then
        XCTAssertEqual(view.emailTextField.text, "test@example.com")
    }
}

// 3. 端到端测试
class LoginFlowTests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testLoginFlow() {
        // Given
        let emailField = app.textFields["emailTextField"]
        let passwordField = app.secureTextFields["passwordTextField"]
        let loginButton = app.buttons["loginButton"]

        // When
        emailField.tap()
        emailField.typeText("test@example.com")

        passwordField.tap()
        passwordField.typeText("password123")

        loginButton.tap()

        // Then
        let welcomeLabel = app.staticTexts["welcomeLabel"]
        XCTAssertTrue(welcomeLabel.waitForExistence(timeout: 5))
    }
}
```

---

## 总结与最佳实践

### 🎯 核心要点回顾

通过本教程，我们深入理解了：

1. **MVVM架构的优势**
   
   - 职责分离：View专注UI，ViewModel专注业务逻辑
   - 可测试性：ViewModel可以独立测试
   - 可维护性：代码结构清晰，便于维护

2. **洋葱开发法的精髓**
   
   - 层次分明：每个函数都有明确的职责
   - 执行有序：按照预定的顺序执行各个阶段
   - 便于协作：团队成员可以并行开发不同层次

3. **Aquarius框架的核心特性**
   
   - 数据绑定：自动同步ViewModel和View
   - 事件驱动：基于通知的事件通信
   - 主题系统：支持动态主题切换

### 📈 最佳实践指南

#### 1. 架构设计原则

```swift
// ✅ 遵循单一职责原则
class UserProfileViewModel: AViewModel {
    // 只负责用户资料相关的业务逻辑
    @objc dynamic var userProfile: UserProfile?
    @objc dynamic var isEditing: Bool = false
}

// ✅ 使用协议定义接口
protocol UserServiceProtocol {
    func fetchUserProfile(id: String) -> Result<UserProfile, Error>
    func updateUserProfile(_ profile: UserProfile) -> Result<Void, Error>
}

class UserProfileViewController: AViewController {
    private let viewModel: UserProfileViewModel = UserProfileViewModel()

}
```

#### 2. 性能优化策略

```swift
// ✅ 合理使用数据绑定
class OptimizedFeedViewModel: AViewModel {
    @objc dynamic var posts: [Post] = [] // 只绑定必要的属性

    // 使用后台线程处理复杂计算
    func processPosts(_ rawPosts: [RawPost]) {
        DispatchQueue.global(qos: .userInitiated).async {
            let processed = rawPosts.map { self.transform($0) }
            DispatchQueue.main.async {
                self.posts = processed
            }
        }
    }
}

// ✅ 内存管理
class ImageLoader {
    private var cache: NSCache<NSString, UIImage> = NSCache()
    private var activeRequests: [String: Task<UIImage?, Error>] = [:]

    func cancelRequest(for key: String) {
        activeRequests[key]?.cancel()
        activeRequests.removeValue(forKey: key)
    }
}
```

#### 3. 错误处理策略

```swift
// ✅ 分层错误处理
class RobustViewModel: AViewModel {
    @objc dynamic var errorState: ErrorState = .none

    enum ErrorState {
        case none
        case networkError(NetworkError)
        case validationError(ValidationError)
        case unknownError(Error)

        var message: String {
            switch self {
            case .none: return ""
            case .networkError(let error): return error.localizedDescription
            case .validationError(let error): return error.message
            case .unknownError(let error): return "未知错误: \(error.localizedDescription)"
            }
        }
    }

    func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            errorState = .networkError(networkError)
        } else if let validationError = error as? ValidationError {
            errorState = .validationError(validationError)
        } else {
            errorState = .unknownError(error)
        }
    }
}
```

### 🎉 结语

Aquarius框架通过MVVM架构和洋葱开发法，为iOS开发提供了一套完整、优雅的解决方案。它不仅提高了代码质量，还大大改善了团队协作效率。

记住，优秀的架构不仅仅是技术实现，更是一种思维方式的体现。在实际项目中，要根据具体需求灵活运用这些原则，创造出最适合的解决方案。

**学习是一个持续的过程**，希望本教程能为你的iOS开发之旅奠定坚实的基础。继续探索，不断实践，你一定能掌握这套强大的开发体系！

---

## 🔗 相关资源

- [Aquarius 框架完整学习指南](../Aquarius-完整学习指南.md)
- [如何导入Aquarius开发框架](../Docs/1.如何导入Aquarius开发框架.md)
- [A.swift 使用指南](../Docs/5.A.swift 使用指南.md)
- [布局系统详解](../Docs/4.布局系统.md)
- [数据绑定最佳实践](数据绑定最佳实践-简化指南.md)

---

> **📝 教程信息**

> - **版本**：v1.0
> - **更新日期**：2025年11月17日
> - **适用版本**：Aquarius 1.2.0+
> - **难度等级**：⭐⭐⭐☆☆（入门）
> 
> **👨‍💻 作者**：JZXStudio  
> **📞 联系方式**：studio_jzx@163.com 
> 
> **🌐 项目地址**：https://github.com/JZXStudio/Aquarius