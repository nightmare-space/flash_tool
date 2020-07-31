import 'dart:io';

import 'config.dart';

class Global {
  // 工厂模式
  factory Global() => _getInstance();
  Global._internal() {
    paltformEnvir = Map<String, String>.from(Platform.environment);
    if (Platform.isWindows) {
      paltformEnvir['PATH'] += ';${Config.binPath}';
    } else if (Platform.isAndroid) {
      paltformEnvir['PATH'] += ':/data/data/com.example.example/files';
    }
  }

  Map<String, String> paltformEnvir;
  static Global get instance => _getInstance();
  static Global _instance;

  static Global _getInstance() {
    _instance ??= Global._internal();
    return _instance;
  }
}
