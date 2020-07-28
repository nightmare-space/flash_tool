import 'package:flash_tool/flash_tool.dart';
import 'package:flash_tool/pages/flash_system_pc.dart';
import 'package:flash_tool/provider/devices_state.dart';
import 'package:flash_tool/utils/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'flash_tool_desktop.dart';

class FlashTool extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DevicesState>(
          create: (_) => DevicesState(),
        ),
      ],
      child: MaterialApp(
        home: Builder(
          builder: (c) {
            if (PlatformUtil.isDesktop()) {
              ScreenUtil.init(context,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  allowFontScaling: false);
            } else {
              ScreenUtil.init(context,
                  width: 414, height: 896, allowFontScaling: false);
            }
            return PlatformUtil.isDesktop()
                ? FlashToolDesktop()
                : FlashToolMobile();
          },
        ),
      ),
    );
  }
}
