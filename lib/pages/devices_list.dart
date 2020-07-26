import 'dart:io';

import 'package:flash_tool/provider/devices_state.dart';
import 'package:flash_tool/utils/device_utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:print_color/print_color.dart';
import 'package:provider/provider.dart';

class DeviceEntity {
  final String deviceID;
  final String deviceName;

  DeviceEntity(this.deviceID, this.deviceName);
}

class DevicesList extends StatefulWidget {
  @override
  _DevicesListState createState() => _DevicesListState();
}

class _DevicesListState extends State<DevicesList> {
  List<DeviceEntity> devices = [];
  int deviceIndex = 0;
  @override
  void initState() {
    super.initState();
    checkAdb();
  }

  Future<void> checkAdb() async {
    while (mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      if (devicesState.lock) {
        continue;
      }
      List<DeviceEntity> tmp = [];
      // devices.clear();
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
      String trimResult = result.stdout.toString().trim();
      if (trimResult.isNotEmpty) {
        for (String line in trimResult.split('\n')) {
          String deviceId = line.split(RegExp('\\s')).first;
          ProcessResult result;
          try {
            result = await Process.run(
              'fastboot',
              [
                '-s',
                deviceId,
                'getvar',
                'product',
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

          String deviceName = result.stderr
              .toString()
              .split('\n')
              .first
              .trim()
              .replaceAll(RegExp('.*\\s'), '');
          DeviceEntity deviceEntity =
              DeviceEntity(deviceId, DeviceUtils.getName(deviceName));
          tmp.add(deviceEntity);
        }
      }
      if (devicesState.lock) continue;
      devices = tmp;
      if (mounted) setState(() {});
      if (devices.isNotEmpty) {
        devicesState.setDevice(devices[deviceIndex].deviceID);
      }
    }
  }

  DevicesState devicesState;
  @override
  Widget build(BuildContext context) {
    devicesState = Provider.of(context, listen: false);
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
                  devicesState.setDevice(devices[i].deviceID);
                  setState(() {});
                },
              ),
              Text(
                '${devices[i].deviceID}  ${devices[i].deviceName}',
              ),
            ],
          );
        },
      ),
    );
  }
}
