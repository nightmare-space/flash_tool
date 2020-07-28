import 'dart:io';
import 'dart:ui';

import 'package:flash_tool/config/toolkit_colors.dart';
import 'package:flash_tool/pages/flash_other_partition.dart';
import 'package:flash_tool/provider/devices_state.dart';
import 'package:flash_tool/themes/text_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int pageIndex = 0;
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
          appBarTheme: AppBarTheme(
            color: Color(0xfffbfbfd),
          ),
        ),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Material(
            color: Color(0xfffbfbfd),
            child: SafeArea(
              child: Row(
                children: [
                  SizedBox(
                    width: PlatformUtil.isDesktop()
                        ? MediaQuery.of(context).size.width * 4 / 5
                        : MediaQuery.of(context).size.width,
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
        ),
      ),
    );
  }
}
