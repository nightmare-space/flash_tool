import 'dart:io';

import 'package:global_repository/global_repository.dart';
import 'package:termare_pty/termare_pty.dart';
import 'package:termare_view/termare_view.dart';
import 'app_colors.dart';
import 'config.dart';

class Global {
  // 工厂模式
  factory Global() => _getInstance();
  Global._internal() {
    String executable = '';
    if (Platform.environment.containsKey('SHELL')) {
      executable = Platform.environment['SHELL'];
      // 取的只是执行的文件名
      executable = executable.replaceAll(RegExp('.*/'), '');
    } else {
      if (Platform.isMacOS) {
        executable = 'bash';
      } else if (Platform.isWindows) {
        executable = 'wsl';
      } else if (Platform.isAndroid) {
        executable = 'sh';
      }
    }
    Log.e('RuntimeEnvir.path -> ${RuntimeEnvir.path}');
    final Map<String, String> environment = {
      'TERM': 'xterm-256color',
      'PATH': RuntimeEnvir.path,
    };
    const String workingDirectory = '.';
    pseudoTerminal = PseudoTerminal(
      column: 10,
      executable: executable,
      workingDirectory: workingDirectory,
      environment: environment,
      arguments: ['-l'],
    );
    pseudoTerminal.write('clear\n');
  }
  PseudoTerminal pseudoTerminal;
  TermareController termareController = TermareController(
    theme: TermareStyles.macos.copyWith(
      backgroundColor: AppColors.contentBorder,
    ),
  )..hideCursor();
  static Global get instance => _getInstance();
  static Global _instance;

  static Global _getInstance() {
    _instance ??= Global._internal();
    return _instance;
  }
}
