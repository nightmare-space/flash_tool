import 'dart:io';

import 'package:flash_tool/config/config.dart';
import 'package:flash_tool/provider/devices_state.dart';
import 'package:flash_tool/utils/device_utils.dart';
import 'package:flash_tool/utils/platform_util.dart';
import 'package:flash_tool/utils/process.dart';
import 'package:flash_tool/utils/show_toast.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:print_color/print_color.dart';
import 'package:provider/provider.dart';

class DeviceEntity {
  DeviceEntity(this.deviceID, this.deviceName);
  final String deviceID;
  final String deviceName;
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
    final Map<String, String> envir = Map.from(Platform.environment);
    if (Platform.isWindows) {
      envir['PATH'] += ';${Config.binPah}';
    } else if (Platform.isAndroid) {
      envir['PATH'] += ':/data/data/com.example.example/files';
    }
    print('asdasd');
    print(envir['PATH']);
    while (mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      if (devicesState.lock) {
        continue;
      }

      // showToast(context: context, message: envir['PATH']);
      List<DeviceEntity> tmp = [];
      // devices.clear();
      ProcessResult result;
      if (PlatformUtil.isDesktop()) {
        try {
          result = await Process.run(
            'fastboot',
            [
              'devices',
            ],

            runInShell: true,
            environment: envir,
            // includeParentEnvironment: true,
          );
        } catch (e) {
          // print('asdasdasd====>$e');
        }
      } else {
        result = ProcessResult(
            0, 0, await CustomProcess.exec('fastboot devices'), '');
      }
      // String fastOut = result.stdout.toString();
      print('result.stdout====>${result.stdout}');
      // print('result.stderr====>${result.stderr}');
      String trimResult = result.stdout.toString().trim();
      if (trimResult.isNotEmpty) {
        for (String line in trimResult.split('\n')) {
          String deviceId = line.split(RegExp('\\s')).first;
          ProcessResult result;
          if (PlatformUtil.isDesktop()) {
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
                environment: envir,
                // includeParentEnvironment: true,
              );
            } catch (e) {
              // print('asdasdasd====>$e');
            }
          } else {
            print('deviceId====>$deviceId');
            result = ProcessResult(
              0,
              0,
              '',
              await CustomProcess.exec(
                'fastboot -s $deviceId getvar product 2>&1',
              ),
            );
          }
          // print('result.stdout====>${result.stdout}');
          print('result.stderr====>${result.stderr}');
          String deviceName = result.stderr
              .toString()
              .trim()
              .split('\n')
              .first
              .replaceAll(RegExp('.*\\s'), '');
          DeviceEntity deviceEntity =
              DeviceEntity(deviceId, DeviceUtils.getName(deviceName));
          tmp.add(deviceEntity);
        }
      }
      if (devicesState.lock) continue;
      devices = tmp;
      if (mounted) {
        setState(() {});
      }
      if (devices.isNotEmpty) {
        devicesState.setDevice(devices[deviceIndex].deviceID);
      }
    }
  }

  DevicesState devicesState;
  @override
  Widget build(BuildContext context) {
    devicesState = Provider.of(context, listen: false);
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 3 / 4,
          height: 48 * devices.length.w.toDouble(),
          child: ListView.builder(
            padding: EdgeInsets.all(0.0),
            itemCount: devices.length,
            itemBuilder: (BuildContext c, int i) {
              // return Text('data');
              return SizedBox(
                child: Row(
                  children: [
                    Radio<int>(
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
