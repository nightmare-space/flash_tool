import 'dart:io';

import 'package:flutter/material.dart';

void showToast({@required BuildContext context, @required String message}) {
  //创建一个OverlayEntry对象
  final OverlayEntry overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      //外层使用Positioned进行定位，控制在Overlay中的位置
      return Positioned(
        top: MediaQuery.of(context).size.height * 0.88,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Material(
              color: Colors.white,
              shadowColor: Colors.grey.withOpacity(0.4),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              elevation: 12.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 4.0, bottom: 4.0, right: 8.0),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontFamily:
                          Platform.isLinux ? 'SourceHanSansSC-Light' : null,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
  //往Overlay中插入插入OverlayEntry
  Overlay.of(context).insert(overlayEntry);
  //两秒后，移除Toast
  Future<void>.delayed(const Duration(milliseconds: 1500)).then((_) {
    overlayEntry.remove();
  });
}
