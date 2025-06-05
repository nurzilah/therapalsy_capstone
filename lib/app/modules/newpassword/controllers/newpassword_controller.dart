import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewpasswordController extends GetxController {
  var newpassword = ''.obs;
  var confirmPassword = ''.obs;

  Future<void> resetPassword(String email, String otp) async {
    if (newpassword.value != confirmPassword.value) {
      Get.snackbar('Error', 'Password tidak sama');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.56.248:5000/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'new_password': newpassword.value,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password berhasil diubah');
        Get.offAllNamed('/login');
      } else {
        final msg = jsonDecode(response.body)['message'];
        Get.snackbar('Gagal', msg);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghubungi server: $e');
    }
  }
}
