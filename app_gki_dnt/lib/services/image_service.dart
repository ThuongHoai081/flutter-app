import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File;
//import 'dart:html' as html;

class ImageService {
  static const String cloudName = 'didq8a2qn';
  static const String apiKey = '958368174899322';
  static const String apiSecret = '4QIXyatViYWnYiupJMlcN8EdxB8';

  final picker = ImagePicker();

  Future<String?> uploadImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        print('❌ Không có ảnh được chọn');
        return null;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final signature = _generateSignature(timestamp);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
      )
        ..fields['api_key'] = apiKey
        ..fields['timestamp'] = timestamp.toString()
        ..fields['signature'] = signature;

      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: pickedFile.name,
        );
        request.files.add(multipartFile);
      } else {
        final multipartFile =
            await http.MultipartFile.fromPath('file', pickedFile.path);
        request.files.add(multipartFile);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final resData = json.decode(resStr);
        print('✅ Upload thành công: ${resData['secure_url']}');
        return resData['secure_url'];
      } else {
        print('❌ Upload thất bại - Mã lỗi: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Lỗi upload: $e');
      return null;
    }
  }

  String _generateSignature(int timestamp) {
    final rawSignature = 'timestamp=$timestamp$apiSecret';
    return sha1.convert(utf8.encode(rawSignature)).toString();
  }
}
