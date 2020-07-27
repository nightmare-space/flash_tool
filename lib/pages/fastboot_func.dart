import 'dart:io';

import 'package:flash_tool/config/config.dart';
import 'package:flash_tool/config/toolkit_colors.dart';
import 'package:flash_tool/provider/devices_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FastbootFunc extends StatefulWidget {
  @override
  _FastbootFuncState createState() => _FastbootFuncState();
}

class _FastbootFuncState extends State<FastbootFunc> {
  @override
  Widget build(BuildContext context) {
    DevicesState devicesState = Provider.of(context);

    return Row(
      children: [
        getFuncItem(
          title: '重启设备',
        ),
        getFuncItem(
          title: '解锁bootloader',
        ),
      ],
    );
  }

  Widget getFuncItem({
    String title,
  }) {
    final DevicesState devicesState = Provider.of(context);
    return GestureDetector(
      onTap: () async {
        final Map<String, String> envir = Map.from(Platform.environment);
        if (Platform.isWindows) {
          envir['PATH'] += ';${Config.binPah}';
        }
        ProcessResult result;
        try {
          result = await Process.run(
            'fastboot',
            [
              '-s',
              devicesState.curDevice,
              'reboot',
            ],
            runInShell: true,
            environment: envir,
            // includeParentEnvironment: true,
          );
        } catch (e) {
          // print('asdasdasd====>$e');
        }
        print(result.stderr);

        print(result.stdout);
      },
      child: Container(
        margin: EdgeInsets.all(16.w.toDouble()),
        decoration: BoxDecoration(
          color: MToolkitColors.candyColor[3],
          borderRadius: BorderRadius.circular(
            16.w.toDouble(),
          ),
        ),
        width: MediaQuery.of(context).size.width / 4,
        height: 64.w.toDouble(),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.w.toDouble(),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
