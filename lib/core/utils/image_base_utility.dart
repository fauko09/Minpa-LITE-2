import 'dart:developer';
import 'dart:io';

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageBaseUtility {
  Future<String> saveImageToFile(String base64Image, String fileName) async {
    final decodedBytes = base64Decode(base64Image);
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/$fileName';
    final file = File(imagePath);
    await file.writeAsBytes(decodedBytes);
    return imagePath;
  }

  Future<String?> compressImage(String filename, XFile file,
      {int maxSize = 2 * 1024 * 1024, int quality = 90}) async {
    Uint8List bytes = await file.readAsBytes();
    log("Bytes: ${bytes.length}");
    if (bytes.length <= maxSize) {
      final compressedFile = File(file.path);
      final bytes = await compressedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final savedPath = await saveImageToFile(base64Image, filename);
      await compressedFile.delete();
      return savedPath;
    }

    final targetPath = '${file.path}-temp.jpg';
    XFile? result;
    while (bytes.length > maxSize) {
      result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        minHeight: 500,
        minWidth: 500,
        quality: quality,
      );
      if (result == null) {
        return null;
      }
      bytes = await result.readAsBytes();
      quality -= 5;
      if (quality <= 0) {
        break;
      }
    }
    if (result == null) {
      return null;
    } else {
      Uint8List bytesAkhir = await result.readAsBytes();
      log("bytesAkhir: ${bytesAkhir.length}");
      final compressedFile = File(result.path);
      final bytes = await compressedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final savedPath = await saveImageToFile(base64Image, filename);
      await compressedFile.delete();
      return savedPath;
    }
  }
}
