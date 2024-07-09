import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:pocketkeeper/application/member_cache.dart';

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

// Load Uint8List to XFile
Future<XFile> loadUint8ListAsXFile(Uint8List bytes) async {
  // Get the temporary directory
  Directory tempDir = await getTemporaryDirectory();

  // Random file name
  String randomFileName = DateTime.now().millisecondsSinceEpoch.toString();

  // Create a temporary file
  File file =
      await File(path.join(tempDir.path, '$randomFileName.jpg')).create();

  // Write bytes to the file
  file.writeAsBytesSync(bytes);

  // Convert File to XFile
  return XFile(file.path);
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

// This function is to count remaining days until the end of the month (Set by user)
int getRemainingDayUntilNextMonth() {
  final now = DateTime.now();
  final endOfMonth = MemberCache.appSetting.endOfMonth;

  // Get last day of the month and calculate difference from now
  if (endOfMonth == 30) {
    return DateTime(now.year, now.month + 1, 0).day - now.day;
  }
  // If end of month is less than current day (eg: user set 7th), calculate remaining days until 7th
  else if (endOfMonth < now.day) {
    return DateTime(now.year, now.month + 1, endOfMonth).difference(now).inDays;
  } else {
    return endOfMonth - now.day;
  }
}
