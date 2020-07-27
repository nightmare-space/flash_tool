import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_chooser/file_chooser.dart';
import 'package:flash_tool/config/config.dart';
import 'package:flash_tool/config/toolkit_colors.dart';
import 'package:flash_tool/provider/devices_state.dart';
import 'package:flash_tool/themes/text_colors.dart';
import 'package:flash_tool/widgets/custom_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

enum FlashMode {
  deleteAll,
  saveUserData,
  deleteAllAndLock,
}

class FlashSystemPc extends StatefulWidget {
  @override
  _FlashSystemPcState createState() => _FlashSystemPcState();
}

class _FlashSystemPcState extends State<FlashSystemPc> {
  String termOut = '';
  String romPath = '';
  bool isFlashing = false;
  double flashProgress = 0.0;
  //  命令的条数
  int cmdNumber = 0;
  Timer timer;
  int alreadyUseTime = 0;
  String shType = Platform.isWindows ? 'bat' : 'sh';
  FlashMode _flashMode = FlashMode.saveUserData;
  void changeFlashMode(FlashMode flashMode) {
    _flashMode = flashMode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print(cmdNumber);
    // final int curNum = RegExp('Finished').allMatches(termOut).length;
    // print(curNum);
    final DevicesState devicesState = Provider.of(context);
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 10.w.toDouble(),
              height: 40.w.toDouble(),
              color: MToolkitColors.candyColor[0],
            ),
            SizedBox(
              width: 16.w.toDouble(),
            ),
            Text(
              '线刷包路径',
              style: TextStyle(
                fontSize: 18.w.toDouble(),
                fontWeight: FontWeight.bold,
                color: TextColors.fontColor,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.all(16.w.toDouble()),
              decoration: BoxDecoration(
                color: Color(0xFFF0F1F3),
                borderRadius: BorderRadius.circular(
                  12.w.toDouble(),
                ),
              ),
              width: MediaQuery.of(context).size.width * 4 / 5,
              child: Padding(
                padding: EdgeInsets.all(
                  16.w.toDouble(),
                ),
                child: Center(
                  child: Text(
                    '$romPath',
                    style: TextStyle(
                      fontSize: 18.w.toDouble(),
                      fontWeight: FontWeight.bold,
                      color: TextColors.fontColor,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                FileChooserResult fileChooserResult = await showOpenPanel(
                  allowedFileTypes: [
                    // FileTypeFilterGroup(label: shType, fileExtensions: [shType])
                  ],
                  canSelectDirectories: true,
                );
                if (fileChooserResult.canceled) {
                  return;
                }
                romPath = fileChooserResult.paths.first;
                setState(() {});
                print(fileChooserResult.paths);
              },
              child: Container(
                margin: EdgeInsets.all(16.w.toDouble()),
                decoration: BoxDecoration(
                  color: MToolkitColors.candyColor[1],
                  borderRadius: BorderRadius.circular(
                    12.w.toDouble(),
                  ),
                ),
                width: MediaQuery.of(context).size.width / 8,
                height: 64.w.toDouble(),
                child: Center(
                  child: Text(
                    '选择',
                    style: TextStyle(
                      fontSize: 20.w.toDouble(),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          '需要先解压线刷包，然后选择刷机脚本所在的目录，一般也是images这个文件夹所在的目录。',
          style: TextStyle(
            color: TextColors.fontColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Container(
              width: 10.w.toDouble(),
              height: 40.w.toDouble(),
              color: MToolkitColors.candyColor[0],
            ),
            SizedBox(
              width: 16.w.toDouble(),
            ),
            Text(
              '选择刷机模式',
              style: TextStyle(
                fontSize: 18.w.toDouble(),
                fontWeight: FontWeight.bold,
                color: TextColors.fontColor,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Radio<FlashMode>(
              value: FlashMode.deleteAll,
              groupValue: _flashMode,
              onChanged: changeFlashMode,
            ),
            Text(
              '全部删除',
              style: TextStyle(
                fontSize: 18.w.toDouble(),
                fontWeight: FontWeight.bold,
                color: TextColors.fontColor,
              ),
            ),
            Radio<FlashMode>(
              value: FlashMode.saveUserData,
              groupValue: _flashMode,
              onChanged: changeFlashMode,
            ),
            Text(
              '保留用户数据',
              style: TextStyle(
                fontSize: 18.w.toDouble(),
                fontWeight: FontWeight.bold,
                color: TextColors.fontColor,
              ),
            ),
            Radio<FlashMode>(
              value: FlashMode.deleteAllAndLock,
              groupValue: _flashMode,
              onChanged: changeFlashMode,
            ),
            Text(
              '全部删除并lock',
              style: TextStyle(
                fontSize: 18.w.toDouble(),
                fontWeight: FontWeight.bold,
                color: TextColors.fontColor,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () async {
            if (isFlashing) {
              return;
            }
            termOut = '';
            setState(() {});
            isFlashing = true;
            timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
              alreadyUseTime = timer.tick;
              setState(() {});
            });
            setState(() {});
            // return;
            devicesState.setLock();
            final Map<String, String> envir = Map.from(Platform.environment);
            if (Platform.isWindows) {
              envir['PATH'] += ';${Config.binPah}';
            }
            print(envir['PATH']);
            String batPath = '';
            switch (_flashMode) {
              case FlashMode.deleteAll:
                batPath = Platform.isWindows
                    ? '$romPath/flash_all.bat'
                    : '$romPath/flash_all.sh';
                break;
              case FlashMode.saveUserData:
                batPath = Platform.isWindows
                    ? '$romPath/flash_all_except_storage.bat'
                    : '$romPath/flash_all_except_storage.sh';
                break;
              case FlashMode.deleteAllAndLock:
                batPath = Platform.isWindows
                    ? '$romPath/flash_all_lock.bat'
                    : '$romPath/flash_all_lock.sh';
                break;
            }
            // 读取设备信息两行是没有Finished标识的
            cmdNumber = RegExp('fastboot')
                    .allMatches(
                      File(batPath).readAsStringSync(),
                    )
                    .length -
                2;
            Process.start(
              batPath,
              <String>[
                '-s',
                devicesState.curDevice,
              ],
              runInShell: false,
              environment: envir,
              mode: ProcessStartMode.normal,
            ).then((Process value) {
              value.stdout.transform(utf8.decoder).listen((String out) {
                // print('====>$out');
                setState(() {});
              });
              value.stderr.transform(utf8.decoder).listen((String out) {
                termOut += out;

                final int curNum =
                    RegExp('Finished').allMatches(termOut).length;

                flashProgress = curNum / cmdNumber;
                if (out.contains('Rebooting')) {
                  devicesState.unLock();
                  isFlashing = false;
                  timer.cancel();
                  setState(() {});
                }
                setState(() {});
                print('====>$out');
              });
            });
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
            height: 48.w.toDouble(),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 4 * flashProgress,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(
                      16.w.toDouble(),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Center(
                      child: Text(
                        isFlashing ? '刷入中' : '开始刷入',
                        style: TextStyle(
                          fontSize: 20.w.toDouble(),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (isFlashing)
                      Align(
                        alignment: const Alignment(0.5, 0),
                        child: Text(
                          '$alreadyUseTime\s',
                          style: TextStyle(
                            fontSize: 20.w.toDouble(),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(16.w.toDouble()),
          decoration: BoxDecoration(
            color: Color(0xFFF0F1F3),
            borderRadius: BorderRadius.circular(
              12.w.toDouble(),
            ),
          ),
          width: MediaQuery.of(context).size.width * 4 / 5,
          height: 240.w.toDouble(),
          child: Padding(
            padding: EdgeInsets.all(8.w.toDouble()),
            child: Scrollbar(
              child: CustomList(
                child: Text(
                  termOut == '' ? '等待刷入' : '${termOut.trim()}',
                  style: TextStyle(
                    fontSize: 18.w.toDouble(),
                    fontWeight: FontWeight.bold,
                    color: TextColors.fontColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
