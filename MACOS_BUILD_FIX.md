# macOS构建问题修复说明

## 问题描述
GitHub Actions macOS构建失败，错误信息：
```
zip warning: name not matched: calculator_app.app
zip error: Nothing to do! (try: zip -r Calculator-macOS.zip . -i calculator_app.app)
Error: Process completed with exit code 12.
```

## 问题原因
在更改应用名称为"嗷嗷算"后，macOS构建输出的应用程序包名称发生了变化：
- **之前**: `calculator_app.app`  
- **现在**: `嗷嗷算.app`

但GitHub Actions工作流中仍然使用旧的文件名进行打包。

## 解决方案

### 1. 修复macOS构建脚本
**文件**: `.github/workflows/build-all-platforms.yml`

```yaml
# 修改前
- name: Create macOS ZIP
  run: |
    cd build/macos/Build/Products/Release
    zip -r Calculator-macOS.zip calculator_app.app

# 修改后
- name: Create macOS ZIP
  run: |
    cd build/macos/Build/Products/Release
    zip -r Calculator-macOS.zip 嗷嗷算.app
```

### 2. 修复Linux标题不一致问题
**文件**: `linux/my_application.cc`

发现Linux应用在不同窗口管理器下标题不一致：
```cpp
// 修改前
} else {
  gtk_window_set_title(window, "calculator_app");
}

// 修改后  
} else {
  gtk_window_set_title(window, "嗷嗷算");
}
```

## 根本原因分析

### 应用名称配置层级
1. **Flutter应用名称** (`lib/main.dart`): "嗷嗷算"
2. **包配置** (`pubspec.yaml`): name仍为calculator_app
3. **平台特定配置**:
   - **Android**: `android/app/src/main/AndroidManifest.xml` ✅
   - **iOS**: `ios/Runner/Info.plist` ✅  
   - **macOS**: `macos/Runner/Configs/AppInfo.xcconfig` ✅
   - **Windows**: `windows/runner/main.cpp` ✅
   - **Linux**: `linux/my_application.cc` ✅ (现已修复)
   - **Web**: `web/index.html`, `web/manifest.json` ✅

### 构建产物命名规则
| 平台 | 配置文件控制 | 构建产物名称 | 工作流中的名称 |
|------|-------------|-------------|----------------|
| Android | AndroidManifest.xml | app-release.apk | ✅ 正确 |
| iOS | Info.plist | Runner.app | ✅ 正确 |
| macOS | AppInfo.xcconfig | **嗷嗷算.app** | ✅ 已修复 |
| Windows | CMakeLists.txt/项目名 | calculator_app.exe | ✅ 正确 |
| Linux | 项目名 | calculator_app | ✅ 正确 |
| Web | 静态文件 | build/web/* | ✅ 正确 |

## 验证方法

### 本地验证
```bash
# 构建macOS版本
flutter build macos --release

# 检查构建产物
ls -la build/macos/Build/Products/Release/
# 应该看到: 嗷嗷算.app

# 测试Linux标题
flutter build linux --release
./build/linux/x64/release/bundle/calculator_app
# 应该看到窗口标题为"嗷嗷算"
```

### CI/CD验证
1. 推送更改到GitHub
2. 监控macOS构建任务
3. 确认zip命令成功执行
4. 检查构建产物是否正确上传

## 影响范围

### 已修复的问题
- ✅ macOS构建zip打包失败
- ✅ Linux应用标题不一致

### 无需修改的平台
- ✅ **Android**: 使用包名，不受应用显示名称影响
- ✅ **iOS**: 构建产物固定为Runner.app
- ✅ **Windows**: 执行文件名基于项目名calculator_app
- ✅ **Web**: 静态文件构建，无执行文件名问题

## 预期效果

### 构建流程
- ✅ 所有平台构建成功完成
- ✅ macOS zip打包正常工作
- ✅ 构建产物正确上传到Release

### 用户体验
- ✅ 所有平台显示统一的应用名称"嗷嗷算"
- ✅ macOS应用程序包可以正常下载使用
- ✅ Linux应用在所有窗口管理器下标题一致

## 注意事项

### 中文文件名处理
- macOS和Linux系统都支持UTF-8中文文件名
- zip/tar工具正确处理中文字符
- 下载后的文件名保持中文显示

### 跨平台兼容性
- 在Windows系统下载macOS构建时，中文文件名显示正常
- 在不同操作系统间传输文件时保持编码一致

---
*修复时间: $(date +'%Y-%m-%d %H:%M:%S')*
*影响文件: .github/workflows/build-all-platforms.yml, linux/my_application.cc* 