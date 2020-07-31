import 'package:flash_tool/flash_tool.dart';
import 'package:flash_tool/provider/devices_state.dart';
import 'package:flash_tool/provider/drawer_notifier.dart';
import 'package:flash_tool/utils/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'desktop/flash_tool_desktop.dart';

// 主要的widget
// 会自动判断平台
// 返回执行的页面
class FlashTool extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider<DevicesState>(
          create: (_) => DevicesState(),
        ),
        ChangeNotifierProvider<DrawerNotifier>(
          create: (_) => DrawerNotifier(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (BuildContext c) {
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
