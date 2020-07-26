import 'package:flutter/foundation.dart';

class DevicesState extends ChangeNotifier {
  String curDevice = '';
  bool lock = false;
  void setDevice(String id) {
    curDevice = id;
    notifyListeners();
  }

  void setLock() {
    lock = true;
  }

  void unLock() {
    lock = false;
  }
}
