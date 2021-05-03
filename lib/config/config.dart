import 'dart:io';

class FastbootConfig {
  FastbootConfig._();

  static String flutterPackage = '';
  static String version = '1.0.7';
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
  static double drawerWidth = 260;
}
