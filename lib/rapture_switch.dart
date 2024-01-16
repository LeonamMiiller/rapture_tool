import 'package:bw_utils/bw_utils.dart';
import 'package:charset/charset.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:rapture_tool/model/bioshock_model.dart';

class RaptureSwitch extends Bioshock {
  RaptureSwitch.create(super.path) : super.newFile();

  RaptureSwitch({required super.file}) {
    Utf16Decoder decoder = utf16.decoder as Utf16Decoder;
    coalescedFileName = basenameWithoutExtension(file.path);
    setEndian(Endian.little);

    final numToMultiply = 2;
    file.setPositionSync(0);

    while (file.positionSync() < file.lengthSync()) {
      final int headerLenght = file.readInt8 * numToMultiply;

      final List<int> header = file.readSync(headerLenght);

      final int fileLenght = file.readUint32();
      final List<int> inifile = file.readSync(fileLenght);

      iniFile.add(
        CoalescedIniFile(
          fileName: decoder.decodeUtf16Le(header),
          header: header,
          file: inifile,
        ),
      );
    }

    file.closeSync();
  }
}
