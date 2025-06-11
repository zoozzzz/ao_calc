# GitHub Actions 自动构建工作流

## 概述
已为项目配置了完整的GitHub Actions工作流，当代码推送到`main`分支时，会自动构建所有平台的应用并创建Release。

## 工作流功能

### 🔧 自动构建平台
- ✅ **Android** - 构建APK和AAB文件
- ✅ **iOS** - 构建IPA文件（无签名版本）
- ✅ **Web** - 构建静态网页版本
- ✅ **Windows** - 构建Windows可执行程序
- ✅ **macOS** - 构建macOS应用程序包
- ✅ **Linux** - 构建Linux可执行程序

### 🚀 自动发布
- 自动创建GitHub Release
- 上传所有平台的构建文件
- 生成详细的发布说明
- 包含版本信息和使用说明

## 工作流触发条件

### 推送到main分支
```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
```

- 推送到`main`分支：执行所有构建并创建Release
- 创建Pull Request：仅执行构建测试，不创建Release

## 构建环境

### Android
- 运行环境: `ubuntu-latest`
- Java版本: 11 (Zulu发行版)
- Flutter版本: 3.16.0 (稳定版)

### iOS
- 运行环境: `macos-latest`
- 构建方式: 无代码签名构建
- 输出格式: IPA文件

### Web
- 运行环境: `ubuntu-latest`
- 构建命令: `flutter build web --release`
- 输出格式: 静态网页文件

### Windows
- 运行环境: `windows-latest`
- 构建命令: `flutter build windows --release`
- 打包方式: ZIP压缩包

### macOS
- 运行环境: `macos-latest`
- 构建命令: `flutter build macos --release`
- 打包方式: ZIP压缩包

### Linux
- 运行环境: `ubuntu-latest`
- 依赖包: `clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev`
- 打包方式: TAR.GZ压缩包

## 使用方法

### 1. 启用GitHub Actions
确保仓库已启用GitHub Actions功能。

### 2. 推送代码
将代码推送到`main`分支：
```bash
git add .
git commit -m "Add new features"
git push origin main
```

### 3. 查看构建状态
在GitHub仓库的"Actions"标签页查看构建进度。

### 4. 下载构建文件
构建完成后，可以：
- 在"Actions"页面下载构建产物（Artifacts）
- 在"Releases"页面下载发布版本

## 发布文件说明

### Android文件
- `Calculator-Android.apk` - Android安装包
- `Calculator-Android.aab` - Google Play发布包

### iOS文件
- `Calculator-iOS.ipa` - iOS安装包（需要重新签名）

### Web文件
- `Calculator-Web.zip` - Web版本（解压后部署到Web服务器）

### Desktop文件
- `Calculator-Windows.zip` - Windows版本
- `Calculator-macOS.zip` - macOS版本
- `Calculator-Linux.tar.gz` - Linux版本

## 自定义配置

### 修改Flutter版本
在工作流文件中修改：
```yaml
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.16.0'  # 修改为所需版本
    channel: 'stable'
```

### 修改触发条件
```yaml
on:
  push:
    branches: [ main, develop ]  # 添加其他分支
    tags: [ 'v*' ]               # 添加标签触发
```

### 添加测试步骤
已包含测试步骤：
```yaml
- run: flutter test
```

## 注意事项

### iOS签名
- 构建的iOS应用未签名，需要开发者证书重新签名
- 适用于企业发布或内部测试

### 权限要求
- 需要仓库的`GITHUB_TOKEN`权限
- 无需额外配置，GitHub自动提供

### 构建时间
- 全平台构建约需15-30分钟
- 可以并行构建，节省时间

### 存储空间
- 构建产物会占用GitHub Actions存储空间
- 建议定期清理旧的构建文件

## 故障排除

### 构建失败
1. 检查Flutter版本兼容性
2. 确认依赖包版本
3. 查看构建日志确定错误原因

### 发布失败
1. 确认推送到正确分支
2. 检查`GITHUB_TOKEN`权限
3. 确认Release标签格式

### 文件缺失
1. 确认构建成功完成
2. 检查文件路径配置
3. 查看Artifacts是否正确上传

## 高级用法

### 条件构建
可以配置只构建特定平台：
```yaml
strategy:
  matrix:
    platform: [android, ios, web]
```

### 缓存优化
添加Flutter缓存以加速构建：
```yaml
- uses: actions/cache@v3
  with:
    path: ~/.pub-cache
    key: ${{ runner.os }}-pub-cache-${{ hashFiles('**/pubspec.lock') }}
```

### 通知集成
添加构建完成通知：
```yaml
- name: Notify
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
``` 