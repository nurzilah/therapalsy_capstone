import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  final box = GetStorage();

  // Ambil nama device (realme, iPhone, Samsung, dll)
  Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return '${androidInfo.brand} ${androidInfo.model}';
    } else if (GetPlatform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return '${iosInfo.name} ${iosInfo.model}';
    } else {
      return 'Unknown Device';
    }
  }

  Future<void> loginUser() async {
    try {
      final device = await getDeviceName();

      final response = await http.post(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.value,
          'password': password.value,
          'device': device, // ⬅️ kirim nama device ke backend
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['data'];
        final token = data['access_token'];

        box.write('token', token);
        box.write('user_id', user['id']);

        Get.snackbar('Selamat datang', user['username']);
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Login Gagal', jsonDecode(response.body)['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Tidak dapat login: $e');
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

      final device = await getDeviceName(); // ⬅️ ambil device untuk Google login juga

      final response = await http.post(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': idToken,
          'device': device, // ⬅️ kirim ke backend
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['data'];
        final token = data['access_token'];

        box.write('token', token);
        box.write('user_id', user['id']);

        Get.snackbar('Success', 'Berhasil login dengan Google');
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Gagal', jsonDecode(response.body)['message'] ?? 'Gagal login');
      }
    } catch (e) {
      Get.snackbar('Error', 'Google login error: $e');
    }
  }
}
