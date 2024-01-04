import 'dart:io';

import 'package:rapture_tool/rapture.dart';
import 'package:rapture_tool/rapture_switch.dart';

import 'utils.dart';

void main(List<String> args) {
  
  final valid = Valid(args: args);

  if (valid.canExport()) {
    _export(valid.platform, File(args[2]).openSync());
  }

  if (valid.canImport()) {
    _import(valid.platform, File(args[2]).openSync());
  }
}

void _import(String platform, RandomAccessFile file) {
  if (platform == '-nx') {
    RaptureSwitch(file: file).import();
  }
  if (platform == '-px') {
    Rapture(file: file).import();
  }
}

void _export(String platform, RandomAccessFile file) {
  if (platform == '-nx') {
    RaptureSwitch(file: file).export();
  }
  if (platform == '-px') {
    Rapture(file: file).export();
  }
}
