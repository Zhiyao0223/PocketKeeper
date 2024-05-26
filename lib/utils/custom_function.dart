/*
  Check for image file size
  Return compressed image if file size is larger than 10MB
  */
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<XFile> compressImageSize(XFile xFile) async {
  const maxFileSize = 10000000; // 10MB

  // Get file size
  final int fileSize = File(xFile.path).lengthSync();

  // If file size is larger than 1MB, compress the image
  if (fileSize > maxFileSize) {
    // Compress the image
    List<int> compressedBytes = (await FlutterImageCompress.compressWithFile(
            File(xFile.path).absolute.path,
            quality: 50,
            format: CompressFormat.jpeg))!
        .toList();

    // Write the compressed bytes to a new file
    final tempFile = File('${xFile.path}.compressed');
    await tempFile.writeAsBytes(compressedBytes);

    // Return an XFile with the compressed image
    return XFile(tempFile.path);
  }

  return xFile;
}
