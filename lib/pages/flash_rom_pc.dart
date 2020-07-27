import 'package:flash_tool/config/toolkit_colors.dart';
import 'package:flash_tool/pages/flash_other_partition.dart';
import 'package:flash_tool/provider/devices_state.dart';
import 'package:flash_tool/themes/text_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'devices_list.dart';
import 'fastboot_func.dart';
import 'flash_recovery_pc.dart';
import 'flash_system_pc.dart';
import '../utils/platform_util.dart';

class FlashRomPC extends StatefulWidget {
  @override
  _FlashRomPCState createState() => _FlashRomPCState();
}

class _FlashRomPCState extends State<FlashRomPC>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformUtil.isDesktop()) {
      ScreenUtil.init(context,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          allowFontScaling: false);
    } else {
      ScreenUtil.init(context,
          width: 414, height: 896, allowFontScaling: false);
    }
    return ChangeNotifierProvider<DevicesState>(
      create: (_) => DevicesState(),
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: MToolkitColors.accentColor,
          brightness: Brightness.light,
          accentColorBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Color(0xfffbfbfd),
          body: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(25)),
                        //     height: 36.w.toDouble(),
                        //     width: 36.w.toDouble(),
                        //     child: Material(
                        //       color: Colors.white,
                        //       child: InkWell(
                        //         // highlightColor: C,
                        //         borderRadius:
                        //             BorderRadius.circular(18.w.toDouble()),
                        //         child: Icon(
                        //           Icons.arrow_back,
                        //           color: TextColors.fontColor,
                        //         ),
                        //         onTap: () {
                        //           Navigator.of(context).pop();
                        //         },
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 100.w.toDouble(),
                          child: Center(
                            child: Text(
                              '刷机助手',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.w.toDouble(),
                                color: TextColors.fontColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    getNavItem(
                      prefix: Icon(Icons.system_update),
                      title: '刷写系统',
                      index: 0,
                    ),
                    getNavItem(
                      prefix: Icon(Icons.refresh),
                      title: '刷写Recovery',
                      index: 1,
                    ),
                    getNavItem(
                      prefix: Icon(Icons.usb),
                      title: '刷写其他分区',
                      index: 2,
                    ),
                    getNavItem(
                      prefix: Text(
                        'F',
                        style: TextStyle(
                          fontSize: 24.sp.toDouble(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: 'Fastboot功能专区',
                      index: 3,
                    ),
                    Text('设备列表'),
                    DevicesList(),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 4 / 5,
                child: MediaQuery(
                  data: MediaQueryData(
                    size: Size(
                      MediaQuery.of(context).size.width * 4 / 5,
                      MediaQuery.of(context).size.height,
                    ),
                  ),
                  child: [
                    FlashSystemPc(),
                    FlashRecoveryPC(),
                    FlashOtherPartition(),
                    FastbootFunc(),
                  ][pageIndex],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getNavItem({String title, int index, Widget prefix}) {
    return GestureDetector(
      onTap: () {
        pageIndex = index;
        setState(() {});
        controller.reset();
        controller.forward();
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 48.w.toDouble(),
            width: pageIndex == index
                ? (MediaQuery.of(context).size.width / 5 - 40.w.toDouble()) *
                    controller.value
                : MediaQuery.of(context).size.width / 5 - 40.w.toDouble(),
            decoration: pageIndex == index
                ? BoxDecoration(
                    color: Color(0xfff1effa),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                        12.w.toDouble(),
                      ),
                      bottomRight: Radius.circular(
                        12.w.toDouble(),
                      ),
                    ),
                  )
                : BoxDecoration(
                    color: Colors.white,
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24.w.toDouble(),
              ),
              prefix ??
                  Icon(
                    Icons.adb,
                  ),
              SizedBox(
                width: 20.w.toDouble(),
              ),
              Text(title),
            ],
          ),
        ],
      ),
    );
  }
}
