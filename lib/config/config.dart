import 'dart:io';

class Config {
  Config._();
  static String get binPah => () {
        return FileSystemEntity.parentOf(Platform.resolvedExecutable) +
            Platform.pathSeparator +
            'data' +
            Platform.pathSeparator +
            'flutter_assets' +
            Platform.pathSeparator +
            'assets' +
            Platform.pathSeparator +
            Platform.operatingSystem;
      }();
  static String get adbPath => () {
        return binPah + Platform.pathSeparator + 'adb.exe';
      }();
}
