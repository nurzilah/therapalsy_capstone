import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class DeteksiController extends GetxController {
  final box = GetStorage();
  final apiUrl = 'https://evidently-moved-marmoset.ngrok-free.app/api/detection';

  Future<void> saveDetectionResult({required bool isPositive}) async {
    final token = box.read('token');
    final userId = box.read('user_id');

    if (token == null || userId == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    final response = await http.post(
      Uri.parse('$apiUrl/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'user_id': userId,
        'prediction': isPositive ? 'positive' : 'normal',
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      Get.snackbar('Success', 'Detection result saved');
    } else {
      Get.snackbar('Error', 'Failed to save detection: ${response.body}');
    }
  }
}
