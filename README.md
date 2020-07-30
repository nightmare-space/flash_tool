# flash_tool

这是使用 Flutter 框架开发的线刷工具，为了方便单独维护。
封装成dart package 的形式，可以在任何地方复用这个组件。

Language: 中文简体 | [English](https://github.com/nightmare-space/flash_tool/blob/master/README-EN.md)

## 支持的平台
- [x] windows
- [x] macos
- [x] linux
- [x] android
> 很抱歉在经过很久的尝试后，在android平台工具的运行依然无法脱离root权限，因为需要拿到 usb 端的高级权限。

## 为什么要选择要自己开发一个线刷工具？
- 在没有这类工具前，我们可能更多使用MiFlash，的确也非常的方便，但是一些开发者是使用 Linux 或者 Macos 的操作系统，在偶尔的遇到线刷的需求时，就只能通过命令行来刷写 rec 、 rom 。
- 需要频繁的刷入rec，rom，reboot edl，fastboot unlock，单个分区，这个时候就不妨使用一个可视化的工具来完成这一切，对用户而言，只需要勾选对应的选项即可。

## 为什么不是一个命令行？
你可能会想将这样功能的一个工具编写成bat,与shell的方式，然后打印出对应的一些输出，如下：
```shell
1.小米10
2.小米11
请输入你想刷入的设备:
```
简言之，我觉得这种方式始终太 low。


## 为什么使用Flutter？
- Flutter 一直是我认为非常优秀的跨平台框架，我想使用它来作为之后绝大部分工具的开发。
- 我不想关注太多我在 windows 、macos 、linux ,或者是我的 android 设备上的各种平台特性，也不想我会为了开发各个平台的工具花费了大量的学习成本。只需要一套代码，可以编译到各个平台。
- 包括热重载，热重启，等等，都是我选择 Fluter 框架的理由。



## 下载
考虑到中国用户，我提供了一个蓝奏云的连接。



## 编译

这是一个 Flutter 的项目，如果你想要自行编译该项目，请移步到 [Flutter 文档](https://flutter.dev/docs),


