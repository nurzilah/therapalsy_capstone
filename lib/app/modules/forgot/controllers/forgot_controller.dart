import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotController extends GetxController {
  var email = ''.obs;

  Future<void> sendForgotRequest() async {
    try {
      final response = await http.post(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.value}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Berhasil', 'Kode OTP telah dikirim ke email.');
        Get.toNamed('/otp-reset', arguments: {'email': email.value});
      } else {
        final msg = jsonDecode(response.body)['message'];
        Get.snackbar('Gagal', msg);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghubungi server');
    }
  }
}
