import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

class RegisterController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var name = ''.obs;
  var confirmPassword = ''.obs;

  Future<void> registerUser() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Password dan konfirmasi tidak sama!');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://177e-163-227-64-50.ngrok-free.app/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': name.value,
          'email': email.value,
          'password': password.value,
        }),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Berhasil', 'OTP dikirim ke email');
        Get.toNamed('/otp', arguments: {'email': email.value});
      } else {
        Get.snackbar('Gagal', jsonDecode(response.body)['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghubungi server: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        serverClientId: '888475508285-vv1sgvf71ehn12d4evdsdaf3gbmg5ttv.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final idToken = googleAuth?.idToken;

      if (idToken == null) {
        Get.snackbar('Error', 'Google ID Token tidak tersedia');
        return;
      }

      final response = await http.post(
        Uri.parse('https://177e-163-227-64-50.ngrok-free.app/api/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Berhasil login dengan Google');
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Gagal', jsonDecode(response.body)['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Google login error: $e');
    }
  }
}
