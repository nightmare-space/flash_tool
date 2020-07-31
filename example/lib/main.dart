import 'dart:io';
import 'dart:typed_data';

import 'package:flash_tool/flash_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    installAdb();
  }
}

Future<void> installAdb() async {
  final ByteData byteData = await rootBundle.load('assets/android/fastboot');
  final Uint8List picBytes =
      byteData.buffer.asUint8List(); //以上两行是从apk内assets文件夹讲文件转换为Uint8List的轮子
  const String fastPath = '/data/data/com.example.example/files/fastboot';
  await File(fastPath).writeAsBytes(picBytes);
  Process.runSync('chmod', <String>['+x', fastPath]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '刷机工具',
      theme: ThemeData(
        fontFamily: 'sarasa-ui-sc-semibold',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: WinTerm(),
      home: FlashTool(),
    );
  }
}
