import 'dart:io';
import 'package:path/path.dart';

class Valid {
  final List<String> _executionParam = ['-i', '-e'];
  final List<String> _platformsParam = ['-nx', '-px'];
  final List<String> _args;
  late int length;
  late bool containValidParams;
  late bool isImport;
  late bool isExport;
  late bool fileExists;
  late bool dirExists;
  late String platform;
  Valid({required List<String> args}) : _args = args {
    length = _args.length;
    containValidParams = _executionParam.contains(_args[0]) &&
        _platformsParam.contains(_args[1]);
    isImport = containValidParams && _args[0] == '-i';
    isExport = containValidParams && _args[0] == '-e';
    fileExists = containValidParams && File(_args[2]).existsSync();
    dirExists = fileExists &&
        Directory('${dirname(_args[2])}/${basenameWithoutExtension(_args[2])}')
            .existsSync();
    platform = _args[1];
  }

  bool canImport() {
    bool youCan = false;
    if (length == 3) {
      if (containValidParams) {
        if (isImport) {
          if (fileExists) {
            if (dirExists) {
              youCan = true;
            } else {
              printFailMessage(msgCod: 3);
            }
          } else {
            printFailMessage(msgCod: 2);
          }
        }
      } else {
        printFailMessage(msgCod: 1);
      }
    } else {
      printFailMessage(msgCod: 1);
    }
    return youCan;
  }

  bool canExport() {
    bool youCan = false;
    if (length == 3) {
      if (containValidParams) {
        if (isExport) {
          if (fileExists) {
            youCan = true;
          } else {
            printFailMessage(msgCod: 2);
          }
        }
      } else {
        printFailMessage(msgCod: 1);
      }
    } else {
      printFailMessage(msgCod: 1);
    }
    return youCan;
  }

  void printFailMessage({int msgCod = 0}) {
    switch (msgCod) {
      case 1:
        print('invalid params: \nHow to use: \n ');
        print('to import Nintendo Switch: -i -nx file/path/file.lbf');
        print('to export Nintendo Switch: -e -nx file/path/file.lbf');
        print('to import XBOX360/PS3: -i -px file/path/file.lbf');
        print('to export XBOX360/PS3: -e -px file/path/file.lbf');
        break;
      case 2:
        print('Bioshock 2 localizedXXX.lbf file not found');
        break;
      case 3:
        print('Not found exported Direcory in this folder');
        break;
      default:
    }
  }
}
