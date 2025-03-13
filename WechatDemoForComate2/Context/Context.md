## APP 开发上下文：Swift 6.0 + MVVM + SwiftUI

### 🔧 开发规范

#### 1. 设计模式：MVVM

- **Model**：负责数据管理和业务逻辑处理。
- **View**：负责 UI 显示，监听 ViewModel 状态变化。
- **ViewModel**：负责处理视图逻辑，协调 Model 和 View 之间的数据流。
- **数据绑定**：使用 `@Published`、`ObservableObject` 等 SwiftUI 特性实现双向绑定。

#### 2. 编程语言：Swift 6.0

- **语言特性**：支持最新的 Swift 6.0 语法，如宏、actor 优化、模式匹配增强。
- **异步编程**：优先使用 `async/await` 处理异步任务。
- **错误处理**：采用 `Result` 类型或 `throws` 关键字进行明确的错误处理。

#### 3. 布局方式：SwiftUI

- **声明式 UI**：使用 SwiftUI 的声明式语法描述视图层。
- **布局工具**：优先使用 `VStack`、`HStack`、`ZStack` 等容器。
- **状态管理**：利用 `State`、`Binding`、`Environment` 和 `ObservableObject` 管理组件状态。

#### 4. UseCase 和 Repository 层

- **UseCase（用例层）**
  - **职责**：负责调用 Repository，并将返回数据处理成业务所需的格式。
  - **协议抽象**：定义 `UserUseCaseProtocol`，明确接口。
  - **错误处理**：在 UseCase 层处理 API 错误，返回清晰的错误信息。

- **Repository（仓储层）**
  - **职责**：使用 `NetworkService` 调用 API，处理基础网络逻辑。
  - **协议抽象**：定义 `UserRepositoryProtocol`，使 Repository 更易替换和测试。

- **NetworkService & Request**
  - **NetworkService**：处理实际网络请求。
  - **Request 协议**：申明 API 请求路径、入参、请求方法。每个 API 需实现此协议来配置自己的信息。

#### 5. 单元测试规范

- **测试框架**：使用 Swift 6.0 支持的最新 Testing 框架: `Swift Testing`。
- **测试风格**：采用 `Given-When-Then` 结构，明确测试上下文。
- **依赖 Mock**：
  - 测试 ViewModel 时，Mock 对应的 UseCase。
  - 测试 UseCase 时，Mock 对应的 Repository。
  - 测试 Repository 时，Mock 假数据，避免实际网络请求。
  - Mock文件均为 class 类型

  示例：
  ```swift
  import Testing
  @testable import YourApp
  
  struct UserUseCaseTests {
    @Test("Test get user profile success")
    func testGetUserProfile_Success() async {
        // Given
        let mockRepository = MockUserRepository()
        let useCase = UserUseCase(repository: mockRepository)
        let expectedProfile = UserProfile(
            profileImage: "https://example.com/profile.jpg",
            avatar: "https://example.com/avatar.jpg",
            nick: "TestUser",
            username: "testuser"
        )
        mockRepository.userProfile = .success(expectedProfile)
        
        // When
        let result = await useCase.getUserProfile()
        
        // Then
        switch result {
        case .success(let profile):
            #expect(profile.profileImage == expectedProfile.profileImage)
            #expect(profile.avatar == expectedProfile.avatar)
            #expect(profile.nick == expectedProfile.nick)
            #expect(profile.username == expectedProfile.username)
        case .failure:
            #expect(Bool(false), "Expected success but got failure")
        }
    }
  }
  ```
  
### 📂 目录结构建议

```
.
├── Domain/                   # 业务领域层
│   ├── FeatureA/             # 具体业务场景 A
│   │   ├── Views/           # 视图层
│   │   ├── ViewModels/      # 视图模型
│   │   └── UseCases/        # 用例层
│   └── FeatureB/             # 具体业务场景 B
│       ├── Views/
│       ├── ViewModels/
│       └── UseCases/
│
├── Service/                  # 业务服务层
│   ├── ModuleA/              # 业务模块 A
│   │   ├── Repositories/    # 数据仓储
│   │   ├── Models/          # 数据模型
│   │   └── Requests/        # 请求配置
│   └── ModuleB/              # 业务模块 B
│       ├── Repositories/
│       ├── Models/
│       └── Requests/
│
├── Core/                     # 核心基础层
│   └── NetworkService/       # 网络服务
│
├── Tests/                    # 单元测试
├── Resources/                # 资源文件，如图片、字体
└── App.swift                 # 应用程序入口
```

### 🛠️ 架构图（线框图）

```
+---------------------+          +--------------------+          +----------------------+
|        View         | --->     |     ViewModel      | --->     |        UseCase       |
+---------------------+          +--------------------+          +----------------------+
                                                                                   |
                                                                                   v
                                                                  +----------------------+
                                                                  |      Repository      |
                                                                  +----------------------+
                                                                                   |
                                                                                   v
                                                                  +----------------------+
                                                                  |    NetworkService    |
                                                                  +----------------------+
```

数据流转：
1. View 收集用户交互行为，调用 ViewModel 方法。
2. ViewModel 调用 UseCase 处理业务逻辑。
3. UseCase 调用 Repository 获取或存储数据。
4. Repository 调用 NetworkService 发起网络请求。
5. 数据返回后逐层处理，最后更新 UI 或显示错误信息。


