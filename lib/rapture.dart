import 'package:bw_utils/bw_utils.dart';
import 'package:charset/charset.dart';
import 'package:path/path.dart';
import 'package:rapture_tool/model/bioshock_model.dart';

class Rapture extends Bioshock {
  Rapture({required super.file}) {
    coalescedFileName = basenameWithoutExtension(file.path);
    Utf16Decoder decoder = utf16.decoder as Utf16Decoder;

    file.setPositionSync(0);

    while (file.positionSync() < file.lengthSync()) {
      final int headerLenght = file.readInt8 * 2;

      final List<int> header = file.readSync(headerLenght);

      int firstByte = file.readUint8;
      int fileLenght = firstByte;

      if (firstByte > 0x3f) {
        firstByte = file.readUint8;
        fileLenght += (firstByte - 1) * 64;

        if (firstByte > 0x7f) {
          firstByte = file.readUint8;
          fileLenght += (firstByte - 1) * 8192;
        }
      }
      fileLenght *= 2;

      final List<int> inifile = file.readSync(fileLenght);

      iniFile.add(
        CoalescedIniFile(
          fileName: decoder.decodeUtf16Be(header),
          header: header,
          file: inifile,
        ),
      );
    }

    file.closeSync();
  }

  List<int> calcFileLenght(int lenght) {
    final int value = ((lenght) ~/ 2);
    List<int> fileLenght = [];

    if (value ~/ 8192 <= 0) {
      if (value ~/ 64 <= 0) {
        fileLenght.add(value);
      } else {
        fileLenght.add(value % 64 + 64);
        fileLenght.add(value ~/ 64);
      }
    } else {
      int a = ((value % 8192 + 8192) % 64 + 64);
      int b = value % 8192 ~/ 64 + 128;
      int c = value ~/ 8192;
      fileLenght.add(a);
      fileLenght.add(b);
      fileLenght.add(c);
    }
    return fileLenght;
  }
}
