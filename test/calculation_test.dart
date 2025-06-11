import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/main.dart';
import 'package:flutter/material.dart';

void main() {
  group('计算器运算逻辑测试', () {
    testWidgets('基本加法运算测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 测试 2 + 3 = 5
      await tester.tap(find.text('2').first);
      await tester.pump();
      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('3').first);
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      // 验证结果显示为5
      expect(find.text('5'), findsWidgets);
    });

    testWidgets('基本减法运算测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 测试 8 - 3 = 5
      await tester.tap(find.text('8').first);
      await tester.pump();
      await tester.tap(find.text('-'));
      await tester.pump();
      await tester.tap(find.text('3').first);
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('5'), findsWidgets);
    });

    testWidgets('基本乘法运算测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 测试 4 × 3 = 12
      await tester.tap(find.text('4').first);
      await tester.pump();
      await tester.tap(find.text('×'));
      await tester.pump();
      await tester.tap(find.text('3').first);
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('12'), findsWidgets);
    });

    testWidgets('基本除法运算测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 测试 15 ÷ 3 = 5
      await tester.tap(find.text('1').first);
      await tester.pump();
      await tester.tap(find.text('5').first);
      await tester.pump();
      await tester.tap(find.text('÷'));
      await tester.pump();
      await tester.tap(find.text('3').first);
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('5'), findsWidgets);
    });

    testWidgets('连续运算测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 测试 2 + 3 × 4 = 20 (应该是 (2+3) × 4)
      await tester.tap(find.text('2').first);
      await tester.pump();
      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('3').first);
      await tester.pump();
      await tester.tap(find.text('×'));
      await tester.pump();
      await tester.tap(find.text('4').first);
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('20'), findsWidgets);
    });

    testWidgets('小数运算测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 测试 1.5 + 2.5 = 4
      await tester.tap(find.text('1').first);
      await tester.pump();
      await tester.tap(find.text('.'));
      await tester.pump();
      await tester.tap(find.text('5').first);
      await tester.pump();
      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('2').first);
      await tester.pump();
      await tester.tap(find.text('.'));
      await tester.pump();
      await tester.tap(find.text('5').first);
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('4'), findsWidgets);
    });

    testWidgets('除零错误测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 测试 5 ÷ 0 = Error
      await tester.tap(find.text('5').first);
      await tester.pump();
      await tester.tap(find.text('÷'));
      await tester.pump();
      await tester.tap(find.text('0').first);
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('Error'), findsWidgets);
    });

    testWidgets('AC清除功能测试', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // 输入一些数字和运算符
      await tester.tap(find.text('1').first);
      await tester.pump();
      await tester.tap(find.text('2').first);
      await tester.pump();
      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('3').first);
      await tester.pump();

      // 点击AC清除
      await tester.tap(find.text('AC'));
      await tester.pump();

      // 验证显示回到0
      expect(find.text('0'), findsWidgets);
    });
  });
} 