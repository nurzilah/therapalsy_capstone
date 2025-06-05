import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpResetController extends GetxController {
  var email = ''.obs;
  var otp = ''.obs;

  Future<void> verifyOtpAndProceed() async {
    try {
      final emailValue = email.value;
      final otpValue = otp.value;

      if (emailValue.isEmpty || otpValue.isEmpty) {
        Get.snackbar("Error", "Email dan OTP tidak boleh kosong.");
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.81.202:5000/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailValue,
          'otp': otpValue,
          'new_password': '', // nanti dikirim di new password
        }),
      );

      if (response.statusCode == 400 || response.statusCode == 404) {
        final message = jsonDecode(response.body)['message'];
        Get.snackbar('Gagal', message);
        return;
      }

      // Jika OTP valid, lanjut ke halaman new password
      Get.toNamed('/new-password', arguments: {
        'email': emailValue,
        'otp': otpValue,
      });
    } catch (e) {
      Get.snackbar("Error", "Gagal menghubungi server: $e");
    }
  }
}
