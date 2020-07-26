import 'dart:io';

class PlatformUtil {
  static bool isMobilePhone() {
    return Platform.isAndroid || Platform.isIOS;
  }

  static bool isDesktop() {
    return !isMobilePhone();
  }

  static String getFileName(String prePath) {
    return prePath.split(Platform.pathSeparator).last;
  }

  static String getRealPath(String prePath) {
    if (Platform.isWindows)
      return prePath.replaceAll('/', '\\').replaceAll(RegExp('/c'), 'C:');
    else
      return prePath;
  }

  static String getUnixPath(String prePath) {
    if (!RegExp('^[A-Z]:').hasMatch(prePath)) {
      return prePath.replaceAll('\\', '/');
    }
    final Iterable<Match> e = RegExp('^[A-Z]').allMatches(prePath);
    final String patch = e.elementAt(0).group(0);
    return prePath
        .replaceAll('\\', '/')
        .replaceAll(RegExp('^' + patch + ':'), '/' + patch.toLowerCase());
  }
}
