#!/bin/bash

echo "🔍 验证应用名称更新..."
echo "========================"

APP_NAME="嗷嗷算"
echo "目标应用名称: $APP_NAME"
echo ""

# 检查各平台配置文件
echo "📋 检查配置文件中的应用名称..."

files_to_check=(
    "lib/main.dart:title:"
    "pubspec.yaml:description:"
    "android/app/src/main/AndroidManifest.xml:android:label="
    "ios/Runner/Info.plist:CFBundleDisplayName"
    "ios/Runner/Info.plist:CFBundleName"
    "macos/Runner/Configs/AppInfo.xcconfig:PRODUCT_NAME"
    "windows/runner/main.cpp:Create"
    "windows/runner/Runner.rc:ProductName"
    "linux/my_application.cc:gtk_header_bar_set_title"
    "web/index.html:title"
    "web/manifest.json:name"
)

echo ""
echo "✅ 各平台配置检查结果:"

for item in "${files_to_check[@]}"; do
    file=$(echo $item | cut -d':' -f1)
    pattern=$(echo $item | cut -d':' -f2)
    
    if [ -f "$file" ]; then
        if grep -q "$APP_NAME" "$file" 2>/dev/null; then
            echo "   ✅ $file - 包含 '$APP_NAME'"
        else
            echo "   ⚠️  $file - 未找到 '$APP_NAME'"
            grep -n "$pattern" "$file" 2>/dev/null | head -1 | sed 's/^/      /'
        fi
    else
        echo "   ❌ $file - 文件不存在"
    fi
done

echo ""

# 检查构建产物（如果存在）
echo "🏗️  检查构建产物..."

if [ -f "build/web/index.html" ]; then
    if grep -q "$APP_NAME" "build/web/index.html"; then
        echo "   ✅ Web构建 - 标题正确"
    else
        echo "   ⚠️  Web构建 - 标题可能有问题"
    fi
else
    echo "   ℹ️  Web构建不存在 (运行 flutter build web 创建)"
fi

echo ""

# 统计更新情况
total_files=${#files_to_check[@]}
updated_count=0

for item in "${files_to_check[@]}"; do
    file=$(echo $item | cut -d':' -f1)
    if [ -f "$file" ] && grep -q "$APP_NAME" "$file" 2>/dev/null; then
        ((updated_count++))
    fi
done

echo "📊 更新统计:"
echo "   检查文件数: $total_files"
echo "   已更新: $updated_count"
echo "   更新率: $(( updated_count * 100 / total_files ))%"

echo ""

if [ $updated_count -eq $total_files ]; then
    echo "🎉 应用名称更新完成！"
    echo ""
    echo "📱 各平台显示效果:"
    echo "   Android: $APP_NAME (应用列表)"
    echo "   iOS: $APP_NAME (主屏幕)"
    echo "   macOS: $APP_NAME (Dock)"
    echo "   Windows: $APP_NAME (窗口标题)"
    echo "   Linux: $APP_NAME (标题栏)"
    echo "   Web: $APP_NAME (浏览器标签)"
    echo ""
    echo "🔄 验证建议:"
    echo "1. 运行应用: flutter run"
    echo "2. 检查窗口/标题栏显示"
    echo "3. 构建各平台验证: flutter build [platform]"
else
    echo "⚠️  还有 $(( total_files - updated_count )) 个文件需要检查"
fi

echo ""
echo "📝 说明文档: APP_NAME_UPDATE.md" 