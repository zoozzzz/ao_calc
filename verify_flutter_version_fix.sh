#!/bin/bash

# Flutter版本修复验证脚本

echo "🔍 验证Flutter版本修复..."
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

# 检查函数
check_item() {
    local description="$1"
    local command="$2"
    local expected="$3"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    echo -n "  ${description}... "
    
    if eval "$command" | grep -q "$expected"; then
        echo -e "${GREEN}✅ 通过${NC}"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        echo -e "${RED}❌ 失败${NC}"
        return 1
    fi
}

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

echo
echo "📋 1. 检查工作流配置文件..."
echo "----------------------------------------"

# 检查工作流文件是否存在
check_file ".github/workflows/build-all-platforms.yml" "flutter-version: '3.19.6'" "工作流文件存在且包含正确的Flutter版本"

# 检查所有Flutter版本配置
FLUTTER_VERSION_COUNT=$(grep -c "flutter-version: '3.19.6'" .github/workflows/build-all-platforms.yml 2>/dev/null || echo "0")
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
echo -n "  检查所有6个构建任务的Flutter版本... "
if [ "$FLUTTER_VERSION_COUNT" -eq 6 ]; then
    echo -e "${GREEN}✅ 通过 (找到6个)${NC}"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo -e "${RED}❌ 失败 (找到${FLUTTER_VERSION_COUNT}个，期望6个)${NC}"
fi

# 检查是否还有旧版本
OLD_VERSION_COUNT=$(grep -c "flutter-version: '3.16.0'" .github/workflows/build-all-platforms.yml 2>/dev/null || echo "0")
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
echo -n "  确认没有遗留的旧版本... "
if [ "${OLD_VERSION_COUNT}" -eq 0 ]; then
    echo -e "${GREEN}✅ 通过 (未找到旧版本)${NC}"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo -e "${RED}❌ 失败 (仍有${OLD_VERSION_COUNT}个旧版本)${NC}"
fi

echo
echo "📋 2. 检查项目配置..."
echo "----------------------------------------"

# 检查pubspec.yaml中的SDK版本要求
check_file "pubspec.yaml" "sdk: '>=3.2.6 <4.0.0'" "项目SDK版本要求配置正确"

echo
echo "📋 3. 检查各平台构建任务..."
echo "----------------------------------------"

# 检查各个构建任务的Flutter版本
check_file ".github/workflows/build-all-platforms.yml" "build-android:" "Android构建任务存在"
check_file ".github/workflows/build-all-platforms.yml" "build-ios:" "iOS构建任务存在"
check_file ".github/workflows/build-all-platforms.yml" "build-web:" "Web构建任务存在"
check_file ".github/workflows/build-all-platforms.yml" "build-windows:" "Windows构建任务存在"
check_file ".github/workflows/build-all-platforms.yml" "build-macos:" "macOS构建任务存在"
check_file ".github/workflows/build-all-platforms.yml" "build-linux:" "Linux构建任务存在"

echo
echo "📋 4. 版本兼容性检查..."
echo "----------------------------------------"

# 检查本地Flutter版本（如果可用）
if command -v flutter &> /dev/null; then
    LOCAL_VERSION=$(flutter --version | grep "Flutter" | awk '{print $2}' | head -1)
    echo "  本地Flutter版本: ${BLUE}${LOCAL_VERSION}${NC}"
    
    # 检查本地版本是否足够新
    if [ -n "$LOCAL_VERSION" ]; then
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
        echo -n "  本地版本满足SDK要求... "
        # 简单的版本比较（假设格式为x.y.z）
        MAJOR=$(echo "$LOCAL_VERSION" | cut -d. -f1)
        MINOR=$(echo "$LOCAL_VERSION" | cut -d. -f2)
        if [ "$MAJOR" -gt 3 ] || ([ "$MAJOR" -eq 3 ] && [ "$MINOR" -ge 19 ]); then
            echo -e "${GREEN}✅ 通过${NC}"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
        else
            echo -e "${YELLOW}⚠️  建议升级到3.19.6+${NC}"
        fi
    fi
else
    echo "  ${YELLOW}⚠️  本地未安装Flutter或不在PATH中${NC}"
fi

echo
echo "📋 5. 文档和脚本检查..."
echo "----------------------------------------"

check_file "FLUTTER_VERSION_FIX.md" "Flutter版本修复说明" "修复说明文档已创建"
check_file "verify_flutter_version_fix.sh" "Flutter版本修复验证脚本" "验证脚本已创建"

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
    echo -e "${GREEN}🎉 所有检查都通过了！Flutter版本修复成功！${NC}"
    echo
    echo "✅ GitHub Actions现在使用Flutter 3.19.6 (Dart SDK 3.3.4)"
    echo "✅ 满足项目的Dart SDK >= 3.2.6要求"
    echo "✅ 所有6个平台的构建任务都已更新"
    echo
    echo "🚀 下一步建议："
    echo "   1. 提交并推送更改到GitHub"
    echo "   2. 监控GitHub Actions构建状态"
    echo "   3. 确认所有平台构建成功"
    echo
elif [ $SUCCESS_RATE -ge 80 ]; then
    echo -e "${YELLOW}⚠️  大部分检查通过，但有几个问题需要注意${NC}"
    echo "   请检查上面标记为❌的项目"
else
    echo -e "${RED}❌ 发现多个问题，需要进一步检查和修复${NC}"
    echo "   请检查上面标记为❌的项目"
fi

echo
echo "📝 详细信息请查看: FLUTTER_VERSION_FIX.md"
echo "========================================" 