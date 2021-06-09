import 'package:flash_tool/flash_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:global_repository/global_repository.dart';

// 主要的widget
// 会自动判断平台
// 返回执行的页面
class FlashTool extends StatelessWidget {
  FlashTool({
    Key key,
  }) : super(key: key) {
    FastbootConfig.flutterPackage = 'packages/flash_tool/';
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        if (PlatformUtil.isDesktop()) {
          ScreenUtil.init(
            context,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            allowFontScaling: false,
          );
        } else {
          ScreenUtil.init(
            context,
            width: 414,
            height: 896,
            allowFontScaling: false,
          );
        }
        return FlashToolMobile();
      },
    );
  }
}
