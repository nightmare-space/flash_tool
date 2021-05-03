import 'dart:ui';

import 'package:flash_tool/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

// ignore: use_key_in_widget_constructors
class FlashToolScaffold extends StatefulWidget {
  const FlashToolScaffold({
    Key key,
    this.drawer,
    this.body,
  }) : super(key: key);

  final Widget drawer;
  final Widget body;

  @override
  _FlashToolScaffoldState createState() => _FlashToolScaffoldState();
}

class _FlashToolScaffoldState extends State<FlashToolScaffold>
    with SingleTickerProviderStateMixin {
  ScrollController controller;
  double scale = 0;
  @override
  void initState() {
    super.initState();
    controller = ScrollController(
      initialScrollOffset: drawerWidth,
    );
    controller.addListener(() {
      scale = 0.2 - (controller.offset / drawerWidth) * 0.2;
      setState(() {});
    });
  }

  double drawerWidth = FastbootConfig.drawerWidth;

  double borderRadius = 30;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        cacheExtent: 0.0,
        controller: controller,
        physics: PagingScrollPhysics(
          maxSize: drawerWidth,
          itemDimension: drawerWidth,
        ),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          if (widget.drawer != null)
            GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () {
                print('object');
              },
              child: Builder(
                builder: (BuildContext context) {
                  return Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()..scale(0.8 + scale),
                    child: widget.drawer,
                  );
                },
              ),
            ),
          // 为了能让Drawer销毁
          // Container(
          //   color: Colors.transparent,
          //   width: 4.0,
          // ),
          Builder(
            builder: (BuildContext context) {
              // print('$scale');
              final double drawerDelta = scale / 0.2;
              final double whiteShadowDelta = borderRadius / 2 * drawerDelta;
              final Offset whiteShadowOffset = Offset(-2 * whiteShadowDelta, 0);
              return Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()..scale(1.0 - scale),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: <BoxShadow>[
                      ...<BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 20.0,
                          // has the effect of softening the shadow
                          spreadRadius: -whiteShadowDelta,
                          offset: whiteShadowOffset,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 0,
                          spreadRadius: -whiteShadowDelta,
                          offset: whiteShadowOffset,
                        ),
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 20.0,
                          spreadRadius: 2,
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
                        if (widget.body != null) widget.body,
                        // if (drawerNotifier.isOpen)
                        //   Material(
                        //     color: Colors.transparent,
                        //     child: InkWell(
                        //       onTap: () {
                        //         drawerNotifier.closeDrawer();
                        //       },
                        //     ),
                        //   )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PagingScrollPhysics extends ScrollPhysics {
  const PagingScrollPhysics({
    this.maxSize,
    this.itemDimension,
    ScrollPhysics parent,
  }) : super(parent: parent);

  final double itemDimension; // ListView children item 固定宽度
  final double maxSize; // 最大可滑动区域

  @override
  PagingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return PagingScrollPhysics(
      maxSize: maxSize,
      itemDimension: itemDimension,
      parent: buildParent(ancestor),
    );
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
        _kDefaultSpring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
