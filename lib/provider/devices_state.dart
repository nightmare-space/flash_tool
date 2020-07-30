import 'dart:io';

import 'package:flash_tool/config/config.dart';
import 'package:flash_tool/pages/devices_list.dart';
import 'package:flash_tool/utils/device_utils.dart';
import 'package:flash_tool/utils/platform_util.dart';
import 'package:flash_tool/utils/process.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:print_color/print_color.dart';
import 'package:provider/provider.dart';

class DevicesState extends ChangeNotifier {
  DevicesState() {
    checkAdb();
  }
  static DevicesState of(BuildContext context) {
    return Provider.of<DevicesState>(context);
  }

  int deviceIndex = 0;
  List<DeviceEntity> devices = <DeviceEntity>[];
  String curDevice = '';
  bool lock = false;
  void setDevice(String id) {
    debugPrintWithColor(
      '设置当前设备为=====>$id',
      backgroundColor: PrintColor.white,
      fontColor: PrintColor.red,
    );
    curDevice = id;
    notifyListeners();
  }

  void setLock() {
    lock = true;
  }

  void unLock() {
    lock = false;
  }

  Future<void> checkAdb() async {
    final Map<String, String> envir =
        Map<String, String>.from(Platform.environment);
    if (Platform.isWindows) {
      envir['PATH'] += ';${Config.binPah}';
    } else if (Platform.isAndroid) {
      envir['PATH'] += ':/data/data/com.example.example/files';
    }
    debugPrintWithColor(
      '环境变量=====>${envir['PATH']}',
      backgroundColor: PrintColor.white,
      fontColor: PrintColor.red,
    );
    while (true) {
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      if (lock) {
        continue;
      }

      // showToast(context: context, message: envir['PATH']);
      final List<DeviceEntity> tmp = <DeviceEntity>[];
      // devices.clear();
      ProcessResult result;
      if (PlatformUtil.isDesktop()) {
        try {
          result = await Process.run(
            'fastboot',
            <String>[
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
      debugPrintWithColor(
        'fastboot devices结果=====>${result.stdout}',
        backgroundColor: PrintColor.white,
        fontColor: PrintColor.blue,
      );
      // print('result.stderr====>${result.stderr}');
      final String trimResult = result.stdout.toString().trim();
      if (trimResult.isNotEmpty) {
        for (final String line in trimResult.split('\n')) {
          final String deviceId = line.split(RegExp('\\s')).first;
          ProcessResult result;
          if (PlatformUtil.isDesktop()) {
            try {
              result = await Process.run(
                'fastboot',
                <String>[
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
          print('getvar product结果====>${result.stderr}');
          final String deviceName = result.stderr
              .toString()
              .trim()
              .split('\n')
              .first
              .replaceAll(RegExp('.*\\s'), '');
          final DeviceEntity deviceEntity =
              DeviceEntity(deviceId, DeviceUtils.getName(deviceName));
          tmp.add(deviceEntity);
        }
      }
      if (lock) {
        continue;
      }
      devices = tmp;
      notifyListeners();
      if (devices.isNotEmpty) {
        setDevice(devices[deviceIndex].deviceID);
      }
    }
  }
}
