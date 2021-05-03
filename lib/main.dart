import 'dart:io';
import 'dart:typed_data';

import 'package:flash_tool/config/app_colors.dart';
import 'package:flash_tool/flash_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';

void main() {
  RuntimeEnvir.initEnvirWithPackageName('com.nightmare.flash_tool');
  runApp(NiToastNew(
    child: MyApp(),
  ));
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
      debugShowCheckedModeBanner: false,
      title: '刷机工具',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: AppColors.accent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: AppColors.fontTitle,
          ),
          textTheme: TextTheme(
            headline6: TextStyle(
              height: 1.0,
              fontSize: 20.0,
              color: AppColors.fontTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: FlashTool(),
    );
  }
}
