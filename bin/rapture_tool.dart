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

  if (valid.canCreate()) {
    _create(valid.platform, args[2]);
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

void _create(String platform, String path) {
  if (platform == '-nx') {
    RaptureSwitch.create(Directory(path));
  }
  if (platform == '-px') {
    Rapture.create(Directory(path));
  }
}
