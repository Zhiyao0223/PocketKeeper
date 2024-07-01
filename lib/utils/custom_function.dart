import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/*
  Check for image file size
  Return compressed image if file size is larger than 10MB
  */
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

Future<XFile> loadAssetAsXFile(String assetPath) async {
  // Load the asset as ByteData
  ByteData byteData = await rootBundle.load(assetPath);

  // Convert ByteData to Uint8List
  Uint8List bytes = byteData.buffer.asUint8List();

  // Get the temporary directory
  Directory tempDir = await getTemporaryDirectory();

  // Create a temporary file
  File file = await File(path.join(tempDir.path, 'temp_image.jpg')).create();

  // Write bytes to the file
  file.writeAsBytesSync(bytes);

  // Convert File to XFile
  return XFile(file.path);
}
