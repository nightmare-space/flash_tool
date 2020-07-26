import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_chooser/file_chooser.dart';
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
  //  命令得条数
  int cmdNumber = 0;
  Timer timer;
  int alreadyUseTime = 0;
  FlashMode _flashMode = FlashMode.saveUserData;
  void changeFlashMode(FlashMode flashMode) {
    _flashMode = flashMode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                    FileTypeFilterGroup(label: 'bat', fileExtensions: ['bat'])
                  ],
                );
                romPath =
                    FileSystemEntity.parentOf(fileChooserResult.paths.first);
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
            isFlashing = true;
            timer = Timer.periodic(Duration(seconds: 1), (timer) {
              alreadyUseTime = timer.tick;
              setState(() {});
            });
            setState(() {});
            // return;
            devicesState.setLock();
            Map<String, String> envir = Map.from(Platform.environment);
            // print(envir);
            print(envir['PATH']);
            envir['PATH'] += ';D:\\SDK\\Android\\platform-tools';
            String batPath = '';
            switch (_flashMode) {
              case FlashMode.deleteAll:
                batPath = '$romPath\\flash_all.bat';
                break;
              case FlashMode.saveUserData:
                batPath = '$romPath\\flash_all_except_storage.bat';
                break;
              case FlashMode.deleteAllAndLock:
                batPath = '$romPath\\flash_all_lock.bat';
                break;
            }
            cmdNumber =
                File(batPath).readAsStringSync().trim().split('\n').length - 2;
            Process.start(
              batPath,
              <String>[],
              runInShell: false,
              environment: envir,
              mode: kReleaseMode
                  ? ProcessStartMode.normal
                  : ProcessStartMode.normal,
            ).then((value) {
              value.stdout.transform(utf8.decoder).listen((String out) {
                print('====>$out');
                setState(() {});
              });
              value.stderr.transform(utf8.decoder).listen((String out) {
                termOut += out;

                int curNum = RegExp('Finished').allMatches(termOut).length;

                flashProgress = curNum / cmdNumber;
                if (out.contains('Rebooting')) {
                  devicesState.unLock();
                  isFlashing = false;
                  timer.cancel();
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
