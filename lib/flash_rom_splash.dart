// 这个页面用来引导刷机页面
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

import 'flash_rom.dart';
import 'pages/flash_rom_pc.dart';
import 'package:print_color/print_color.dart';

import 'themes/text_colors.dart';

class FlashRomSplash extends StatefulWidget {
  @override
  _FlashRomSplashState createState() => _FlashRomSplashState();
}

class _FlashRomSplashState extends State<FlashRomSplash> {
  @override
  void initState() {
    super.initState();
    checkAdb();
  }

  Future<void> checkAdb() async {
    ProcessResult result;
    try {
      result = await Process.run(
        'adb',
        ['', ''],
        includeParentEnvironment: true,
      );
    } catch (e) {
      print('asdasdasd====>$e');
    }
    debugPrintWithColor(
      '   sdfsdf         ',
      backgroundColor: PrintColor.white,
      fontColor: PrintColor.white,
    );
    // print(result.exitCode);
    debugPrintWithColor(
      '   sdfsdf         ',
      backgroundColor: PrintColor.white,
      fontColor: PrintColor.white,
    );
    // print(result.stdout);
    // print(result.stderr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Center(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            height: 36.w.toDouble(),
            width: 36.w.toDouble(),
            child: InkWell(
              // highlightColor: C,
              borderRadius: BorderRadius.circular(18.w.toDouble()),
              child: Icon(
                Icons.arrow_back,
                color: TextColors.fontColor,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
      body: FlashRomPC(),
      // body: ,
    );
  }
}
