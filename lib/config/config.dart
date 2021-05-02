import 'dart:io';

class Config {
  Config._();
  static String packageName = 'data/data/com.example.example/files';
  static String get binPath => () {
        if (Platform.isAndroid) {
          return 'data/data/com.example.example/files';
        }
        return <String>[
          FileSystemEntity.parentOf(Platform.resolvedExecutable),
          'data',
          'flutter_assets',
          'assets',
          Platform.operatingSystem,
        ].join(Platform.pathSeparator);
      }();
  static String get adbPath => () {
        return binPath + Platform.pathSeparator + 'adb.exe';
      }();
}
