import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  Future<void> login() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.81.202:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.value,
          'password': password.value,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Login berhasil!');
        Get.offAllNamed('/home');
      } else {
        final body = jsonDecode(response.body);
        Get.snackbar('Error', body['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghubungi server: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        clientId: '888475508285-vv1sgvf71ehn12d4evdsdaf3gbmg5ttv.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final idToken = googleAuth?.idToken;

      if (idToken == null) {
        Get.snackbar('Error', 'Google ID Token tidak ditemukan');
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.81.202:5000/api/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Login Google berhasil!');
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Error', jsonDecode(response.body)['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Google Sign-In gagal: $e');
    }
  }
}
