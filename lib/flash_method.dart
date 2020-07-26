// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_toolkit/config/envirpath.dart';
// import 'package:flutter_toolkit/config/global.dart';
// import 'package:flutter_toolkit/config/toolkit_colors.dart';
// import 'package:flutter_toolkit/global/widgets/custom_dialog.dart';
// import 'package:flutter_toolkit/module/file_manager/page/fm_page.dart';
// // import 'package:flutter_toolkit/module/rom/utils/exec_script.dart';
// import 'package:flutter_toolkit/utils/platform_util.dart';

// Future<bool> isAdbToolExist() async {
//   //检测软件需要的所有环境
//   bool _bool;
//   if (Platform.isMacOS) {
//     return true;
//   }
//   if (Platform.isAndroid)
//     _bool = File('/data/data/com.nightmare/files/usr/bin/adb').existsSync() &&
//         File('/data/data/com.nightmare/files/usr/bin/fastboot').existsSync();
//   else {
//     print('${Global.documentsDir}/usr/bin/adb');
//     _bool = File('${EnvirPath.filesPath}/usr/bin/adb').existsSync() &&
//         File('${EnvirPath.filesPath}/usr/bin/fastboot').existsSync();
//   }
//   return _bool;
// }

// String unZipFlashRom(String filePath) {
//   return '''
//   function unZipFlashRom(){
//     echo 解压的线刷包为$filePath
//     echo -e '\\033[1;31m解压中(tgz后缀的线刷包需要解压两次)\\033[0m'
//     rm -rf ${Global.documentsDir}/${EnvirPath.appName}/Flash/*
//     7z x -aoa -tgzip \'$filePath\' -o${Global.documentsDir}/${EnvirPath.appName}/Flash >/dev/null 2>&1
//     unzippath=\$(ls ${Global.documentsDir}/${EnvirPath.appName}/Flash)
//     7z x -aoa -ttar \'${Global.documentsDir}/${EnvirPath.appName}/Flash/\$unzippath\' -o${Global.documentsDir}/${EnvirPath.appName}/Flash >/dev/null 2>&1
//     rm -rf \'${Global.documentsDir}/${EnvirPath.appName}/Flash/\$unzippath\'
//     unzippath=\$(ls ${Global.documentsDir}/${EnvirPath.appName}/Flash)
//     mv -f ${Global.documentsDir}/${EnvirPath.appName}/Flash/\$unzippath/* ${Global.documentsDir}/${EnvirPath.appName}/Flash/
//     rm -rf \'${Global.documentsDir}/${EnvirPath.appName}/Flash/\$unzippath\'
//     echo -e '\\033[1;31m解压结束\\033[0m'
//   }
//   ''';
// }

// Future<void> unpackedFlashZip(BuildContext context) async {
//   void _unpackedFlashZip(String filePath) {
//     // showCustomDialog(
//     //     context,
//     //     const Duration(milliseconds: 300),
//     //     80,
//     //     Console(
//     //       title: Text(
//     //         '解压线刷包',
//     //         style: TextStyle(color: Colors.black, fontSize: 16),
//     //       ),
//     //       color: Colors.transparent,
//     //       autoshell: 'echo 解压的线刷包为$filePath\n' +
//     //           'echo '解压中(tgz后缀的线刷包需要解压两次)'\n' +
//     //           'rm -rf ${Global.documentsDir}/${EnvirPath.appName}/Flash/*\n'
//     //               '7z x -aoa -tgzip \'$filePath\' -o${Global.documentsDir}/${EnvirPath.appName}/Flash >/dev/null 2>&1\n' +
//     //           'unzippath=\$(ls ${Global.documentsDir}/${EnvirPath.appName}/Flash)\n' +
//     //           '7z x -aoa -ttar \'${Global.documentsDir}/${EnvirPath.appName}/Flash/\$unzippath\' -o${Global.documentsDir}/${EnvirPath.appName}/Flash >/dev/null 2>&1\n' +
//     //           'rm -rf \'${Global.documentsDir}/${EnvirPath.appName}/Flash/\$unzippath\'\n' + //删除缓存的zip
//     //           'unzippath=\$(ls ${Global.documentsDir}/${EnvirPath.appName}/Flash)\n' +
//     //           'mv -f ${Global.documentsDir}/${EnvirPath.appName}/Flash/\$unzippath/* ${Global.documentsDir}/${EnvirPath.appName}/Flash/\n' +
//     //           'rm -rf \'${Global.documentsDir}/${EnvirPath.appName}/Flash/\$unzippath\'\n' + //删除空文件夹
//     //           exitStr,
//     //       consoleCallback: () async {
//     //         showToast(context: context, message: '执行结束');
//     //       },
//     //     ),
//     //     false,
//     //     false);
//   }

