import 'package:flash_tool/provider/devices_state.dart';
import 'package:flash_tool/provider/drawer_notifier.dart';
import 'package:flash_tool/themes/text_colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'devices_list.dart';

typedef DrawerCallBack = void Function(int index);

class FlashDrawer extends StatefulWidget {
  const FlashDrawer({Key key, this.onChange}) : super(key: key);
  final DrawerCallBack onChange;

  @override
  _FlashDrawerState createState() => _FlashDrawerState();
}

class _FlashDrawerState extends State<FlashDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
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
            prefix: const Icon(Icons.system_update),
            title: '刷写系统',
            index: 0,
          ),
          getNavItem(
            prefix: const Icon(Icons.refresh),
            title: '刷写Recovery',
            index: 1,
          ),
          getNavItem(
            prefix: const Icon(Icons.usb),
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
          const Text('设备列表'),
          DevicesList(),
        ],
      ),
    );
  }

  Widget getNavItem({String title, int index, Widget prefix}) {
    final DrawerNotifier drawerNotifier = Provider.of<DrawerNotifier>(context);
    return GestureDetector(
      onTap: () {
        widget.onChange?.call(index);
        // pageIndex = index;
        setState(() {});
        controller.reset();
        controller.forward();
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Container(
            height: 48.w.toDouble(),
            width: drawerNotifier.pageIndex == index
                ? (MediaQuery.of(context).size.width - 40.w.toDouble()) *
                    controller.value
                : MediaQuery.of(context).size.width - 40.w.toDouble(),
            decoration: drawerNotifier.pageIndex == index
                ? BoxDecoration(
                    color: const Color(0xfff1effa),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                        12.w.toDouble(),
                      ),
                      bottomRight: Radius.circular(
                        12.w.toDouble(),
                      ),
                    ),
                  )
                : const BoxDecoration(
                    color: Colors.white,
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 24.w.toDouble(),
              ),
              prefix ??
                  const Icon(
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
