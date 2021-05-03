import 'dart:io';
import 'dart:typed_data';

import 'package:flash_tool/config/config.dart';
import 'package:flash_tool/flash_tool.dart';
import 'package:flash_tool/pages/drawer.dart';
import 'package:flash_tool/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';

class FlashToolMobile extends StatefulWidget {
  @override
  _FlashToolMobileState createState() => _FlashToolMobileState();
}

class _FlashToolMobileState extends State<FlashToolMobile> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    installAdb();
  }

  Future<void> installAdb() async {
    if (Platform.isAndroid) {
      final ByteData byteData = await rootBundle
          .load('${FastbootConfig.flutterPackage}assets/android/fastboot');
      final Uint8List picBytes = byteData.buffer.asUint8List();
      Directory binDir = Directory(RuntimeEnvir.binPath);
      if (!binDir.existsSync()) {
        await binDir.create(
          recursive: true,
        );
      }
      final String fastPath = '${RuntimeEnvir.binPath}/fastboot';
      await File(fastPath).writeAsBytes(picBytes);
      Log.w('复制 fastboot');
      Process.runSync(
        'chmod',
        <String>['+x', fastPath],
      );
    }
    // if (Platform.isMacOS) {
    //   final ByteData byteData = await rootBundle.load('assets/android/fastboot');
    //   final Uint8List picBytes =
    //       byteData.buffer.asUint8List(); //以上两行是从apk内assets文件夹讲文件转换为Uint8List的轮子
    //   String fastPath =
    //       FileSystemEntity.parentOf(Platform.resolvedExecutable) + '/fastboot';
    //   await File(fastPath).writeAsBytes(picBytes);
    //   Process.runSync('chmod', <String>['+x', fastPath]);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FlashToolScaffold(
      drawer: DrawerPage(
        index: pageIndex,
        onChange: (value) {
          pageIndex = value;
          setState(() {});
        },
      ),
      body: FlashToolBody(
        pageIndex: pageIndex,
      ),
    );
  }
}
