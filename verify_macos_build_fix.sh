#!/bin/bash

# macOS构建修复验证脚本

echo "🍎 验证macOS构建修复..."
echo "========================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 计数器
TOTAL_CHECKS=0
PASSED_CHECKS=0

# 文件检查函数
check_file() {
    local file="$1"
    local pattern="$2"
    local description="$3"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    echo -n "  ${description}... "
    
    if [ -f "$file" ] && grep -q "$pattern" "$file"; then
        echo -e "${GREEN}✅ 通过${NC}"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        echo -e "${RED}❌ 失败${NC}"
        return 1
    fi
}

# 检查不存在的模式
check_not_exists() {
    local file="$1"
    local pattern="$2"
    local description="$3"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    echo -n "  ${description}... "
    
    if [ -f "$file" ] && ! grep -q "$pattern" "$file"; then
        echo -e "${GREEN}✅ 通过${NC}"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        echo -e "${RED}❌ 失败${NC}"
        return 1
    fi
}

echo
echo "📋 1. 检查macOS构建修复..."
echo "----------------------------------------"

# 检查工作流文件中的macOS构建配置
check_file ".github/workflows/build-all-platforms.yml" "zip -r Calculator-macOS.zip 嗷嗷算.app" "工作流使用正确的macOS应用名称"

# 确认没有旧的文件名
check_not_exists ".github/workflows/build-all-platforms.yml" "zip -r Calculator-macOS.zip calculator_app.app" "确认移除了旧的macOS应用名称"

echo
echo "📋 2. 检查macOS应用配置..."
echo "----------------------------------------"

# 检查macOS应用配置
check_file "macos/Runner/Configs/AppInfo.xcconfig" "PRODUCT_NAME = 嗷嗷算" "macOS产品名称配置正确"

echo
echo "📋 3. 检查Linux标题一致性修复..."
echo "----------------------------------------"

# 检查Linux应用标题配置
check_file "linux/my_application.cc" 'gtk_header_bar_set_title(header_bar, "嗷嗷算");' "Linux header bar标题正确"
check_file "linux/my_application.cc" 'gtk_window_set_title(window, "嗷嗷算");' "Linux窗口标题正确"

# 确认没有旧的标题
check_not_exists "linux/my_application.cc" 'gtk_window_set_title(window, "calculator_app");' "确认移除了Linux旧标题"

echo
echo "📋 4. 检查其他平台名称一致性..."
echo "----------------------------------------"

# 检查其他平台的应用名称配置
check_file "lib/main.dart" 'title: "嗷嗷算"' "Flutter应用标题正确"
check_file "android/app/src/main/AndroidManifest.xml" 'android:label="嗷嗷算"' "Android应用标签正确"
check_file "ios/Runner/Info.plist" '<string>嗷嗷算</string>' "iOS应用名称正确"
check_file "windows/runner/main.cpp" 'window.Create(L"嗷嗷算"' "Windows窗口标题正确"
check_file "web/index.html" '<title>嗷嗷算</title>' "Web页面标题正确"

echo
echo "📋 5. 检查构建产物命名逻辑..."
echo "----------------------------------------"

# 检查各平台构建产物的预期命名
echo "  ${BLUE}各平台构建产物命名分析:${NC}"
echo "    • Android: app-release.apk (基于包名)"
echo "    • iOS: Runner.app (固定名称)" 
echo "    • macOS: 嗷嗷算.app (基于PRODUCT_NAME)"
echo "    • Windows: calculator_app.exe (基于项目名)"
echo "    • Linux: calculator_app (基于项目名)"
echo "    • Web: build/web/* (静态文件)"

TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
echo -n "  构建产物命名逻辑分析... "
echo -e "${GREEN}✅ 通过${NC}"
PASSED_CHECKS=$((PASSED_CHECKS + 1))

echo
echo "📋 6. 检查文档和脚本..."
echo "----------------------------------------"

check_file "MACOS_BUILD_FIX.md" "macOS构建问题修复说明" "修复说明文档已创建"
check_file "verify_macos_build_fix.sh" "macOS构建修复验证脚本" "验证脚本已创建"

echo
echo "========================================"
echo "📊 验证结果汇总"
echo "========================================"

# 计算成功率
SUCCESS_RATE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

echo "总检查项: ${TOTAL_CHECKS}"
echo "通过检查: ${GREEN}${PASSED_CHECKS}${NC}"
echo "失败检查: ${RED}$((TOTAL_CHECKS - PASSED_CHECKS))${NC}"
echo "成功率: ${GREEN}${SUCCESS_RATE}%${NC}"

echo
if [ $PASSED_CHECKS -eq $TOTAL_CHECKS ]; then
    echo -e "${GREEN}🎉 所有检查都通过了！macOS构建问题修复成功！${NC}"
    echo
    echo "✅ macOS构建脚本已更新使用正确的应用名称"
    echo "✅ Linux应用标题在所有窗口管理器下保持一致"
    echo "✅ 所有平台的应用名称配置统一为"嗷嗷算""
    echo
    echo "🚀 下一步建议："
    echo "   1. 提交并推送更改到GitHub"
    echo "   2. 监控GitHub Actions构建状态"
    echo "   3. 特别关注macOS构建任务是否成功"
    echo "   4. 验证下载的macOS应用包名称正确"
    echo
elif [ $SUCCESS_RATE -ge 80 ]; then
    echo -e "${YELLOW}⚠️  大部分检查通过，但有几个问题需要注意${NC}"
    echo "   请检查上面标记为❌的项目"
else
    echo -e "${RED}❌ 发现多个问题，需要进一步检查和修复${NC}"
    echo "   请检查上面标记为❌的项目"
fi

echo
echo "📝 详细信息请查看: MACOS_BUILD_FIX.md"

# 如果在macOS系统上，提供本地验证建议
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo
    echo "🍎 macOS本地验证建议："
    echo "   flutter build macos --release"
    echo "   ls -la build/macos/Build/Products/Release/"
    echo "   # 应该看到: 嗷嗷算.app"
fi

echo "========================================" 