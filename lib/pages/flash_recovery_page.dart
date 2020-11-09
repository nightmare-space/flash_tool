import 'dart:convert';
import 'dart:io';
import 'package:file_chooser/file_chooser.dart';
import 'package:flash_tool/config/config.dart';
import 'package:flash_tool/config/global.dart';
import 'package:flash_tool/config/toolkit_colors.dart';
import 'package:flash_tool/provider/devices_state.dart';
import 'package:flash_tool/themes/text_colors.dart';
import 'package:flash_tool/widgets/custom_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:global_repository/global_repository.dart';
import 'package:provider/provider.dart';

class FlashRecoveryPC extends StatefulWidget {
  @override
  _FlashRecoveryPCState createState() => _FlashRecoveryPCState();
}

class _FlashRecoveryPCState extends State<FlashRecoveryPC> {
  String termOut = '';
  String recPath = '';
  @override
  Widget build(BuildContext context) {
    // debugPrintWithColor(
    //   '   Rec路径====>$recPath   ',
    //   backgroundColor: PrintColor.green,
    //   fontColor: PrintColor.black,
    // );

    final DevicesState devicesState = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          '刷写Rec${devicesState.curDevice}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: TextColors.fontColor,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 10.w.toDouble(),
                height: 40.w.toDouble(),
                color: MToolkitColors.candyColor[0],
              ),
              SizedBox(
                width: 16.w.toDouble(),
              ),
              Text(
                'Rec路径',
                style: TextStyle(
                  fontSize: 18.w.toDouble(),
                  fontWeight: FontWeight.bold,
                  color: TextColors.fontColor,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(16.w.toDouble()),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1F3),
              borderRadius: BorderRadius.circular(
                12.w.toDouble(),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                16.w.toDouble(),
              ),
              child: Center(
                child: Text(
                  recPath,
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
              if (PlatformUtil.isMobilePhone()) {
                ClipboardData data =
                    await Clipboard.getData(Clipboard.kTextPlain);
                print('''''object''' '');
                print(data.text);

                recPath = data.text;
                setState(() {});
                return;
              }
              final FileChooserResult fileChooserResult = await showOpenPanel(
                allowedFileTypes: <FileTypeFilterGroup>[
                  const FileTypeFilterGroup(
                    label: 'img',
                    fileExtensions: <String>['img'],
                  ),
                ],
              );
              if (fileChooserResult.canceled) {
                return;
              }
              recPath = fileChooserResult.paths.first;
              setState(() {});
              print(fileChooserResult.paths);
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 16.w.toDouble(),
              ),
              decoration: BoxDecoration(
                color: MToolkitColors.candyColor[1],
                borderRadius: BorderRadius.circular(
                  24.w.toDouble(),
                ),
              ),
              height: 48.w.toDouble(),
              width: 200.w.toDouble(),
              child: Center(
                child: Text(
                  //
                  PlatformUtil.isDesktop() ? '选择' : '粘贴路径',
                  style: TextStyle(
                    fontSize: 20.w.toDouble(),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              termOut = '';
              setState(() {});
              devicesState.setLock();
              if (PlatformUtil.isMobilePhone()) {
                await NiProcess.exec(
                    'fastboot -s ${devicesState.curDevice} flash recovery $recPath 2>&1',
                    callback: (out) {
                  termOut += out;
                  if (out.contains('Finished')) {
                    devicesState.unLock();
                  }
                  setState(() {});
                  print('====>$out');
                });
                // devicesState.unLock();
              } else {
                Process.start(
                  'fastboot',
                  <String>[
                    '-s',
                    devicesState.curDevice,
                    'flash',
                    'recovery',
                    recPath,
                  ],
                  runInShell: true,
                  environment: Global.instance.paltformEnvir,
                ).then((Process value) {
                  // value.stdout.transform(utf8.decoder).listen((String out) {
                  //   print('====>$out');
                  // });
                  value.stderr.transform(utf8.decoder).listen((String out) {
                    termOut += out;
                    if (out.contains('Finished')) {
                      devicesState.unLock();
                    }
                    setState(() {});
                    print('====>$out');
                  });
                });
              }
            },
            child: Container(
              margin: EdgeInsets.all(16.w.toDouble()),
              decoration: BoxDecoration(
                color: MToolkitColors.candyColor[3],
                borderRadius: BorderRadius.circular(
                  16.w.toDouble(),
                ),
              ),
              width: 200.w.toDouble(),
              height: 48.w.toDouble(),
              child: Center(
                child: Text(
                  '开始刷入',
                  style: TextStyle(
                    fontSize: 20.w.toDouble(),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.w.toDouble()),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1F3),
              borderRadius: BorderRadius.circular(
                12.w.toDouble(),
              ),
            ),
            width: MediaQuery.of(context).size.width * 4 / 5,
            child: Padding(
              padding: EdgeInsets.all(8.w.toDouble()),
              child: CustomList(
                child: Text(
                  termOut == '' ? '等待刷入' : termOut.trim(),
                  style: TextStyle(
                    fontSize: 18.w.toDouble(),
                    fontWeight: FontWeight.bold,
                    color: TextColors.fontColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
