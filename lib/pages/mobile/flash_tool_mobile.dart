import 'dart:ui';

import 'package:flash_tool/flash_tool.dart';
import 'package:flash_tool/provider/devices_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:print_color/print_color.dart';
import 'package:provider/provider.dart';

import '../../provider/drawer_notifier.dart';

class FlashToolMobile extends StatefulWidget {
  @override
  _FlashToolMobileState createState() => _FlashToolMobileState();
}

class _FlashToolMobileState extends State<FlashToolMobile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider<DrawerNotifier>(
            create: (_) => DrawerNotifier(),
          ),
          ChangeNotifierProvider<DevicesState>(
            create: (_) => DevicesState(),
          ),
        ],
        child: Material(
          color: Colors.white,
          child: HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  double borderRadius = 30;
  // DrawerController;
  // double borderRadius = 0;
  DrawerNotifier drawerNotifier;
  @override
  Widget build(BuildContext context) {
    drawerNotifier ??= Provider.of<DrawerNotifier>(context, listen: false);
    // print(' drawerNotifier.isClose()??false===>${ drawerNotifier.isClose()??false}');
    // print('object');
    return ListView(
      cacheExtent: 0.0,
      controller: drawerNotifier.controller,
      physics: PagingScrollPhysics(
        drawerNotifier: drawerNotifier,
        maxSize: drawerNotifier.drawerWidth + 4,
        itemDimension: drawerNotifier.drawerWidth + 4,
      ),
      // itemCount: 2,
      // itemExtent: drawerNotifier.drawerWidth.toDouble(),
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Selector<DrawerNotifier, double>(
          selector: (BuildContext context, DrawerNotifier viewModel) =>
              viewModel.scale,
          builder: (BuildContext context, double progress, Widget child) {
            return Transform(
              alignment: Alignment.centerRight,
              transform: Matrix4.identity()..scale(0.8 + drawerNotifier.scale),
              child: MediaQuery(
                data: MediaQueryData(
                  size: Size(
                    MediaQuery.of(context).size.width * 3 / 4,
                    MediaQuery.of(context).size.height,
                  ),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 4,
                  height: MediaQuery.of(context).size.height,
                  child: Material(
                    child: FlashDrawer(
                      onChange: (int index) {
                        pageIndex = index;
                        drawerNotifier.changeIndex(index);
                        setState(() {});
                        drawerNotifier.closeDrawer();
                        debugPrintWithColor(
                          '侧栏改变了页面=========$index',
                          fontColor: PrintColor.red,
                          backgroundColor: PrintColor.white,
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // 为了能让Drawer销毁
        Container(
          color: Colors.transparent,
          width: 4.0,
        ),
        Selector<DrawerNotifier, double>(
          selector: (BuildContext context, DrawerNotifier viewModel) =>
              viewModel.scale,
          builder: (BuildContext context, double progress, Widget child) {
            final double drawerDelta = drawerNotifier.scale / 0.2;
            final double whiteShadowDelta = borderRadius / 2 * drawerDelta;
            final Offset whiteShadowOffset = Offset(-2 * whiteShadowDelta, 0);
            return Transform(
              alignment: Alignment.centerLeft,
              transform: Matrix4.identity()..scale(1.0 - drawerNotifier.scale),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: <BoxShadow>[
                    ...<BoxShadow>[
                      BoxShadow(
                          color: Colors.black.withAlpha(70),
                          blurRadius: 20.0,
                          // has the effect of softening the shadow
                          spreadRadius: -whiteShadowDelta,
                          offset: whiteShadowOffset
                          // has the effect of extending the shadow)
                          ),
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 0,
                          spreadRadius: -whiteShadowDelta,
                          offset: whiteShadowOffset),
                      BoxShadow(
                        color: Colors.black.withAlpha(70),
                        blurRadius: 20.0,
                        // has the effect of softening the shadow
                        spreadRadius: 2,
                        // has the effect of extending the shadow)
                      ),
                    ]
                  ],
                ),
                // height: co.maxHeight,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Stack(
                    children: <Widget>[
                      FlashToolBody(
                        pageIndex: pageIndex,
                      ),
                      if (drawerNotifier.isOpen)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              drawerNotifier.closeDrawer();
                            },
                          ),
                        )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
      // itemBuilder: (BuildContext c, int i) {
      //   if (i == 0) {
      //     return Selector<DrawerNotifier, double>(
      //       selector: (BuildContext context, DrawerNotifier viewModel) =>
      //           viewModel.scale,
      //       builder: (BuildContext context, double progress, Widget child) {
      //         return Transform(
      //           alignment: Alignment.centerRight,
      //           transform: Matrix4.identity()
      //             ..scale(0.8 + drawerNotifier.scale),
      //           child: MainDrawer(),
      //         );
      //       },
      //     );
      //   }
      //   if (i == 1) {
      //     return Selector<DrawerNotifier, double>(
      //       selector: (BuildContext context, DrawerNotifier viewModel) =>
      //           viewModel.scale,
      //       builder: (BuildContext context, double progress, Widget child) {
      //         final double drawerDelta = drawerNotifier.scale / 0.2;
      //         final double whiteShadowDelta = borderRadius / 2 * drawerDelta;
      //         final Offset whiteShadowOffset = Offset(-2 * whiteShadowDelta, 0);
      //         return LayoutBuilder(
      //           builder: (BuildContext c, BoxConstraints co) {
      //             return Transform(
      //               alignment: Alignment.centerLeft,
      //               transform: Matrix4.identity(),
      //               // ..scale(1.0 - drawerNotifier.scale),
      //               child: Container(
      //                 decoration: BoxDecoration(
      //                     color: Colors.white,
      //                     borderRadius: BorderRadius.circular(30.0),
      //                     boxShadow: <BoxShadow>[
      //                       if (drawerNotifier.scale > 0) ...<BoxShadow>[
      //                         BoxShadow(
      //                             color: Colors.black.withAlpha(70),
      //                             blurRadius: 20.0,
      //                             // has the effect of softening the shadow
      //                             spreadRadius: -whiteShadowDelta,
      //                             offset: whiteShadowOffset
      //                             // has the effect of extending the shadow)
      //                             ),
      //                         BoxShadow(
      //                             color: Colors.white,
      //                             blurRadius: 0,
      //                             spreadRadius: -whiteShadowDelta,
      //                             offset: whiteShadowOffset),
      //                         BoxShadow(
      //                           color: Colors.black.withAlpha(70),
      //                           blurRadius: 20.0,
      //                           // has the effect of softening the shadow
      //                           spreadRadius: 2,
      //                           // has the effect of extending the shadow)
      //                         ),
      //                       ]
      //                     ]),
      //                 height: co.maxHeight,
      //                 width: MediaQuery.of(context).size.width,
      //                 child: ClipRRect(
      //                   borderRadius: BorderRadius.circular(borderRadius),
      //                   child: Stack(
      //                     children: <Widget>[
      //                       Navigator(
      //                         initialRoute: initRoutrName,
      //                         onGenerateRoute: (RouteSettings settings) {
      //                           final Widget child =
      //                               RouteManager.getPageFromKey(settings.name);
      //                           return RippleRoute(
      //                             Builder(
      //                               builder: (BuildContext c) {
      //                                 pushContext = c;
      //                                 return child;
      //                               },
      //                             ),
      //                             RouteConfig.fromSize(
      //                               Size(
      //                                 MediaQuery.of(context).size.width,
      //                                 MediaQuery.of(context).size.height,
      //                               ),
      //                             ),
      //                           );
      //                         },
      //                       ),
      //                       if (drawerNotifier.isOpen)
      //                         InkWell(
      //                           onTap: () {
      //                             drawerNotifier.closeDrawer();
      //                           },
      //                         ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             );
      //           },
      //         );
      //       },
      //     );
      // }
      // return const Text('');
    );
  }
}

class PagingScrollPhysics extends ScrollPhysics {
  const PagingScrollPhysics(
      {this.drawerNotifier,
      this.maxSize,
      this.itemDimension,
      ScrollPhysics parent})
      : super(parent: parent);

  final double itemDimension; // ListView children item 固定宽度
  final double maxSize; // 最大可滑动区域
  final DrawerNotifier drawerNotifier;

  @override
  PagingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return PagingScrollPhysics(
        drawerNotifier: drawerNotifier,
        maxSize: maxSize,
        itemDimension: itemDimension,
        parent: buildParent(ancestor));
  }

  double _getPage(ScrollPosition position) {
    return (position.pixels) / itemDimension;
  }

  double _getPixels(
    double page,
  ) {
    return page * itemDimension;
  }

  double _getTargetPixels(
    ScrollPosition position,
    Tolerance tolerance,
    double velocity,
  ) {
    double page = _getPage(
      position,
    );

    if (position.pixels <= 0) {
      return 0;
    }

    if (position.pixels >= maxSize) {
      return maxSize;
    }

    if (position.pixels > 0) {
      if (velocity < -tolerance.velocity) {
        page -= 0.5;
      } else if (velocity > tolerance.velocity) {
        page += 0.5;
      }
      return _getPixels(page.roundToDouble());
    }
    return null;
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (drawerNotifier.isScroll) {
      return null;
    }
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.

    if (velocity <= 0.0 && position.pixels <= position.minScrollExtent) {
      return super.createBallisticSimulation(position, velocity);
    }

    final Tolerance tolerance = this.tolerance;
    final SpringDescription _kDefaultSpring =
        SpringDescription.withDampingRatio(
      mass: 0.5,
      stiffness: 100.0,
      ratio: 1.1,
    );

    final double target = _getTargetPixels(
      position as ScrollPosition,
      tolerance,
      velocity,
    );
    if (target != position.pixels)
      return ScrollSpringSimulation(
          _kDefaultSpring, position.pixels, target, velocity,
          tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
