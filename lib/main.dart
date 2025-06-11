import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS风格计算器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  String _previousOperand = '';
  String _operator = '';
  bool _waitingForOperand = false;
  bool _isScientific = false;
  bool _isPortrait = true;

  // 颜色定义 - iOS风格
  static const Color _darkGray = Color(0xFF333333);
  static const Color _lightGray = Color(0xFFA6A6A6);
  static const Color _orange = Color(0xFFFF9500);
  static const Color _white = Colors.white;
  static const Color _black = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            _isPortrait = orientation == Orientation.portrait;
            return Column(
              children: [
                // 显示屏区域
                Expanded(
                  flex: _isPortrait ? 2 : 1,
                  child: _buildDisplay(),
                ),
                // 按钮区域
                Expanded(
                  flex: _isPortrait ? 3 : 2,
                  child: _isPortrait ? _buildPortraitButtons() : _buildLandscapeButtons(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_expression.isNotEmpty)
            Text(
              _expression,
              style: const TextStyle(
                color: _lightGray,
                fontSize: 20,
              ),
              textAlign: TextAlign.right,
            ),
          const SizedBox(height: 10),
          Text(
            _display,
            style: const TextStyle(
              color: _white,
              fontSize: 60,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitButtons() {
    return Column(
      children: [
        _buildButtonRow(['AC', '±', '%', '÷']),
        _buildButtonRow(['7', '8', '9', '×']),
        _buildButtonRow(['4', '5', '6', '-']),
        _buildButtonRow(['1', '2', '3', '+']),
        _buildButtonRow(['0', '', '.', '=']),
      ],
    );
  }

  Widget _buildLandscapeButtons() {
    return Column(
      children: [
        _buildButtonRow(['(', ')', 'mc', 'm+', 'm-', 'mr', 'AC', '±', '%', '÷']),
        _buildButtonRow(['2nd', 'x²', 'x³', 'xʸ', 'eˣ', '10ˣ', '7', '8', '9', '×']),
        _buildButtonRow(['1/x', '²√x', '³√x', 'ʸ√x', 'ln', 'log₁₀', '4', '5', '6', '-']),
        _buildButtonRow(['x!', 'sin', 'cos', 'tan', 'e', 'EE', '1', '2', '3', '+']),
        _buildButtonRow(['Rad', 'sinh', 'cosh', 'tanh', 'π', 'Rand', '0', '', '.', '=']),
      ],
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((button) {
          if (button.isEmpty) {
            return const Expanded(child: SizedBox());
          }
          return _buildButton(button);
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String text) {
    Color backgroundColor;
    Color textColor;
    int flex = 1;

    // 确定按钮颜色和样式
    if (text == 'AC' || text == '±' || text == '%') {
      backgroundColor = _lightGray;
      textColor = _black;
    } else if (text == '÷' || text == '×' || text == '-' || text == '+' || text == '=') {
      backgroundColor = _orange;
      textColor = _white;
    } else if (text == '0') {
      backgroundColor = _darkGray;
      textColor = _white;
      flex = 2; // 0按钮占两个位置
    } else {
      backgroundColor = _darkGray;
      textColor = _white;
    }

    // 科学计算器按钮颜色
    if (!_isPortrait && _isScientificButton(text)) {
      backgroundColor = _darkGray;
      textColor = _white;
    }

    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(1),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            shape: text == '0' && _isPortrait
                ? const StadiumBorder()
                : const CircleBorder(),
            padding: EdgeInsets.zero,
            elevation: 0,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: text == '0' && _isPortrait
                ? Alignment.centerLeft
                : Alignment.center,
            padding: text == '0' && _isPortrait
                ? const EdgeInsets.only(left: 35)
                : EdgeInsets.zero,
            child: Text(
              text,
              style: TextStyle(
                fontSize: _isPortrait ? 30 : 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isScientificButton(String text) {
    const scientificButtons = [
      '(', ')', 'mc', 'm+', 'm-', 'mr', '2nd', 'x²', 'x³', 'xʸ', 'eˣ', '10ˣ',
      '1/x', '²√x', '³√x', 'ʸ√x', 'ln', 'log₁₀', 'x!', 'sin', 'cos', 'tan',
      'e', 'EE', 'Rad', 'sinh', 'cosh', 'tanh', 'π', 'Rand'
    ];
    return scientificButtons.contains(text);
  }

  void _onButtonPressed(String buttonText) {
    setState(() {
      switch (buttonText) {
        case 'AC':
          _display = '0';
          _expression = '';
          _previousOperand = '';
          _operator = '';
          _waitingForOperand = false;
          break;
        case '±':
          if (_display != '0') {
            if (_display.startsWith('-')) {
              _display = _display.substring(1);
            } else {
              _display = '-$_display';
            }
          }
          break;
        case '%':
          _calculatePercentage();
          break;
        case '=':
          _calculateResult();
          break;
        case '.':
          if (_waitingForOperand) {
            _display = '0.';
            _waitingForOperand = false;
          } else if (!_display.contains('.')) {
            _display += '.';
          }
          break;
        case '÷':
        case '×':
        case '-':
        case '+':
          _handleOperator(buttonText);
          break;
        // 科学计算器功能
        case 'sin':
          _calculateTrigonometric('sin');
          break;
        case 'cos':
          _calculateTrigonometric('cos');
          break;
        case 'tan':
          _calculateTrigonometric('tan');
          break;
        case 'ln':
          _calculateLogarithm('ln');
          break;
        case 'log₁₀':
          _calculateLogarithm('log');
          break;
        case 'x²':
          _calculatePower(2);
          break;
        case 'x³':
          _calculatePower(3);
          break;
        case '²√x':
          _calculateRoot(2);
          break;
        case '³√x':
          _calculateRoot(3);
          break;
        case 'x!':
          _calculateFactorial();
          break;
        case 'π':
          _display = math.pi.toString();
          _waitingForOperand = false;
          break;
        case 'e':
          _display = math.e.toString();
          _waitingForOperand = false;
          break;
        case 'Rand':
          _display = math.Random().nextDouble().toString();
          _waitingForOperand = false;
          break;
        case '1/x':
          _calculateReciprocal();
          break;
        default:
          _handleNumber(buttonText);
      }
    });
  }

  void _handleNumber(String number) {
    if (_waitingForOperand) {
      _display = number;
      _waitingForOperand = false;
    } else {
      if (_display == '0') {
        _display = number;
      } else {
        _display += number;
      }
    }
  }

  void _handleOperator(String operator) {
    double inputValue = double.parse(_display);

    if (_previousOperand.isEmpty) {
      _previousOperand = inputValue.toString();
    } else if (_operator.isNotEmpty && !_waitingForOperand) {
      double previousValue = double.parse(_previousOperand);
      double result = _performCalculation(previousValue, inputValue, _operator);
      
      _display = _formatResult(result);
      _previousOperand = result.toString();
    }

    _waitingForOperand = true;
    _operator = operator;
    _expression = _previousOperand + ' ' + operator + ' ';
  }

  double _performCalculation(double firstOperand, double secondOperand, String operator) {
    switch (operator) {
      case '+':
        return firstOperand + secondOperand;
      case '-':
        return firstOperand - secondOperand;
      case '×':
        return firstOperand * secondOperand;
      case '÷':
        if (secondOperand == 0) {
          throw Exception('Division by zero');
        }
        return firstOperand / secondOperand;
      default:
        return secondOperand;
    }
  }

  void _calculateResult() {
    if (_operator.isNotEmpty && _previousOperand.isNotEmpty && !_waitingForOperand) {
      try {
        double previousValue = double.parse(_previousOperand);
        double currentValue = double.parse(_display);
        double result = _performCalculation(previousValue, currentValue, _operator);
        
        _display = _formatResult(result);
        _expression = '';
        _previousOperand = '';
        _operator = '';
        _waitingForOperand = true;
      } catch (e) {
        _display = 'Error';
        _expression = '';
        _previousOperand = '';
        _operator = '';
        _waitingForOperand = false;
      }
    }
  }

  void _calculatePercentage() {
    try {
      double value = double.parse(_display);
      _display = _formatResult(value / 100);
    } catch (e) {
      _display = 'Error';
    }
  }

  void _calculateTrigonometric(String function) {
    try {
      double value = double.parse(_display);
      double radians = value * (math.pi / 180); // 转换为弧度
      double result;
      
      switch (function) {
        case 'sin':
          result = math.sin(radians);
          break;
        case 'cos':
          result = math.cos(radians);
          break;
        case 'tan':
          result = math.tan(radians);
          break;
        default:
          return;
      }
      
      _display = _formatResult(result);
    } catch (e) {
      _display = 'Error';
    }
  }

  void _calculateLogarithm(String function) {
    try {
      double value = double.parse(_display);
      if (value <= 0) {
        _display = 'Error';
        return;
      }
      
      double result;
      switch (function) {
        case 'ln':
          result = math.log(value);
          break;
        case 'log':
          result = math.log(value) / math.log(10);
          break;
        default:
          return;
      }
      
      _display = _formatResult(result);
    } catch (e) {
      _display = 'Error';
    }
  }

  void _calculatePower(int power) {
    try {
      double value = double.parse(_display);
      double result = math.pow(value, power).toDouble();
      _display = _formatResult(result);
    } catch (e) {
      _display = 'Error';
    }
  }

  void _calculateRoot(int root) {
    try {
      double value = double.parse(_display);
      if (value < 0 && root % 2 == 0) {
        _display = 'Error';
        return;
      }
      
      double result = math.pow(value, 1.0 / root).toDouble();
      _display = _formatResult(result);
    } catch (e) {
      _display = 'Error';
    }
  }

  void _calculateFactorial() {
    try {
      int value = int.parse(_display);
      if (value < 0) {
        _display = 'Error';
        return;
      }
      
      int result = 1;
      for (int i = 1; i <= value; i++) {
        result *= i;
      }
      
      _display = result.toString();
    } catch (e) {
      _display = 'Error';
    }
  }

  void _calculateReciprocal() {
    try {
      double value = double.parse(_display);
      if (value == 0) {
        _display = 'Error';
        return;
      }
      
      double result = 1 / value;
      _display = _formatResult(result);
    } catch (e) {
      _display = 'Error';
    }
  }

  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toString();
    }
  }
}
