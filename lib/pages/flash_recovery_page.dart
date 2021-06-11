import 'package:flash_tool/config/app_colors.dart';
import 'package:flash_tool/config/global.dart';
import 'package:flash_tool/widgets/item_header.dart';
import 'package:flash_tool/widgets/terminal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:global_repository/global_repository.dart';

class FlashRecoveryPC extends StatefulWidget {
  @override
  _FlashRecoveryPCState createState() => _FlashRecoveryPCState();
}

class _FlashRecoveryPCState extends State<FlashRecoveryPC> {
  String termOut = '';
  String recPath = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          '刷写Rec',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.fontTitle,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ItemHeader(
                  color: CandyColors.candyGreen,
                ),
                Text(
                  'Rec路径',
                  style: TextStyle(
                    fontSize: Dimens.font_sp20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.fontTitle,
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
                    recPath = data.text;
                    setState(() {});
                  } else {
                    showToast('剪切板为空哦~');
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(
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
                      recPath,
                      style: TextStyle(
                        fontSize: Dimens.font_sp16,
                        color: AppColors.fontDetail,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text('点击粘贴路径'),
            // GestureDetector(
            //   onTap: () async {
            //     if (PlatformUtil.isMobilePhone()) {
            //       ClipboardData data =
            //           await Clipboard.getData(Clipboard.kTextPlain);
            //       print('''''object''' '');
            //       print(data.text);

            //       recPath = data.text;
            //       setState(() {});
            //       return;
            //     }
            //     // final FileChooserResult fileChooserResult = await showOpenPanel(
            //     //   allowedFileTypes: <FileTypeFilterGroup>[
            //     //     const FileTypeFilterGroup(
            //     //       label: 'img',
            //     //       fileExtensions: <String>['img'],
            //     //     ),
            //     //   ],
            //     // );
            //     // if (fileChooserResult.canceled) {
            //     //   return;
            //     // }
            //     // recPath = fileChooserResult.paths.first;
            //     // setState(() {});
            //     // print(fileChooserResult.paths);
            //   },
            //   child: Container(
            //     margin: EdgeInsets.only(
            //       bottom: 16.w.toDouble(),
            //     ),
            //     decoration: BoxDecoration(
            //       color: CandyColors.colors[1],
            //       borderRadius: BorderRadius.circular(
            //         24.w.toDouble(),
            //       ),
            //     ),
            //     height: 48.w.toDouble(),
            //     width: 200.w.toDouble(),
            //     child: Center(
            //       child: Text(
            //         //
            //         PlatformUtil.isDesktop() ? '选择' : '粘贴路径',
            //         style: TextStyle(
            //           fontSize: 20.w.toDouble(),
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Row(
              children: <Widget>[
                ItemHeader(
                  color: CandyColors.candyPink,
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
            const SizedBox(
              height: 200,
              child: TerminalPage(),
            ),
            // GestureDetector(
            //   onTap: () async {
            //     termOut = '';
            //     setState(() {});
            //     devicesState.setLock();
            //     if (PlatformUtil.isMobilePhone()) {
            //       await NiProcess.exec(
            //           'fastboot -s ${devicesState.curDevice} flash recovery $recPath 2>&1',
            //           callback: (out) {
            //         termOut += out;
            //         if (out.contains('Finished')) {
            //           devicesState.unLock();
            //         }
            //         setState(() {});
            //         print('====>$out');
            //       });
            //       // devicesState.unLock();
            //     } else {
            //       Process.start(
            //         'fastboot',
            //         <String>[
            //           '-s',
            //           devicesState.curDevice,
            //           'flash',
            //           'recovery',
            //           recPath,
            //         ],
            //         runInShell: true,
            //         environment: PlatformUtil.environment(),
            //       ).then((Process value) {
            //         // value.stdout.transform(utf8.decoder).listen((String out) {
            //         //   print('====>$out');
            //         // });
            //         value.stderr.transform(utf8.decoder).listen((String out) {
            //           termOut += out;
            //           if (out.contains('Finished')) {
            //             devicesState.unLock();
            //           }
            //           setState(() {});
            //           print('====>$out');
            //         });
            //       });
            //     }
            //   },
            //   child: Container(
            //     margin: EdgeInsets.all(16.w.toDouble()),
            //     decoration: BoxDecoration(
            //       color: CandyColors.colors[3],
            //       borderRadius: BorderRadius.circular(
            //         16.w.toDouble(),
            //       ),
            //     ),
            //     width: 200.w.toDouble(),
            //     height: 48.w.toDouble(),
            //     child: Center(
            //       child: Text(
            //         '开始刷入',
            //         style: TextStyle(
            //           fontSize: 20.w.toDouble(),
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            NiCardButton(
              blurRadius: 0,
              shadowColor: Colors.transparent,
              borderRadius: 12.0,
              color: AppColors.accent,
              onTap: () async {
                if (recPath.isEmpty) {
                  showToast('REC路径为空');
                  return;
                }
                final StringBuffer buffer = StringBuffer();
                buffer.writeln('su -c "');
                buffer.writeln('export PATH=${RuntimeEnvir.path}');
                buffer.writeln(
                  'fastboot flash recovery $recPath"\n',
                );
                Global.instance.pseudoTerminal.write(buffer.toString());
              },
              child: SizedBox(
                height: Dimens.gap_dp48,
                child: const Center(
                  child: Text(
                    '开始刷入',
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
    );
  }
}
