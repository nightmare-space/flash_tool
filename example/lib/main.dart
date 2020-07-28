import 'dart:io';

import 'package:example/drawer_notifier.dart';
import 'package:flash_tool/flash_tool.dart';
import 'package:flash_tool/provider/devices_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<DrawerNotifier>(
            create: (_) => DrawerNotifier(),
          ),
          ChangeNotifierProvider<DevicesState>(
            create: (_) => DevicesState(),
          ),
        ],
        child: HomePage(),
      ),
    );
  }
}
