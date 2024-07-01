import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

extension XFileExtension on XFile {
  // Convert to image
  Future<Uint8List> getBytesFromImage() async {
    return await readAsBytes();
  }
}
