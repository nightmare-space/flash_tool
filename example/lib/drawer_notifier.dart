import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum DrawerState {
  open,
  close,
}

class DrawerNotifier extends ChangeNotifier {
  DrawerNotifier() {
    controller.addListener(() {
      // print('controller.offset===${controller.offset}');
      // print(' drawerWidth.toInt()===${drawerWidth.toInt()}');
      if (controller.offset < drawerWidth / 2) {
        changeState(DrawerState.open);
      } else if (controller.offset == drawerWidth + 4) {
        // if(controller){

        // }
        changeState(DrawerState.close);
        // controller.jumpTo(drawerWidth);
        // controller.jumpTo(drawerWidth - 1);
      }
      scale = 0.2 - (controller.offset / drawerWidth) * 0.2;
      notifyListeners();
    });
  }
  bool isScroll = false;
  ScrollController controller = ScrollController(
      initialScrollOffset:
          (window.physicalSize.width / window.devicePixelRatio * 3 ~/ 4)
                  .toDouble() +
              4);
  String _currentRoute = '';
  DrawerState drawerState = DrawerState.close; //侧栏是否被打开了
  void Function() listener;
  double drawerWidth =
      (window.physicalSize.width / window.devicePixelRatio * 3 ~/ 4).toDouble();

  PageController _pageController;
  PageController get pageController => _pageController;
  void setPageCTL(PageController ctl) {
    print('------初始化------');
    _pageController = ctl;
  }

  // void initPageCTL(){

  // }

  void addDrawerListener(void Function() callback) {
    listener = callback;
  }

  void removeDrawerListener() {
    listener = null;
  }

  void changeState(DrawerState state) {
    if (drawerState != state) {
      print('------更新状态------');
      drawerState = state;
      // print('------回调=====>$drawerState------');
    }
  }

  double scale = 0.0;

  // bool get isChanging => drawerState == DrawerState.changing;

  bool get isOpen => drawerState == DrawerState.open;

  bool get isClose => drawerState == DrawerState.close;

  void openDrawer() {
    print('object');
    controller.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  Future<void> closeDrawer() async {
    await controller.animateTo(drawerWidth + 4,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void jump(double dx) {
    controller.jumpTo(dx);
    notifyListeners();
  }

  List<String> _routeStack = <String>[];
  String get currentRoute => _currentRoute;
  void pushRoute(String routeName) {
    _routeStack = <String>[routeName] + _routeStack;
  }
}
