import 'dart:io';
import 'dart:ui';
import 'package:flash_tool/config/app_colors.dart';
import 'package:flash_tool/config/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({
    Key key,
    this.onChange,
    this.index,
  }) : super(key: key);
  final void Function(int index) onChange;
  final int index;

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    double width = 0;
    if (!kIsWeb &&
        MediaQuery.of(context).orientation == Orientation.landscape) {
      width = MediaQuery.of(context).size.width * 3 / 10;
    } else {
      width = FastbootConfig.drawerWidth;
    }
    return OrientationBuilder(
      builder: (context, orientation) {
        print('orientation -> $orientation');
        return Material(
          // color: Colors.white,
          child: SafeArea(
            child: SizedBox(
              width: width,
              height: MediaQuery.of(context).size.height,
              child: Builder(
                builder: (_) {
                  if (orientation == Orientation.portrait) {
                    return buildBody(context);
                  }

                  return SingleChildScrollView(
                    child: SizedBox(
                      child: buildBody(context),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 48,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.gap_dp12,
                    vertical: Dimens.gap_dp8,
                  ),
                  child: Text(
                    '刷机工具',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
              _DrawerItem(
                title: '刷写系统',
                value: 0,
                groupValue: widget.index,
                onTap: (index) {
                  widget.onChange?.call(index);
                },
                iconData: Icons.home,
              ),
              _DrawerItem(
                value: 1,
                groupValue: widget.index,
                title: '刷写REC',
                iconData: Icons.file_download,
                onTap: (index) {
                  widget.onChange?.call(index);
                },
              ),
              // _DrawerItem(
              //   title: '当前设备ip',
              //   onTap: () {},
              // ),

              _DrawerItem(
                value: 2,
                groupValue: widget.index,
                title: '执行自定义命令',
                iconData: Icons.code,
                onTap: (index) {
                  widget.onChange?.call(index);
                },
              ),

              // _DrawerItem(
              //   value: 5,
              //   groupValue: widget.index,
              //   title: '刷写其他分区',
              //   iconData: Icons.history,
              //   onTap: (index) async {
              //     widget.onChange?.call(index);
              //   },
              // ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(Dimens.gap_dp16),
                child: Text(
                  '版本：${FastbootConfig.version}',
                  style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    Key key,
    this.title,
    this.onTap,
    this.value,
    this.groupValue,
    this.iconData,
  }) : super(key: key);
  final String title;
  final void Function(int index) onTap;
  final int value;
  final int groupValue;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final bool isChecked = value == groupValue;
    return Padding(
      padding: EdgeInsets.only(
        right: Dimens.gap_dp32,
      ),
      child: InkWell(
        onTap: () => onTap(value),
        splashColor: Colors.transparent,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: Dimens.gap_dp56,
              decoration: isChecked
                  ? BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    )
                  : null,
            ),
            SizedBox(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        iconData ?? Icons.open_in_new,
                        size: 18,
                        color:
                            isChecked ? AppColors.accent : AppColors.fontTitle,
                      ),
                      SizedBox(
                        width: Dimens.gap_dp8,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          color: isChecked
                              ? AppColors.accent
                              : AppColors.fontTitle,
                          fontSize: Dimens.font_sp14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
