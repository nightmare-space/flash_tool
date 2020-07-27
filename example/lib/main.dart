import 'dart:io';

import 'package:flash_tool/flash_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }
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
