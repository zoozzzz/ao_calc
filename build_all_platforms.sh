#!/bin/bash

echo "🚀 开始构建iOS风格Flutter计算器的所有平台版本..."

# 确保依赖已安装
echo "📦 安装依赖..."
flutter pub get

# 运行测试
echo "🧪 运行测试..."
flutter test

# 构建Android版本
echo "🤖 构建Android APK..."
flutter build apk --release
echo "✅ Android APK构建完成: build/app/outputs/flutter-apk/app-release.apk"

# 构建Web版本
echo "🌐 构建Web版本..."
flutter build web --release
echo "✅ Web版本构建完成: build/web/"

# 如果在macOS上，构建iOS和macOS版本
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 构建iOS版本..."
    flutter build ios --release --no-codesign
    echo "✅ iOS版本构建完成"
    
    echo "💻 构建macOS版本..."
    flutter build macos --release
    echo "✅ macOS版本构建完成: build/macos/Build/Products/Release/"
fi

# 如果在Linux上，构建Linux版本
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 构建Linux版本..."
    flutter build linux --release
    echo "✅ Linux版本构建完成: build/linux/x64/release/bundle/"
fi

# 如果在Windows上，构建Windows版本
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "🪟 构建Windows版本..."
    flutter build windows --release
    echo "✅ Windows版本构建完成: build/windows/runner/Release/"
fi

echo "🎉 所有可用平台的构建已完成！"
echo ""
echo "📱 支持的平台："
echo "  - Android: APK文件"
echo "  - iOS: 需要Xcode进行最终打包"
echo "  - Web: 可直接部署到Web服务器"
echo "  - macOS: 原生macOS应用"
echo "  - Windows: 原生Windows应用"
echo "  - Linux: 原生Linux应用"
echo ""
echo "🎨 特性："
echo "  - 完全仿照iOS计算器的UI设计"
echo "  - 支持基础和科学计算功能"
echo "  - 响应式设计，支持横竖屏切换"
echo "  - 跨平台兼容" 