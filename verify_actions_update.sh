#!/bin/bash

echo "🔍 验证GitHub Actions版本更新..."
echo "================================"

WORKFLOW_FILE=".github/workflows/build-all-platforms.yml"

if [ ! -f "$WORKFLOW_FILE" ]; then
    echo "❌ 工作流文件不存在: $WORKFLOW_FILE"
    exit 1
fi

echo "📋 检查Actions版本..."
echo ""

# 检查已更新的Actions
echo "✅ 已更新到v4的Actions:"
grep -n "checkout@v4\|setup-java@v4\|upload-artifact@v4\|download-artifact@v4" "$WORKFLOW_FILE" | while read line; do
    echo "   $line"
done

echo ""

# 检查是否还有v3版本
echo "⚠️  检查是否还有v3版本:"
v3_count=$(grep -c "@v3" "$WORKFLOW_FILE" 2>/dev/null || echo "0")
if [ "$v3_count" -eq 0 ]; then
    echo "   ✅ 无v3版本Actions"
else
    echo "   ❌ 发现 $v3_count 个v3版本Actions:"
    grep -n "@v3" "$WORKFLOW_FILE"
fi

echo ""

# 检查其他版本的Actions (v1和v2)
echo "📍 其他版本的Actions:"
echo "   v1版本 (release相关，暂时保持):"
grep -n "@v1" "$WORKFLOW_FILE" | head -3 | while read line; do
    echo "     $line"
done

echo "   v2版本 (Flutter Action，最新稳定版):"
grep -n "flutter-action@v2" "$WORKFLOW_FILE" | head -1 | while read line; do
    echo "     $line"
done

echo ""

# 统计更新情况
total_actions=$(grep -c "uses:" "$WORKFLOW_FILE")
v4_actions=$(grep -c "@v4" "$WORKFLOW_FILE")
v3_actions=$(grep -c "@v3" "$WORKFLOW_FILE")
v2_actions=$(grep -c "@v2" "$WORKFLOW_FILE")
v1_actions=$(grep -c "@v1" "$WORKFLOW_FILE")

echo "📊 Actions版本统计:"
echo "   总计: $total_actions 个Actions"
echo "   v4版本: $v4_actions 个 (主要Actions)"
echo "   v3版本: $v3_actions 个 (应为0)"
echo "   v2版本: $v2_actions 个 (Flutter Action)"
echo "   v1版本: $v1_actions 个 (Release Actions)"

echo ""

if [ "$v3_actions" -eq 0 ]; then
    echo "🎉 更新成功！"
    echo "✅ 所有主要Actions都已升级到v4"
    echo "✅ 解决了upload-artifact@v3弃用问题"
    echo ""
    echo "📝 下一步操作:"
    echo "1. 提交更改: git add . && git commit -m 'Update GitHub Actions to v4'"
    echo "2. 推送到远程: git push origin main"
    echo "3. 监控构建状态"
else
    echo "⚠️  还需要更新 $v3_actions 个v3版本的Actions"
fi 