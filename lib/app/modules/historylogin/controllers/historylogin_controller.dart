import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryloginController extends GetxController {
  final loginHistory = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  Future<void> fetchLoginHistory(String userId, String token) async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/user/login-history'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        loginHistory.value =
            data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        Get.snackbar('Error', 'Failed to load login history');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
