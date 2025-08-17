# MemoryEcho - 记忆回廊 iOS应用

## 项目简介

MemoryEcho是一个基于SwiftUI开发的iOS应用，旨在帮助用户创建和管理"智慧分身"，实现跨时空对话。应用结合了AI技术、语音克隆和TTS合成，让用户能够与基于个人记忆创建的AI角色进行自然对话。

## 核心功能

### 1. 记录与上传
- 创建可以对话的回忆体
- 支持文本输入和文件上传（MP4、文本文件等）
- 智能记忆分类和管理

### 2. 创建智慧分身
- 调用LLM API（Kimi）自动整理零散记忆
- 为每个回忆体创建可对话的"智慧分身"
- 基于上传内容生成个性化AI角色

### 3. 跨时空对话
- 与"智慧分身"进行实时对话
- 集成语音克隆技术，使用用户上传的声音
- 情感化的AI回复体验

## 技术架构

### 前端技术
- **SwiftUI**: 现代化的iOS UI框架
- **Combine**: 响应式编程
- **AVFoundation**: 音频处理

### 后端服务
- **Kimi API**: LLM服务
- **Index TTS**: 语音合成
- **语音克隆**: 个性化语音生成

### 数据存储
- **UserDefaults**: 本地数据持久化
- **Core Data**: 复杂数据模型（可选）
- **文件系统**: 音频和媒体文件存储

## 项目结构

```
MemoryEcho/
├── Models/                 # 数据模型
│   ├── Role.swift         # 角色模型
│   ├── Knowledge.swift    # 知识/记忆模型
│   ├── Message.swift      # 消息模型
│   └── Thread.swift       # 对话线程模型
├── Services/              # 业务服务
│   ├── RoleManager.swift      # 角色管理
│   ├── KnowledgeManager.swift # 知识管理
│   ├── ThreadManager.swift    # 对话管理
│   ├── AIService.swift        # AI服务
│   └── VoiceService.swift     # 语音服务
├── Views/                 # 用户界面
│   ├── ContentView.swift      # 主视图
│   ├── MemoryCorridorView.swift # 记忆回廊
│   ├── RoleEditView.swift     # 角色编辑
│   ├── ChatView.swift         # 聊天界面
│   ├── MemoryAddView.swift    # 记忆添加
│   ├── VoiceManagementView.swift # 语音管理
│   └── SettingsView.swift     # 设置界面
├── Assets.xcassets/       # 应用资源
├── Preview Content/        # 预览资源
├── MemoryEchoApp.swift    # 应用入口
└── Info.plist             # 应用配置
```

## 安装和运行

### 系统要求
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### 安装步骤
1. 克隆项目到本地
2. 在Xcode中打开`MemoryEcho.xcodeproj`
3. 配置开发者账号和Bundle Identifier
4. 运行项目到模拟器或真机

### 配置API密钥
在`SettingsView.swift`中配置以下服务：
- Kimi API密钥
- 语音服务配置
- 其他第三方服务

## 使用说明

### 创建角色
1. 点击右上角"+"按钮
2. 填写角色名称、描述和背景
3. 选择头像和语音设置
4. 保存角色

### 添加记忆
1. 在角色详情页点击"记忆"按钮
2. 选择记忆类型（文本或文件）
3. 输入内容或选择文件
4. AI自动分析并整合到知识库

### 开始对话
1. 点击角色卡片进入聊天界面
2. 输入问题或话题
3. AI基于记忆内容生成回复
4. 可选择语音播放回复

## 开发计划

### 第一阶段（当前）
- [x] 基础UI框架
- [x] 数据模型设计
- [x] 本地存储实现
- [x] 基础对话功能

### 第二阶段
- [ ] 集成Kimi API
- [ ] 实现Index TTS
- [ ] 语音克隆功能
- [ ] 文件上传处理

### 第三阶段
- [ ] 云端同步
- [ ] 多用户支持
- [ ] 高级AI功能
- [ ] 性能优化

## 贡献指南

欢迎提交Issue和Pull Request来改进项目。

### 代码规范
- 遵循Swift官方代码规范
- 使用SwiftLint进行代码检查
- 添加适当的注释和文档

### 提交规范
- 使用清晰的提交信息
- 每个提交专注于单一功能
- 包含必要的测试用例

## 许可证

本项目采用MIT许可证，详见LICENSE文件。

## 联系方式

- 项目主页: [GitHub Repository]
- 问题反馈: [Issues]
- 邮箱: [your-email@example.com]

## 致谢

感谢以下开源项目和服务的支持：
- SwiftUI和iOS SDK
- Kimi AI团队
- Index TTS项目
- 所有贡献者和用户 
