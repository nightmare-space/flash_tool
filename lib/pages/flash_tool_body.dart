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
import 'drawer.dart';
import 'fastboot_func.dart';
import 'flash_recovery_page.dart';
import 'flash_system_page.dart';
import '../utils/platform_util.dart';

class FlashToolBody extends StatefulWidget {
  const FlashToolBody({Key key, this.pageIndex = 0}) : super(key: key);
  final int pageIndex;

  @override
  _FlashToolBodyState createState() => _FlashToolBodyState();
}

class _FlashToolBodyState extends State<FlashToolBody>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DevicesState>(
      create: (_) => DevicesState(),
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: MToolkitColors.accentColor,
          appBarTheme: const AppBarTheme(
            color: Color(0xfffbfbfd),
          ),
        ),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Material(
            color: const Color(0xfffbfbfd),
            child: SafeArea(
              child: Row(
                children: [
                  MediaQuery(
                    data: MediaQueryData(
                      size: Size(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height,
                      ),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: [
                        FlashSystemPc(),
                        FlashRecoveryPC(),
                        FlashOtherPartition(),
                        FastbootFunc(),
                      ][widget.pageIndex],
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
