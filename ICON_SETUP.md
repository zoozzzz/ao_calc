# 应用图标设置说明

## 步骤1：保存图标文件
请将您提供的计算器图片保存为 `assets/icons/calculator_icon.png`

**重要要求：**
- 图片格式：PNG
- 推荐尺寸：1024x1024 像素（正方形）
- 文件名：`calculator_icon.png`
- 保存路径：`assets/icons/calculator_icon.png`

## 步骤2：安装依赖
运行以下命令安装flutter_launcher_icons包：
```bash
flutter pub get
```

## 步骤3：生成图标
运行以下命令为所有平台生成应用图标：
```bash
flutter pub run flutter_launcher_icons
```

## 步骤4：验证图标
生成完成后，您可以：
1. 在各个平台文件夹中查看生成的图标文件
2. 运行应用查看图标效果：`flutter run`

## 支持的平台
此配置将为以下平台生成图标：
- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 注意事项
- 确保原始图片是正方形且高分辨率
- 图片应该有清晰的边缘，避免过于复杂的细节
- 建议使用透明背景的PNG文件 