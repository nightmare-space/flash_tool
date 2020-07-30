# flash_tool

Using flutter framewirk 

This is a line brush tool developed using the Flutter framework for easy individual maintenance.

Packaged as a Dart package, you can reuse the component anywhere.

## Supported platforms
- [x] windows
- [x] macos
- [x] linux
- [x] android
> I'm sorry that after a long time of trying, the android tools still can't run without root permissions, because you need to get advanced permissions on the USB side.

## Why choose to develop your own line brush tool?
- Before such tools, we might have used MiFlash more, which is indeed very convenient, but some developers use Linux or Macos operating systems, occasionally encounter the need to brush the line, only through the command line to brush the REC, ROM.
- You need to reC, ROM, reboot edL, Fastboot unlock, and unlock a single partition. This is when you can use a visual tool that allows you to do this by simply checking the appropriate options.

## Why not a command line?
You might want to write a tool that does this as bat, in the shell way, and then print out some of the corresponding output, as follows：
```shell
1.小米10
2.小米11
请输入你想刷入的设备:
```
In short, I think this approach is always too low.


## Why use Flutter？
- Flutter has always been what I think is a very good cross-platform framework, and I would like to use it for most of the later tool development.
- I don't want to focus too much on the various platform features that I have on Windows, MacOS, Linux, or my Android device, nor do I want to spend a lot of learning costs to develop tools for each platform. All it takes is one set of code that can be compiled to each platform.

- Hot reloading, hot restarting, etc., are all the reasons I chose the Fluter framework.

## Download
考虑到中国用户，我提供了一个蓝奏云的连接。



## Compile

This is a Flutter project, so if you want to compile it yourself, go to the [Flutter Document](https://flutter.dev/docs),


