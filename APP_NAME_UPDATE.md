# 应用名称更新说明

## 更新内容
将应用名称从"iOS风格计算器"/"calculator_app"更新为"嗷嗷算"。

## 已修改的文件

### 🎯 主应用配置
- **lib/main.dart**: 应用标题
- **pubspec.yaml**: 项目描述

### 📱 Android平台
- **android/app/src/main/AndroidManifest.xml**: 应用标签

### 🍎 iOS平台
- **ios/Runner/Info.plist**: 
  - CFBundleDisplayName (显示名称)
  - CFBundleName (包名称)

### 💻 macOS平台
- **macos/Runner/Configs/AppInfo.xcconfig**: PRODUCT_NAME

### 🪟 Windows平台
- **windows/runner/main.cpp**: 窗口标题
- **windows/runner/Runner.rc**: 
  - FileDescription
  - InternalName
  - ProductName

### 🐧 Linux平台
- **linux/my_application.cc**: 标题栏名称

### 🌐 Web平台
- **web/index.html**:
  - meta description
  - apple-mobile-web-app-title
  - title标签
- **web/manifest.json**:
  - name
  - short_name
  - description

## 显示效果

### 各平台显示名称
- **Android**: 嗷嗷算 (应用列表和标题栏)
- **iOS**: 嗷嗷算 (主屏幕和应用内)
- **macOS**: 嗷嗷算 (Dock和菜单栏)
- **Windows**: 嗷嗷算 (任务栏和窗口标题)
- **Linux**: 嗷嗷算 (窗口标题栏)
- **Web**: 嗷嗷算 (浏览器标签页和PWA)

### 应用描述
统一更新为："嗷嗷算 - 简洁好用的计算器应用"

## 验证方法

### 开发阶段验证
```bash
# 运行应用查看标题
flutter run

# 构建各平台应用
flutter build apk
flutter build ios
flutter build web
flutter build windows
flutter build macos
flutter build linux
```

### 各平台验证要点
- **Android**: 检查应用图标下方的名称
- **iOS**: 检查主屏幕图标名称
- **Desktop**: 检查窗口标题栏
- **Web**: 检查浏览器标签页标题

## 注意事项

### 保持不变的部分
- **包名/Bundle ID**: 保持原有标识符不变
- **可执行文件名**: Windows保持calculator_app.exe
- **项目目录名**: 保持calculator_app
- **Dart包名**: 保持calculator_app

### 构建后验证
建议在各平台构建后验证应用名称显示正确：
1. 安装/运行应用
2. 检查系统中显示的应用名称
3. 确认应用标题栏/窗口标题
4. 验证应用列表中的显示名称

## 相关文件更新
如需进一步自定义，可能还需要更新：
- 应用图标文件名 (如果希望保持一致)
- 文档中的应用名称引用
- GitHub Actions工作流中的构建文件名称

---
*更新时间: $(date +'%Y-%m-%d %H:%M:%S')* 