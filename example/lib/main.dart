import 'package:flash_tool/flash_tool.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '刷机工具',
      theme: ThemeData(
        fontFamily: 'sarasa-ui-sc-semibold',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: WinTerm(),
      home: FlashRomPC(),
    );
  }
}
