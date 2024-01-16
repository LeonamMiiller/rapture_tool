import 'dart:io';
import 'dart:typed_data';
import 'package:bw_utils/bw_utils.dart';
import 'package:charset/charset.dart';
import 'package:path/path.dart';
import 'package:rapture_tool/rapture.dart';
import 'package:rapture_tool/rapture_switch.dart';

abstract class Bioshock {
  late RandomAccessFile file;
  late String coalescedFileName;
  List<CoalescedIniFile> iniFile = [];

  Bioshock({required this.file});

  Bioshock.newFile(Directory path) {
    final String newFilePath = split(path.path).last;

    for (final inifile in path.listSync()) {
      final String fileName = basename(inifile.path);
      final List<int> header = _fileNameToHeader(fileName);
      final List<int> newFile = (inifile as File).readAsBytesSync();
      iniFile.add(
          CoalescedIniFile(fileName: fileName, header: header, file: newFile));
    }

     _saveNewFile('$newFilePath.lbf');
  }

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

    for (var file in iniFile) {
      final String filePath = '${searchPath}/${file.fileName}';
      if (File(filePath).existsSync()) {
        file.file = File(filePath).readAsBytesSync();
      } else {
        print('file: ${filePath} not found.');
      }
    }

    _saveNewFile('${file.path}_new');
  }

  List<int> _fileNameToHeader(String fileName) {
    Utf16Encoder encoder = utf16.encoder as Utf16Encoder;
    List<int> header = [];

    if (this is Rapture) {      
      header.addAll(encoder.encodeUtf16Be(fileName));
    }

    if (this is RaptureSwitch) {
      header.addAll(encoder.encodeUtf16Le(fileName));
    }

    return header..addAll([0,0]);
  }

  void _saveNewFile(String path) {
    RandomAccessFile newFile = (File(path)..createSync(recursive: true))
        .openSync(mode: FileMode.write);

    for (final file in iniFile) {
      newFile.writeFromSync([file.header.length ~/ 2]);
      newFile.writeFromSync(file.header);
      newFile.writeFromSync(_getLenght(file.file.length));
      newFile.writeFromSync(file.file);
    }
    newFile.closeSync();
  }

  List<int> _getLenght(int lenght) {
    List<int> fileLenght = [];

    if (runtimeType == Rapture) {
      fileLenght = (this as Rapture).calcFileLenght(lenght);
    }

    if (runtimeType == RaptureSwitch) {
      fileLenght = lenght.toUint32List(Endian.little);
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
