import 'dart:io';
import 'package:archive/archive.dart';

saveFileZip(List<int> bytes, String filename) {
  Directory dir = Directory.current;
  print("dir > ${dir.path}");
  File file = File(dir.path + '/$filename.zip');
  file.writeAsBytesSync(bytes);
}

decompactFileZip(String fileZip) {
  Directory dir = Directory.current;
  List<int> bytes = File(dir.path + '/$fileZip.zip').readAsBytesSync();

  Archive archive = ZipDecoder().decodeBytes(bytes);

  for (ArchiveFile file in archive) {
    String filename = file.name;
    print("filename: $filename");
    if (file.isFile) {
      List<int> data = file.content;
      File("${dir.path}/" + filename)
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    } else {
      Directory("${dir.path}/" + filename)..create(recursive: true);
    }
  }
}
