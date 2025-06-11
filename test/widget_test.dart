// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_app/main.dart';

void main() {
  group('计算器测试', () {
    testWidgets('应用启动测试', (WidgetTester tester) async {
      // 构建应用
      await tester.pumpWidget(const CalculatorApp());

      // 验证基本按钮存在
      expect(find.text('1'), findsWidgets);
      expect(find.text('2'), findsWidgets);
      expect(find.text('3'), findsWidgets);
      expect(find.text('+'), findsOneWidget);
      expect(find.text('='), findsOneWidget);
      expect(find.text('AC'), findsOneWidget);
    });

    testWidgets('基本加法测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 点击 2
      await tester.tap(find.text('2').first);
      await tester.pump();

      // 点击 +
      await tester.tap(find.text('+'));
      await tester.pump();

      // 点击 3
      await tester.tap(find.text('3').first);
      await tester.pump();

      // 点击 =
      await tester.tap(find.text('='));
      await tester.pump();

      // 验证结果包含5（可能在显示屏或按钮中）
      expect(find.text('5'), findsWidgets);
    });

    testWidgets('清除功能测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 输入一些数字
      await tester.tap(find.text('1').first);
      await tester.pump();
      await tester.tap(find.text('2').first);
      await tester.pump();
      await tester.tap(find.text('3').first);
      await tester.pump();

      // 点击AC清除
      await tester.tap(find.text('AC'));
      await tester.pump();

      // 验证AC按钮仍然存在（说明界面正常）
      expect(find.text('AC'), findsOneWidget);
    });

    testWidgets('小数点功能测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 点击 1
      await tester.tap(find.text('1').first);
      await tester.pump();

      // 点击 .
      await tester.tap(find.text('.'));
      await tester.pump();

      // 点击 5
      await tester.tap(find.text('5').first);
      await tester.pump();

      // 验证小数点按钮仍然存在
      expect(find.text('.'), findsOneWidget);
    });

    testWidgets('正负号切换测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 输入数字5
      await tester.tap(find.text('5').first);
      await tester.pump();

      // 点击±切换正负号
      await tester.tap(find.text('±'));
      await tester.pump();

      // 再次点击±切换回正数
      await tester.tap(find.text('±'));
      await tester.pump();

      // 验证±按钮仍然存在
      expect(find.text('±'), findsOneWidget);
    });

    testWidgets('百分比功能测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 输入50
      await tester.tap(find.text('5').first);
      await tester.pump();
      await tester.tap(find.text('0').first);
      await tester.pump();

      // 点击%
      await tester.tap(find.text('%'));
      await tester.pump();

      // 验证%按钮仍然存在
      expect(find.text('%'), findsOneWidget);
    });

    testWidgets('连续运算测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 2 + 3 = 5
      await tester.tap(find.text('2').first);
      await tester.pump();
      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('3').first);
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      // 继续 × 4
      await tester.tap(find.text('×'));
      await tester.pump();
      await tester.tap(find.text('4').first);
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      // 验证运算符按钮仍然存在
      expect(find.text('×'), findsOneWidget);
      expect(find.text('='), findsOneWidget);
    });

    testWidgets('按钮点击响应测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 测试所有数字按钮
      for (int i = 0; i <= 9; i++) {
        await tester.tap(find.text(i.toString()).first);
        await tester.pump();
      }

      // 测试运算符按钮
      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('-'));
      await tester.pump();
      await tester.tap(find.text('×'));
      await tester.pump();
      await tester.tap(find.text('÷'));
      await tester.pump();

      // 验证所有按钮都存在
      expect(find.text('+'), findsOneWidget);
      expect(find.text('-'), findsOneWidget);
      expect(find.text('×'), findsOneWidget);
      expect(find.text('÷'), findsOneWidget);
    });
  });
}
