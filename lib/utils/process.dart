import 'dart:async';
import 'dart:convert';
import 'dart:io';

abstract class NightmareProcess extends Process {}

typedef ProcessCallBack = void Function(String output);

class CustomProcess {
  CustomProcess(this.callback);
  final ProcessCallBack callback;
  static Process _process;
  static bool isUseing = false;
  static Process get process => _process;
  String exitCode = '';
  static String getlsPath() {
    if (Platform.isAndroid)
      return '/system/bin/ls';
    else
      return 'ls';
  }

  static Future<void> _init() async {
    print('Process初始化');
    _process = await Process.start(
      'su',
      <String>[],
      includeParentEnvironment: true,
      runInShell: false,
    );
    processStderr.transform(utf8.decoder).listen((String event) {
      print('默认监听错误输出=======$event');
    });
  }

  static Stream<List<int>> processStdout = _process.stdout.asBroadcastStream();
  static Stream<List<int>> processStderr = _process.stderr.asBroadcastStream();
  static Future<String> exec(String script,
      {ProcessCallBack callback,
      bool getStdout = true,
      bool getStderr = false}) async {
    while (isUseing) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    isUseing = true;
    if (_process == null) {
      /// 如果初始为空需要城初始化Process
      await _init();
    }
    String output = '';
    // _process.stdout.listen()..

    _process.stdin.write(script + '\necho exitCode\n');
    // _process.stdin.write(script + '\necho exitCode\necho exitCode >&2\n');
    if (getStdout)
      await processStdout.transform(utf8.decoder).every((String v) {
        output += v;
        callback?.call(v);
        // print('$script来自监听的打印$v');
        if (output.contains('exitCode'))
          return false;
        else
          return true;
      });
    if (getStderr) {
      await processStderr.transform(utf8.decoder).every((String v) {
        output += v;
        callback?.call(v);
        // print('$script来自监听的打印$v');
        if (output.contains('exitCode')) {
          print('检查到exit');
          return false;
        } else
          return true;
      });
    }
    isUseing = false;
    return output.replaceAll('exitCode', '').trim();
  }
}
