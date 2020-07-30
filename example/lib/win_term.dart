import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WinTerm extends StatefulWidget {
  const WinTerm({Key key, this.execScript = ''}) : super(key: key);
  final String execScript;

  @override
  _WinTermState createState() => _WinTermState();
}

class _WinTermState extends State<WinTerm> {
  String termOutput = '';
  TextEditingController editingController = TextEditingController();
  Process winProcess;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // envirInit();
    winProcess = await Process.start(
      'sh',
      <String>[],
      runInShell: false,
      mode: ProcessStartMode.normal,
      // mode: kReleaseMode
      //     ? ProcessStartMode.detachedWithStdio
      //     : ProcessStartMode.normal,
    );
    winProcess.stdout.transform(utf8.decoder).listen((String out) {
      termOutput += out;
      setState(() {});
    });
    winProcess.stderr.transform(utf8.decoder).listen((String out) {
      termOutput += out;
      setState(() {});
    });
    // winProcess.stdin.write(
    //     'export PATH=${PlatformUtil.getUnixPath(EnvirPath.binPath)}:\$PATH\n');
    winProcess.stdin.write('echo ----------开始执行----------\n');
    winProcess.stdin.write('${widget.execScript}\n');
    // winProcess.stdin.write(
    //     'export PATH=${PlatformUtil.getUnixPath(EnvirPath.binPath)}:\$PATH\n');
    // winProcess.stdin.writeln(widget.execScript);
    // winProcess.stdin.write('set PATH=%PATH%;${EnvirPath.filesPath}\\usr\\bin\n');

    // final ProcessResult result = await Process.run(
    //  '7za',
    //   <String>[],
    //   runInShell: true,
    //   environment: <String, String>{
    //     'PATH': '${EnvirPath.filesPath}\\usr\\bin'
    //   },
    //   includeParentEnvironment: true,
    //   stdoutEncoding: utf8,
    //   stderrEncoding: utf8,
    // );
    // outPut += result.stdout.toString();
    // outPut += result.stderr.toString();
    // setState(() {

    // });
    // for (final String line in widget.execScript.trim().split('\n')) {
    //   // String args=line.split('\\s+');
    //   List<String> cmd = line.trim().split(RegExp('\\s+'));
    //   print(cmd);
    //   List<String> tmp = cmd.toList();
    //   tmp.removeAt(0);
    //   String args = tmp.join(' ');
    //   final ProcessResult result = await Process.run(
    //     cmd.first,
    //     args == null ? <String>[] : tmp,
    //     runInShell: true,
    //     environment: <String, String>{
    //       'PATH': '${EnvirPath.filesPath}\\usr\\bin'
    //     },
    //     includeParentEnvironment: true,
    //     stdoutEncoding: utf8,
    //     stderrEncoding: utf8,
    //   );
    //   outPut += result.stdout.toString();
    //   outPut += result.stderr.toString();
    //   setState(() {});
    // }
    // winProcess.stdin.write(widget.execScript+'\n');
  }

  // StringBuffer a;
  List<InlineSpan> listSpan = <InlineSpan>[]; //富文本列表
  FocusNode focusNode = FocusNode(); //输入框焦点
  int textSelectionOffset = 0;

  @override
  void dispose() {
    winProcess.kill(ProcessSignal.sigint);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final String tmpPath = Platform.environment['Tmp'] + '\\MToolkit';
    // print("7z x -y -aoa -p906262255 ${PlatformUtil.getUnixPath(EnvirPath.binPath)}/msys-libcontext.dll -o${PlatformUtil.getUnixPath(tmpPath)}");
    listSpan.clear();
    final TextStyle textStyle = TextStyle(
      fontSize: 12.0,
      fontFamily: Platform.isWindows ? 'SourceHanSansSC-Light' : null,
    );
    for (final String a
        in termOutput.split(String.fromCharCodes(<int>[27, 91]))) {
      // print(a);
      if (a.startsWith(RegExp('[0-9]*;'))) {
        final RegExp regExp = RegExp('[0-9]*;[0-9]*m');
        final String header = regExp.firstMatch(a).group(0);
        final String colorNumber = header.split(';')[1];
        if (colorNumber == '34m')
          listSpan.add(
            TextSpan(
                text: a.replaceAll(header, ''),
                style: textStyle.copyWith(
                  color: Colors.lightBlue,
                  decoration: TextDecoration.none,
                )),
          );
        else if (colorNumber == '31m')
          listSpan.add(
            TextSpan(
              text: a.replaceAll(header, ''),
              style: textStyle.copyWith(color: const Color(0xffff0000)),
            ),
          );
        else if (colorNumber == '32m')
          listSpan.add(
            TextSpan(
              text: a.replaceAll(header, ''),
              style: textStyle.copyWith(color: Colors.lightGreenAccent),
            ),
          );
        else if (colorNumber == '36m')
          listSpan.add(
            TextSpan(
              text: a.replaceAll(header, ''),
              style: textStyle.copyWith(color: Colors.greenAccent),
            ),
          );
        else if (colorNumber == '37m')
          listSpan.add(
            TextSpan(
              text: a.replaceAll(header, ''),
              style: textStyle.copyWith(),
            ),
          );
        else if (colorNumber == '0m')
          listSpan.add(
            TextSpan(
              text: a.replaceAll(header, ''),
              style: textStyle.copyWith(color: Colors.white),
            ),
          );
      } else {
        listSpan.add(
          TextSpan(
            text: a.replaceAll(RegExp('^[0-9]*m'), ''),
            style: textStyle.copyWith(color: Colors.white),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 12.0, fontFamily: 'SourceHanSansSC-Light'),
                children: listSpan + <InlineSpan>[],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextField(
              autofocus: true,
              controller: editingController,
              focusNode: focusNode,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.transparent,
              showCursor: true,
              cursorWidth: 0,
              enabled: true,
              scrollPadding: const EdgeInsets.all(0.0),
              enableInteractiveSelection: false,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                border: InputBorder.none,
                // hasFloatingPlaceholder: false,
              ),
              onChanged: (String strCall) {
                String currentInput;
                if (editingController.selection.end > textSelectionOffset) {
                  currentInput = strCall[editingController.selection.end - 1];
                  termOutput += currentInput;
                  setState(() {});
                  //  winProcess.stdin.write(strCall );
                  // writeToFd(
                  //     Niterm.terms.first.ptm, Utf8.toUtf8(currentInput));

                } else {
                  termOutput = termOutput.substring(0, termOutput.length - 1);
                  setState(() {});
                }
                textSelectionOffset = editingController.selection.end;
              },
              onSubmitted: (String v) async {
                termOutput += '\n';
                setState(() {});
                winProcess.stdin.write(v + '\n');
                editingController.clear();

                focusNode.unfocus();
                await Future<void>.delayed(const Duration(milliseconds: 0));
                FocusScope.of(context).requestFocus(focusNode);
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              hoverColor: Colors.grey.withOpacity(.4),
              iconSize: 100,
              icon: const Icon(
                Icons.keyboard_arrow_left,
                size: 100,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