//   await getFilePath(context, _unpackedFlashZip);
// }

// Future<void> flashRec(BuildContext context) async {
//   void _flashRec(String filePath) {
//     // showCustomDialog(
//     //     context,
//     //     const Duration(milliseconds: 300),
//     //     80,
//     //     Console(
//     //       title: Text(
//     //         '刷入REC',
//     //         style: TextStyle(color: Colors.black, fontSize: 16),
//     //       ),
//     //       color: Colors.transparent,
//     //       // autoshell: 'su\n' +
//     //       //     'echo 刷入的REC为$filePath\n' +
//     //       //     'fastboot flash recovery $filePath\n' +
//     //       //     'fastboot boot $filePath\n' +
//     //       //     'echo 请等待片刻,手机会自动重启\n' +
//     //       //     exitStr,
//     //       consoleCallback: () async {
//     //         showToast(context: context, message: '执行结束');
//     //       },
//     //     ),
//     //     false,
//     //     false);
//   }

//   await getFilePath(context, _flashRec);
// }

// Future<void> getFilePath(
//     BuildContext context, void Function(String filepath) fun) async {
//   showCustomDialog(
//       context,
//       const Duration(milliseconds: 300),
//       600,
//       FMPage(
//         initpath: '/MTOOLKIT',
//         callback: (String str) {
//           Navigator.of(context).pop();
//           fun(str);
//         },
//       ),
//       true,
//       false);
// }

// // void showHelp({@required BuildContext context, @required String message}) {
// //   //创建一个OverlayEntry对象
// //   OverlayEntry overlayEntry;
// //   overlayEntry = OverlayEntry(
// //     builder: (context) {
// //       //外层使用Positioned进行定位，控制在Overlay中的位置
// //       return Positioned(
// //         top: MediaQuery.of(context).size.height * 0.7,
// //         child: SizedBox(
// //           width: MediaQuery.of(context).size.width,
// //           child: Stack(
// //             children: <Widget>[
// //               Center(
// //                 child: Card(
// //                   elevation: 1.0,
// //                   child: SizedBox(
// //                     width: 250.0,
// //                     child: Stack(
// //                       children: <Widget>[
// //                         Padding(
// //                           padding: EdgeInsets.only(
// //                               top: 12, bottom: 12, left: 12, right: 12),
// //                           child: Text(
// //                             message,
// //                             style: TextStyle(color: Colors.black),
// //                           ),
// //                         ),
// //                         Align(
// //                           alignment: Alignment.topRight,
// //                           child: InkWell(
// //                             onTap: () {
// //                               overlayEntry.remove();
// //                             },
// //                             child: Icon(
// //                               Icons.clear,
// //                               color: appColor,
// //                             ),
// //                           ),
// //                         )
// //                       ],
// //                     ),
// //                   ),
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     },
// //   );
// //   //往Overlay中插入插入OverlayEntry
// //   Overlay.of(context).insert(overlayEntry);
// //   //两秒后，移除Toast
// //   Future<void>.delayed(Duration(milliseconds: 2000)).then((value) {});
// // }

// Widget button(String str, void Function() fun) {
//   return Card(
//     color: MToolkitColors.appColor,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(
//           25.0), //如果[borderRadius]被指定，那么[type]属性不能是 [MaterialType.circle]。
//     ),
//     elevation: 2,
//     child: InkWell(
//       splashColor: Colors.grey.withOpacity(0.4),
//       borderRadius: BorderRadius.circular(25),
//       onTap: fun,
//       child: SizedBox(
//         height: 30,
//         child: Center(
//           child: Text(
//             str,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
