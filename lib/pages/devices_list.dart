import 'dart:io';

import 'package:flash_rom/provider/devices_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DevicesList extends StatefulWidget {
  @override
  _DevicesListState createState() => _DevicesListState();
}

class _DevicesListState extends State<DevicesList> {
  List<String> devices = [];
  int deviceIndex = 0;
  @override
  void initState() {
    super.initState();
    checkAdb();
  }

  Future<void> checkAdb() async {
    while (mounted) {
      await Future.delayed(Duration(milliseconds: 1000));
      if (devicesState.lock) continue;
      devices.clear();
      ProcessResult result;
      try {
        result = await Process.run(
          'fastboot',
          [
            'devices',
          ],
          runInShell: true,
          environment: <String, String>{
            'Path': 'D:\\SDK\\Android\\platform-tools',
          },
          // includeParentEnvironment: true,
        );
      } catch (e) {
        // print('asdasdasd====>$e');
      }
      if (result.stdout.toString().trim().isNotEmpty) {
        for (String line
            in result.stdout.toString().trim().split(RegExp('\n'))) {
          devices.add(line.split(RegExp('\\s')).first);
        }
      }
      if (mounted) setState(() {});
      // debugPrintWithColor(
      //   '   fastboot输出====>${result.stdout}   ',
      //   backgroundColor: PrintColor.green,
      //   fontColor: PrintColor.black,
      // );
    }
  }

  DevicesState devicesState;
  @override
  Widget build(BuildContext context) {
    devicesState = Provider.of(context);
    return SizedBox(
      height: 48 * devices.length.w.toDouble(),
      child: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (c, i) {
          return Row(
            children: [
              Radio(
                value: i,
                groupValue: deviceIndex,
                onChanged: (int index) {
                  deviceIndex = index;
                  devicesState.setDevice(devices[i]);
                  setState(() {});
                },
              ),
              Text(
                devices[i],
              ),
            ],
          );
        },
      ),
    );
  }
}
