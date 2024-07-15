import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:http/http.dart' as http;

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

// Convert XFile to Uint8List
Future<Uint8List> loadXFileAsUint8List(XFile xFile) async {
  // Read the file as bytes
  List<int> bytes = await File.fromUri(Uri.file(xFile.path)).readAsBytes();

  return Uint8List.fromList(bytes);
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

// Load Assets as Uint8List
Future<Uint8List> loadAssetAsUint8List(String assetPath) async {
  // Load the asset as ByteData
  ByteData byteData = await rootBundle.load(assetPath);

  // Convert ByteData to Uint8List
  return byteData.buffer.asUint8List();
}

Future<XFile?> downloadImageAsXFile(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final fileName = imageUrl.split('/').last;

      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/$fileName');

      await tempFile.writeAsBytes(bytes);

      return XFile(tempFile.path);
    } else {
      log('Failed to download image');
      return null;
    }
  } catch (e) {
    log('Error: $e');
    return null;
  }
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

// Get directory path
Future<String> getLocalPath() async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

// To get public storage directory path like Downloads, Picture, Movie etc.
Future<String> getPublicDirectoryPath() async {
  String path = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS);
  return path;
}

// Convert list to CSV
String convertListToCSV(Map<String, List<Map<String, dynamic>>> data) {
  String csv = '';

  // Remove unnecessary columns
  data.forEach((key, value) {
    for (var element in value) {
      element.removeWhere((key, value) => key == 'id');
      element.removeWhere((key, value) => key == 'syncStatus');
      element.removeWhere((key, value) => key == 'status');
      element.removeWhere((key, value) => key == 'image');
      element.removeWhere((key, value) => key == 'createdDate');
      element.removeWhere((key, value) => key == 'updatedDate');

      // Change value in specifc key to 'true' or 'false'
      if (element.containsKey('expensesType')) {
        element['expensesType'] == "0" ? 'expenses' : 'income';
      }
    }
  });

  // Loop through each list
  data.forEach((key, value) {
    // Add header
    csv += '$key\n';

    // Add column names
    csv += '${value[0].keys.join(',')}\n';

    // Add data
    for (var element in value) {
      csv += '${element.values.join(',')}\n';
    }

    // Add new line
    csv += '\n';
  });

  return csv;
}

// Convert list to JSON
String convertListToJSON(Map<String, List<Map<String, dynamic>>> data) {
  return jsonEncode(data);
}

// Convert JSON to list
Map<String, dynamic> convertJSONToList(String json) {
  return jsonDecode(json);
}
