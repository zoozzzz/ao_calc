#!/bin/bash

echo "🔍 检查GitHub Actions工作流配置..."
echo "=================================="

# 检查工作流文件是否存在
if [ -f ".github/workflows/build-all-platforms.yml" ]; then
    echo "✅ 工作流文件已创建: .github/workflows/build-all-platforms.yml"
else
    echo "❌ 工作流文件不存在"
    exit 1
fi

# 检查Flutter项目配置
if [ -f "pubspec.yaml" ]; then
    echo "✅ Flutter项目配置存在: pubspec.yaml"
    
    # 获取项目版本
    VERSION=$(grep 'version:' pubspec.yaml | cut -d ' ' -f 2)
    echo "📝 当前版本: $VERSION"
else
    echo "❌ pubspec.yaml文件不存在"
    exit 1
fi

# 检查必要的平台目录
platforms=("android" "ios" "web" "windows" "macos" "linux")
echo ""
echo "🏗️  检查平台支持:"
for platform in "${platforms[@]}"; do
    if [ -d "$platform" ]; then
        echo "✅ $platform 平台已配置"
    else
        echo "⚠️  $platform 平台目录不存在"
    fi
done

# 检查Git仓库状态
echo ""
echo "📦 Git仓库状态:"
if [ -d ".git" ]; then
    echo "✅ Git仓库已初始化"
    
    # 检查当前分支
    current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
    echo "🌿 当前分支: $current_branch"
    
    # 检查是否有未提交的更改
    if git diff-index --quiet HEAD -- 2>/dev/null; then
        echo "✅ 工作区干净，无未提交更改"
    else
        echo "⚠️  有未提交的更改"
        echo "💡 提示: 提交更改后推送到main分支以触发自动构建"
    fi
else
    echo "❌ Git仓库未初始化"
fi

echo ""
echo "📋 使用说明:"
echo "1. 确保所有更改已提交到Git"
echo "2. 推送到main分支: git push origin main"
echo "3. 查看GitHub Actions页面监控构建进度"
echo "4. 构建完成后在Releases页面下载应用"
echo ""
echo "📖 详细文档:"
echo "- 工作流说明: GITHUB_ACTIONS_SETUP.md"
echo "- 图标设置: ICON_SETUP.md"
echo "- UI修复: LANDSCAPE_UI_FIX.md"
echo ""
echo "🎉 配置检查完成！" 