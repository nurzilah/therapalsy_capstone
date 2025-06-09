import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpController extends GetxController {
  var otp = ''.obs;
  late String email;

  @override
  void onInit() {
    email = Get.arguments['email'] ?? '';
    super.onInit();
  }

  Future<void> verifyOtp() async {
    if (otp.value.length != 4) {
      Get.snackbar('Error', 'OTP harus 4 digit');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://177e-163-227-64-50.ngrok-free.app/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp.value}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Berhasil', 'Verifikasi berhasil, silakan login');
        Get.toNamed('/login');
      } else {
        final msg = jsonDecode(response.body)['message'];
        Get.snackbar('Gagal', msg);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal verifikasi OTP: $e');
    }
  }
}
