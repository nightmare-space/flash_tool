import 'package:flash_tool/flash_tool.dart';
import 'package:flutter/material.dart';

class FlashToolDesktop extends StatefulWidget {
  @override
  _FlashToolDesktopState createState() => _FlashToolDesktopState();
}

class _FlashToolDesktopState extends State<FlashToolDesktop> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: <Widget>[
          MediaQuery(
            data: MediaQueryData(
              size: Size(
                MediaQuery.of(context).size.width / 5,
                MediaQuery.of(context).size.height,
              ),
            ),
            child: FlashDrawer(
              onChange: (int index) {
                pageIndex = index;
                setState(() {});
              },
            ),
          ),
          MediaQuery(
            data: MediaQueryData(
              size: Size(
                MediaQuery.of(context).size.width * 4 / 5,
                MediaQuery.of(context).size.height,
              ),
            ),
            child: FlashToolBody(
              pageIndex: pageIndex,
            ),
          ),
        ],
      ),
    );
  }
}
