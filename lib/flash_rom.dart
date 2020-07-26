// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_terminal/flutter_terminal.dart';
// import 'package:flutter_toolkit/config/envirpath.dart';
// import 'package:flutter_toolkit/config/global.dart';
// import 'package:flutter_toolkit/global/provider/change_notifier.dart';
// import 'package:flutter_toolkit/global/widgets/material_cliprrect.dart';
// import 'package:flutter_toolkit/main.dart';
// import 'package:flutter_toolkit/config/toolkit_colors.dart';
// import 'package:flutter_toolkit/module/file_manager/page/fm_page.dart';
// import 'package:flutter_toolkit/module/remote/remote_method.dart';
// import 'package:flutter_toolkit/module/term/term.dart';
// import 'package:flutter_toolkit/themes/text_colors.dart';
// // import 'package:flutter_toolkit/module/rom/utils/exec_script.dart';
// // import 'package:flutter_toolkit/module/rom/utils/rom_func.dart';
// import 'package:flutter_toolkit/utils/global_function.dart';
// import 'package:flutter_toolkit/utils/platform_channel.dart';
// import 'package:flutter_toolkit/utils/platform_util.dart';
// import 'package:flutter_toolkit/utils/process.dart';
// import 'package:provider/provider.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'flash_method.dart' hide getFilePath;

// class FlashRom extends StatefulWidget {
//   @override
//   _FlashRomState createState() => _FlashRomState();
// }

// class _FlashRomState extends State<FlashRom>
//     with SingleTickerProviderStateMixin {
//   final List<String> _listAdbDevices = <String>[];
//   final List<String> _listFastbootDevices = <String>[]; //fastboot连接的设备列表
//   Map<String, String> romInfo = <String, String>{};
//   bool autoCheck = true;

//   @override
//   void initState() {
//     super.initState();
//     initFlashRom();
//   }

//   Future<void> initFlashRom() async {
//     while (CustomProcess.process == null)
//       await Future<void>.delayed(const Duration(milliseconds: 100));
//     creatDirectorty();
//     getRomInfo();
//     getAdbDevices();
//     getFastbootDevices();
//     needUpdateBinary(context, await isAdbToolExist(), <int>[17]);
//   }

