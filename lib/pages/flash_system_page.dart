import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flash_tool/config/app_colors.dart';
import 'package:flash_tool/config/candy_colors.dart';
import 'package:flash_tool/config/global.dart';
import 'package:flash_tool/widgets/item_header.dart';
import 'package:flash_tool/widgets/terminal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:global_repository/global_repository.dart';

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
  bool openCache = false;
  FlashMode _flashMode = FlashMode.saveUserData;
  void changeFlashMode(FlashMode flashMode) {
    _flashMode = flashMode;
    setState(() {});
  }

  Future<void> execFlash() async {
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
    if (PlatformUtil.isDesktop()) {
      try {
        Process.start(
          batPath,
          <String>[
            '-s',
          ],
          runInShell: false,
          environment: PlatformUtil.environment(),
          mode: ProcessStartMode.normal,
        ).then((Process value) {
          value.stdout.transform(utf8.decoder).listen((String out) {
            // print('====>$out');
            setState(() {});
          });
          value.stderr.transform(utf8.decoder).listen((String out) {
            termOut += out;

            final int curNum = RegExp('Finished').allMatches(termOut).length;

            flashProgress = curNum / cmdNumber;
            if (out.contains('Rebooting')) {
              isFlashing = false;
              timer.cancel();
              setState(() {});
            }
            setState(() {});
            print('====>$out');
          });
        });
      } catch (e) {
        // print('asdasdasd====>$e');
      }
    } else {
      NiProcess.exec('sh $batPath 2>&1', callback: (String out) {
        termOut += out;

        final int curNum =
            RegExp('Finished|finished').allMatches(termOut).length;

        flashProgress = curNum / cmdNumber;
        if (out.contains('Rebooting')) {
          isFlashing = false;
          timer.cancel();
          setState(() {});
        }
        setState(() {});
        print('====>$out');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // primary: false,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.gap_dp8,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  ItemHeader(
                    color: AppColors.accent,
                  ),
                  Text(
                    '线刷包路径',
                    style: TextStyle(
                      fontSize: Dimens.font_sp20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.fontTitle,
                      height: 1.0,
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: () async {
                  if (PlatformUtil.isMobilePhone()) {
                    final ClipboardData data = await Clipboard.getData(
                      Clipboard.kTextPlain,
                    );
                    if (data.text.isNotEmpty) {
                      romPath = data.text;
                      setState(() {});
                    } else {
                      showToast('剪切板为空哦~');
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    // horizontal: Dimens.gap_dp8,
                    vertical: Dimens.gap_dp8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F1F3),
                    borderRadius: BorderRadius.circular(
                      12.w.toDouble(),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.gap_dp8,
                      vertical: Dimens.gap_dp12,
                    ),
                    child: Center(
                      child: Text(
                        romPath,
                        style: TextStyle(
                          fontSize: 18.w.toDouble(),
                          color: AppColors.fontDetail,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text('点击粘贴路径'),
              Text(
                '需要先解压线刷包，然后选择刷机脚本所在的目录，一般也是images这个文件夹所在的目录。',
                style: TextStyle(
                  color: AppColors.fontDetail,
                ),
              ),
              Row(
                children: <Widget>[
                  ItemHeader(
                    color: CandyColors.candyBlue,
                  ),
                  Text(
                    '选择刷机模式',
                    style: TextStyle(
                      fontSize: Dimens.font_sp20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.fontTitle,
                    ),
                  ),
                ],
              ),
              Wrap(
                children: <Widget>[
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Radio<FlashMode>(
                          value: FlashMode.deleteAll,
                          groupValue: _flashMode,
                          onChanged: changeFlashMode,
                        ),
                        Text(
                          '全部删除',
                          style: TextStyle(
                            fontSize: Dimens.font_sp16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.fontTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: <Widget>[
                        Radio<FlashMode>(
                          value: FlashMode.saveUserData,
                          groupValue: _flashMode,
                          onChanged: changeFlashMode,
                        ),
                        Text(
                          '保留用户数据',
                          style: TextStyle(
                            fontSize: Dimens.font_sp16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.fontTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: <Widget>[
                        Radio<FlashMode>(
                          value: FlashMode.deleteAllAndLock,
                          groupValue: _flashMode,
                          onChanged: changeFlashMode,
                        ),
                        Text(
                          '全部删除并lock',
                          style: TextStyle(
                            fontSize: Dimens.font_sp16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.fontTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  Text(
                    '开启缓存（避免存在刷写失败的问题）',
                    style: TextStyle(
                      fontSize: 18.w.toDouble(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.fontTitle,
                    ),
                  ),
                  Switch(
                    value: openCache,
                    onChanged: (bool v) {
                      openCache = !openCache;
                      setState(() {});
                    },
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  ItemHeader(
                    color: CandyColors.candyBlue,
                  ),
                  Text(
                    '终端',
                    style: TextStyle(
                      fontSize: Dimens.font_sp20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.fontTitle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Dimens.gap_dp8,
              ),
              // GestureDetector(
              //   onTap: () {
              //     execFlash();
              //   },
              //   child: Container(
              //     margin: EdgeInsets.all(8.w.toDouble()),
              //     decoration: BoxDecoration(
              //       color: CandyColors.colors[3],
              //       borderRadius: BorderRadius.circular(
              //         12.w.toDouble(),
              //       ),
              //     ),
              //     width: 200.w.toDouble(),
              //     height: 36.w.toDouble(),
              //     child: Stack(
              //       children: <Widget>[
              //         Container(
              //           width: MediaQuery.of(context).size.width /
              //               4 *
              //               flashProgress,
              //           decoration: BoxDecoration(
              //             color: Colors.green,
              //             borderRadius: BorderRadius.circular(
              //               12.w.toDouble(),
              //             ),
              //           ),
              //         ),
              //         Stack(
              //           children: <Widget>[
              //             Center(
              //               child: Text(
              //                 isFlashing ? '刷入中' : '开始刷入',
              //                 style: TextStyle(
              //                   fontSize: 20.sp.toDouble(),
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //             ),
              //             if (isFlashing)
              //               Align(
              //                 alignment: const Alignment(0.7, 0),
              //                 child: Text(
              //                   '$alreadyUseTime\s',
              //                   style: TextStyle(
              //                     fontSize: 20.w.toDouble(),
              //                     fontWeight: FontWeight.bold,
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 200,
                child: TerminalPage(),
              ),
              NiCardButton(
                blurRadius: 0,
                shadowColor: Colors.transparent,
                borderRadius: 12.0,
                color: AppColors.accent,
                onTap: () async {
                  if (romPath.isEmpty) {
                    showToast('线刷包路径为空');
                    return;
                  }
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
                  final StringBuffer buffer = StringBuffer();
                  buffer.writeln('su -c "');
                  buffer.writeln('export PATH=${RuntimeEnvir.path}');
                  buffer.writeln(
                    'sh $batPath"\n',
                  );
                  Global.instance.pseudoTerminal.write(buffer.toString());
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: Dimens.gap_dp48,
                  child: const Center(
                    child: Text(
                      '执行刷入',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      primary: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      backwardsCompatibility: true,
      title: Text(
        '刷写Rom',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.fontTitle,
        ),
      ),
    );
  }
}
