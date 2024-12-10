import 'dart:typed_data';

class UploadFile {
  const UploadFile({
    this.fileName = '',
    this.filePath,
    required this.bytes,
  });

  final String fileName;
  final String? filePath;
  final Uint8List bytes;
}