//   Future<void> getRomInfo() async {
//     String info = '';
//     try {
//       info = File('${Global.documentsDir}/${EnvirPath.appName}/Flash/misc.txt')
//           .readAsStringSync();
//     } catch (e) {
//       print('');
//     }
//     if (info.isNotEmpty) {
//       romInfo['设备id'] = RegExp('device.*')
//           .firstMatch(info)
//           .group(0)
//           .replaceAll(RegExp('.*='), '');
//       romInfo['版本信息'] = RegExp('build_number.*')
//           .firstMatch(info)
//           .group(0)
//           .replaceAll(RegExp('.*='), '');
//       romInfo['Version'] = RegExp('userdata_version.*')
//           .firstMatch(info)
//           .group(0)
//           .replaceAll(RegExp('.*='), '');
//     } else
//       romInfo.clear();
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<void> creatDirectorty() async {
//     Directory('${Global.documentsDir}/${EnvirPath.appName}/Flash').createSync();
//   }

//   Future<void> getAdbDevices() async {
//     while (mounted && autoCheck && await isAdbToolExist()) {
//       String devices = await CustomProcess.exec('adb devices\n');
//       // print('devices===>$devices');
//       devices = devices.replaceAll(RegExp('List.*\n'), '');
//       _listAdbDevices.clear();
//       if (devices.isNotEmpty) {
//         devices.split('\n').forEach((String element) {
//           _listAdbDevices.add(element);
//         });
//       }
//       if (mounted) {
//         setState(() {});
//       }
//       await Future<void>.delayed(const Duration(milliseconds: 300));
//     }
//   }

//   Future<void> getFastbootDevices() async {
//     while (mounted && autoCheck && await isAdbToolExist()) {
//       final String devices = await CustomProcess.exec('fastboot devices -l\n');

//       _listFastbootDevices.clear();
//       if (devices.isNotEmpty) {
//         _listFastbootDevices.add(devices);
//       }
//       getRomInfo();
//       if (mounted) {
//         setState(() {});
//       }
//       await Future<void>.delayed(const Duration(milliseconds: 300));
//     }
//   }

//   bool exitApp = false;
//   @override
//   Widget build(BuildContext context) {
//     final MToolKitNotifier mToolKitNotifier =
//         Provider.of<MToolKitNotifier>(context);
//     return MaterialApp(
//       title: '数据线刷机',
//       theme: ThemeData(
//         textTheme: TextTheme(caption: TextStyle(color: Colors.red)),
//         brightness: Brightness.light,
//         primaryColorBrightness: mToolKitNotifier.primaryColorBrightness,
//         accentColorBrightness: Brightness.dark,
//         backgroundColor: mToolKitNotifier.backgroundColor,
//         accentColor: const Color(0xff811016),
//         primaryColor: const Color(0xff811016),
//         splashColor: const Color(0x22811016),
//       ),
//       home: WillPopScope(
//         onWillPop: () async {
//           if (exitApp) {
//             PlatformChannel.Drawer.invokeMethod<void>('Exit');
//           } else {
//             exitApp = true;
//             Future<void>.delayed(const Duration(milliseconds: 1000), () {
//               exitApp = false;
//             });
//             onWillPop();
//           }
//           return false;
//         },
//         child: Scaffold(
//           appBar: buildAppBar(context),
//           body: buildColumn(context),
//         ),
//       ),
//     );
//   }

//   Column buildColumn(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         FlashRomItem(
//           child: Column(
//             children: <Widget>[
//               // SizedBox(
//               //   height: 30.0,
//               //   child: Row(
//               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //     children: <Widget>[
//               //       const Text('  已连接到ADB的设备'),
//               //       Row(
//               //         children: <Widget>[
//               //           if (autoCheck)
//               //             SpinKitThreeBounce(
//               //               color: MToolkitColors.appColor,
//               //               size: 16.0,
//               //             )
//               //           else
//               //             const SizedBox(
//               //               width: 0.0,
//               //             ),
//               //           const SizedBox(
//               //             width: 10.0,
//               //           )
//               //         ],
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               SizedBox(
//                 height: _listAdbDevices.length * 80.0,
//                 child: ListView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: _listAdbDevices.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Column(
//                       children: <Widget>[
//                         SizedBox(
//                           height: 30.0,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 margin: const EdgeInsets.only(right: 4.0),
//                                 width: 6.0,
//                                 height: 20.0,
//                                 decoration: BoxDecoration(
//                                   color: MToolkitColors.candyColor[0],
//                                   borderRadius: const BorderRadius.only(
//                                       bottomRight: Radius.circular(25),
//                                       topRight: Radius.circular(25)),
//                                   // side: BorderSide(width: 2.0),
//                                 ),
//                               ),
//                               Text(_listAdbDevices[index]),
//                               if (_listAdbDevices[index].contains('unauthor'))
//                                 const Text(
//                                   '(需要设备允许ADB调试)',
//                                   style: TextStyle(
//                                       color: Color(0xffff0000), fontSize: 12.0),
//                                 )
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 50.0,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Container(
//                                 margin: const EdgeInsets.only(right: 4.0),
//                                 width: 6.0,
//                                 height: 20.0,
//                                 decoration: BoxDecoration(
//                                   color: MToolkitColors.candyColor[1],
//                                   borderRadius: const BorderRadius.only(
//                                       bottomRight: Radius.circular(25),
//                                       topRight: Radius.circular(25)),
//                                   // side: BorderSide(width: 2.0),
//                                 ),
//                               ),
//                               const Text(
//                                 '  重启设备到:',
//                                 style: TextStyle(fontSize: 14.0),
//                               ),
//                               Row(
//                                 children: <Widget>[
//                                   FlatButton(
//                                       child: const Text('REC'),
//                                       onPressed: () async {
//                                         await CustomProcess.exec(
//                                             'adb -s ${_listAdbDevices[index].replaceAll(RegExp('device'), '')} reboot recovery');
//                                         showToast2('执行成功');
//                                       }),
//                                   FlatButton(
//                                       child: const Text('Fastboot'),
//                                       onPressed: () async {
//                                         await CustomProcess.exec(
//                                             'adb -s ${_listAdbDevices[index].replaceAll(RegExp('device'), '')} reboot bootloader');
//                                         showToast2('执行成功');
//                                       }),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               Row(
//                 children: <Widget>[
//                   FlatButton(
//                       onPressed: () async {
//                         await CustomProcess.exec('adb kill-server');
//                         showToast2('重启成功');
//                       },
//                       child: const Text('重启adb服务'))
//                 ],
//               ),
//             ],
//           ),
//         ),
//         FlashRomItem(
//           child: Column(
//             children: <Widget>[
//               SizedBox(
//                 height: 30.0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     const Text('  已连接到Fastboot的设备'),
//                     Row(
//                       children: <Widget>[
//                         if (autoCheck)
//                           SpinKitThreeBounce(
//                             color: MToolkitColors.appColor,
//                             size: 16.0,
//                           )
//                         else
//                           const SizedBox(
//                             width: 0.0,
//                           ),
//                         const SizedBox(
//                           width: 10.0,
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: _listFastbootDevices.length * 30.0,
//                 child: ListView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: _listFastbootDevices.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return SizedBox(
//                       height: 30.0,
//                       child: Row(
//                         children: <Widget>[
//                           Text('  ' + _listFastbootDevices[index]),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         MaterialClipRRect(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               const Padding(
//                 padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                 child: Text(
//                   'Tips:请确保/Sdcard/MTOOLKIT/Flash文件夹下有.sh结尾的脚本文件',
//                   style: TextStyle(fontSize: 14.0),
//                 ),
//               ),
//               SizedBox(
//                 height: 30.0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     const Text('   线刷包'),
//                     SizedBox(
//                       height: 26.0,
//                       child: FlatButton(
//                         // highlightColor: Colors.grey.withOpacity(0.6),
//                         splashColor: Colors.grey.withOpacity(0.6),
//                         color: Colors.grey,
//                         onPressed: () async {
//                           final String path = await showCustomDialog2<String>(
//                             isPadding: false,
//                             height: 600.0,
//                             child: FMPage(
//                               chooseFile: true,
//                               initpath: '${Global.documentsDir}/MToolkit/Rom',
//                               callback: (String str) {
//                                 Navigator.of(globalContext).pop(str);
//                                 // fun(str);
//                               },
//                             ),
//                           );
//                           print(path);
//                           if (path != null) {
//                             final NitermController controller =
//                                 NitermController();
//                             await controller
//                                 .defineTermFunc(unZipFlashRom(path));
//                             showCustomDialog2<void>(
//                               isPadding: false,
//                               height: 600,
//                               child: Niterm(
//                                 controller: controller,
//                                 showOnDialog: true,
//                                 script: 'unZipFlashRom\n',
//                               ),
//                             );
//                           }
//                           // unpackedFlashZip(context);
//                         },
//                         child: const Text(
//                           '选中以解压到工作目录',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         if (autoCheck)
//                           SpinKitThreeBounce(
//                             color: MToolkitColors.appColor,
//                             size: 16.0,
//                           )
//                         else
//                           const SizedBox(
//                             width: 0.0,
//                           ),
//                         const SizedBox(
//                           width: 10.0,
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               if (romInfo.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10.0),
//                   child: Text('当前线刷包配置信息:\n' +
//                       romInfo.toString().replaceAll(RegExp('{|}'), '')),
//                 )
//               else
//                 const SizedBox(),
//               if (File('${Global.documentsDir}/${EnvirPath.appName}/Flash/flash_all.sh')
//                       .existsSync() &&
//                   _listFastbootDevices.isNotEmpty)
//                 button(
//                   '刷机并清除所有数据',
//                   () {
//                     // showCustomDialog(
//                     //     context,
//                     //     const Duration(milliseconds: 300),
//                     //     80,
//                     //     Console(
//                     //       title: Text(
//                     //         '刷机并清除所有数据',
//                     //         style: TextStyle(
//                     //             color: Colors.black, fontSize: 16),
//                     //       ),
//                     //       color: Colors.transparent,
//                     //       // autoshell: 'echo asdasd\necho asdasd\n'+exitStr,
//                     //       // autoshell:
//                     //       //     'su\nsh ${Global.documentsDir}/${EnvirPath.appName}/Flash/flash_all.sh\n' +
//                     //       //         exitStr,
//                     //       consoleCallback: () {
//                     //         return;
//                     //       },
//                     //     ),
//                     //     false,
//                     //     false);
//                   },
//                 )
//               else
//                 const SizedBox(
//                   height: 0.0,
//                 ),
//               if (File('${Global.documentsDir}/${EnvirPath.appName}/Flash/flash_all_except_storage.sh')
//                       .existsSync() &&
//                   _listFastbootDevices.isNotEmpty)
//                 button(
//                   '刷机但保留外部储存数据',
//                   () {
//                     showCustomDialog2<void>(
//                       isPadding: false,
//                       height: 600,
//                       child: Niterm(
//                         showOnDialog: true,
//                         script:
//                             'su\nsh ${Global.documentsDir}/${EnvirPath.appName}/Flash/flash_all_except_storage.sh\n',
//                       ),
//                     );
//                   },
//                 )
//               else
//                 const SizedBox(
//                   height: 0.0,
//                 ),
//               if (File('${Global.documentsDir}/${EnvirPath.appName}/Flash/flash_all_lock.sh')
//                       .existsSync() &&
//                   _listFastbootDevices.isNotEmpty)
//                 button(
//                   '刷机并重新锁BL',
//                   () {
//                     // showCustomDialog(
//                     //     context,
//                     //     const Duration(milliseconds: 300),
//                     //     80,
//                     //     Console(
//                     //       title: Text(
//                     //         '刷机并重新锁BL',
//                     //         style: TextStyle(
//                     //             color: Colors.black, fontSize: 16),
//                     //       ),
//                     //       color: Colors.transparent,
//                     //       // autoshell: 'echo asdasd\necho asdasd\n'+exitStr,
//                     //       // autoshell:
//                     //       //     'su\nsh ${Global.documentsDir}/${EnvirPath.appName}/Flash/flash_all_lock.sh\n' +
//                     //       //         exitStr,
//                     //       consoleCallback: () {
//                     //         return;
//                     //       },
//                     //     ),
//                     //     false,
//                     //     false);
//                   },
//                 )
//               else
//                 const SizedBox(
//                   height: 0.0,
//                 ),
//             ],
//           ),
//         ),
//         if (_listFastbootDevices.isNotEmpty)
//           Column(
//             children: <Widget>[
//               button('刷入Rec', () {
//                 flashRec(context);
//               }),
//               button('刷入其它单个分区', () {
//                 // getFilePath(context, (a) async {});
//               }),
//             ],
//           ),
//       ],
//     );
//   }

//   AppBar buildAppBar(BuildContext context) {
//     final MToolKitNotifier mToolKitNotifier =
//         Provider.of<MToolKitNotifier>(context);
//     return AppBar(
//       backgroundColor: mToolKitNotifier.backgroundColor,
//       elevation: 0.0,
//       title: Text(
//         '魇·空间',
//         style: TextStyle(
//           fontSize: 28.sp.toDouble(),
//           fontWeight: FontWeight.bold,
//           color: TextColors.fontColor,
//         ),
//       ),
//       leading: Align(
//         alignment: Alignment.center,
//         child: Container(
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
//           height: 36.0,
//           width: 36.0,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(25),
//             splashColor: const Color(0xffe1e1e1),
//             highlightColor: const Color(0xffe1e1e1),
//             child: Icon(Icons.menu, size: 22.0),
//             onTap: () {
//               Scaffold.of(context).openDrawer();
//             },
//           ),
//         ),
//       ),
//       actions: <Widget>[
//         Center(
//           child: Container(
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
//             height: 36,
//             width: 36,
//             child: InkWell(
//               borderRadius: BorderRadius.circular(25),
//               child: Tooltip(
//                 message: '点击打开帮助',
//                 child: Icon(Icons.help_outline, size: 25.0),
//               ),
//               onTap: () {
//                 showHelp(
//                     context: context,
//                     message: '你需要使用otg转接线将你需要刷机的手机连接到本设备,'
//                         '然后选择使用该软件让刷机的手机重启到Fastboot模式'
//                         '(或者自行重启),然后再操作该页面涉及刷机的功能');
//               },
//             ),
//           ),
//         ),
//         const SizedBox(
//           width: 10.0,
//         )
//       ],
//     );
//   }
// }

// class FlashRomItem extends StatefulWidget {
//   const FlashRomItem(
//       {Key key,
//       this.onTap,
//       this.width,
//       // this.suffix,
//       this.child})
//       : super(key: key);
//   final Function onTap;
//   final double width;
//   // final Widget suffix;
//   final Widget child;

//   @override
//   _BackupItemState createState() => _BackupItemState();
// }

// class _BackupItemState extends State<FlashRomItem>
//     with SingleTickerProviderStateMixin {
//   List<Color> colors = const <Color>[
//     Color(0xffef92a5),
//     Color(0xff73b3fa),
//     Color(0xffb4d761),
//     Color(0xffcc99fe),
//     Colors.deepPurple,
//     Colors.indigo,
//   ];

//   AnimationController _animationController;
//   Animation<double> _colorWidth;
//   // Color _color;
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 2000));
//     _colorWidth =
//         Tween<double>(begin: 0.0, end: 0.94).animate(_animationController);
//     _colorWidth.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   int animation;
//   @override
//   Widget build(BuildContext context) {
//     // MToolKitNotifier mToolKitNotifier = Provider.of<MToolKitNotifier>(context);
//     // if (!_animationController.isAnimating) _color = colors[Random().nextInt(5)];
//     return Padding(
//       padding: const EdgeInsets.all(6.0),
//       child: Material(
//         color: Theme.of(context).cardColor,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(12.0),
//           ),
//         ),
//         shadowColor: Colors.grey.withOpacity(0.1),
//         elevation: 4.0,
//         child: ClipRRect(
//             borderRadius: const BorderRadius.all(
//               Radius.circular(12.0),
//             ),
//             child: Stack(
//               children: <Widget>[
//                 widget.child,
//               ],
//             )),
//       ),
//     );
//   }
// }
