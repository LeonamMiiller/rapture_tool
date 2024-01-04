import 'dart:io';
import 'package:bw_utils/bw_utils.dart';
import 'package:path/path.dart';
import 'package:rapture_tool/rapture.dart';
import 'package:rapture_tool/rapture_switch.dart';

abstract class Bioshock {
  final RandomAccessFile file;
  late String coalescedFileName;
  List<CoalescedIniFile> iniFile = [];

  Bioshock({required this.file});

  void export() {
    String extractPath = '${dirname(file.path)}/$coalescedFileName';
    Directory(extractPath).createSync(recursive: true);

    for (var file in iniFile) {
      String path = '${extractPath}/${file.fileName}';
      File(path).writeAsBytesSync(file.file);
    }
  }

  void import() {
    String searchPath = '${dirname(file.path)}/$coalescedFileName';

    RandomAccessFile newFile = (File('${file.path}_new')
          ..createSync(recursive: true))
        .openSync(mode: FileMode.write);

    for (var file in iniFile) {
      final String filePath = '${searchPath}/${file.fileName}';
      if (File(filePath).existsSync()) {
        file.file = File(filePath).readAsBytesSync();
      } else {
        print('file: ${filePath} not found.');
      }

      newFile.writeFromSync([file.header.length ~/ 2]);
      newFile.writeFromSync(file.header);
      newFile.writeFromSync(_getLenght(file.file.length));
      newFile.writeFromSync(file.file);
    }
  }

  List<int> _getLenght(int lenght) {
    List<int> fileLenght = [];

    if (runtimeType == Rapture) {
      fileLenght = (this as Rapture).calcFileLenght(lenght);
    }

    if (runtimeType == RaptureSwitch) {
      fileLenght = lenght.toUint32List();
    }

    return fileLenght;
  }
}

class CoalescedIniFile {
  final String fileName;
  List<int> header;
  List<int> file;

  CoalescedIniFile({
    required this.fileName,
    required this.header,
    required this.file,
  });
}
