# 嗷嗷算

一个简洁好用的计算器应用，采用iOS风格设计，支持基础计算和科学计算功能，可在所有Flutter支持的平台上运行。

## 功能特性

### 基础计算器功能（竖屏模式）
- ✅ 基本四则运算（加、减、乘、除）
- ✅ 小数点计算
- ✅ 正负号切换（±）
- ✅ 百分比计算（%）
- ✅ 清除功能（AC）
- ✅ 连续计算支持
- ✅ 完全仿照iOS计算器的UI设计

### 科学计算器功能（横屏模式）
- ✅ 三角函数（sin, cos, tan）
- ✅ 对数函数（ln, log₁₀）
- ✅ 幂运算（x², x³）
- ✅ 开方运算（²√x, ³√x）
- ✅ 阶乘运算（x!）
- ✅ 倒数运算（1/x）
- ✅ 数学常数（π, e）
- ✅ 随机数生成（Rand）

### UI设计特点
- 🎨 完全仿照iOS计算器的颜色方案
- 🎨 深灰色背景，橙色操作符按钮
- 🎨 浅灰色功能按钮，深灰色数字按钮
- 🎨 圆形按钮设计（0按钮为椭圆形）
- 🎨 响应式布局，支持横竖屏切换
- 🎨 优雅的字体和间距设计

### 跨平台支持
- 📱 iOS
- 🤖 Android  
- 💻 Windows
- 🖥️ macOS
- 🌐 Web
- 🐧 Linux

## 技术实现

### 依赖包
- `flutter`: Flutter框架
- `math_expressions`: 数学表达式解析和计算
- `cupertino_icons`: iOS风格图标

### 核心技术
- **状态管理**: 使用StatefulWidget进行状态管理
- **响应式设计**: OrientationBuilder实现横竖屏适配
- **数学计算**: math_expressions包处理复杂表达式
- **UI设计**: 完全自定义的iOS风格界面

## 安装和运行

### 前置要求
- Flutter SDK (>=3.2.6)
- Dart SDK
- 对应平台的开发环境

### 安装步骤
1. 克隆项目
```bash
git clone <repository-url>
cd calculator_app
```

2. 安装依赖
```bash
flutter pub get
```

3. 运行应用
```bash
flutter run
```

### 构建发布版本
```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web

# Windows
flutter build windows

# macOS
flutter build macos

# Linux
flutter build linux
```

## 使用说明

### 基础计算器（竖屏）
1. 点击数字按钮输入数字
2. 点击运算符按钮（+、-、×、÷）进行运算
3. 点击等号（=）查看结果
4. 点击AC清除所有内容
5. 点击±切换正负号
6. 点击%计算百分比

### 科学计算器（横屏）
1. 将设备横向旋转进入科学计算器模式
2. 使用三角函数：输入角度值（度），点击sin/cos/tan
3. 使用对数函数：输入正数，点击ln或log₁₀
4. 使用幂运算：输入底数，点击x²或x³
5. 使用开方：输入被开方数，点击²√x或³√x
6. 使用阶乘：输入非负整数，点击x!
7. 点击π或e插入数学常数
8. 点击Rand生成随机数

## 项目结构
```
calculator_app/
├── lib/
│   └── main.dart          # 主应用文件
├── android/               # Android平台配置
├── ios/                   # iOS平台配置
├── web/                   # Web平台配置
├── windows/               # Windows平台配置
├── macos/                 # macOS平台配置
├── linux/                 # Linux平台配置
├── pubspec.yaml           # 项目依赖配置
└── README.md              # 项目说明文档
```

## 开发说明

### 颜色定义
```dart
static const Color _darkGray = Color(0xFF333333);    // 数字按钮
static const Color _lightGray = Color(0xFFA6A6A6);   // 功能按钮
static const Color _orange = Color(0xFFFF9500);      // 操作符按钮
static const Color _white = Colors.white;            // 文字颜色
static const Color _black = Colors.black;            // 背景颜色
```

### 按钮布局
- 竖屏：5行4列的传统计算器布局
- 横屏：5行10列的科学计算器布局

### 计算逻辑
- 使用`math_expressions`包解析和计算数学表达式
- 支持连续运算和复杂表达式
- 错误处理和边界情况处理

## CI/CD 自动化

### GitHub Actions 工作流
项目已配置完整的CI/CD工作流，支持：

- ✅ **自动构建**: 推送到`main`分支后自动构建所有平台
- ✅ **自动测试**: 运行单元测试确保代码质量
- ✅ **自动发布**: 创建GitHub Release并上传构建文件
- ✅ **多平台支持**: 同时构建Android、iOS、Web、Windows、macOS、Linux

### 构建状态
![Build Status](https://github.com/USERNAME/REPOSITORY/workflows/Build%20All%20Platforms/badge.svg)

### 使用自动构建
1. 推送代码到`main`分支
2. GitHub Actions自动开始构建
3. 构建完成后在Releases页面下载应用

详细说明请查看 [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md)

## 贡献指南

欢迎提交Issue和Pull Request来改进这个项目！

### 开发环境设置
1. 安装Flutter开发环境
2. Fork本项目
3. 创建功能分支
4. 提交更改
5. 创建Pull Request

## 许可证

本项目采用MIT许可证 - 查看[LICENSE](LICENSE)文件了解详情。

## 致谢

- 感谢Flutter团队提供优秀的跨平台框架
- 感谢Apple公司的iOS计算器设计灵感
- 感谢math_expressions包的作者提供数学计算支持
