import 'dart:ui';

import 'package:flash_tool/config/toolkit_colors.dart';
import 'package:flash_tool/pages/flash_other_partition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fastboot_func.dart';
import 'flash_recovery_page.dart';
import 'flash_system_page.dart';

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
    return Theme(
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
              children: <Widget>[
                MediaQuery(
                  data: MediaQueryData(
                    size: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height,
                    ),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: <Widget>[
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
    );
  }
}
