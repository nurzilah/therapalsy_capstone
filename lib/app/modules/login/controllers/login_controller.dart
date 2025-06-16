import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  final box = GetStorage();

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
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final device = await getDeviceName();
      final response = await http.post(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.value,
          'password': password.value,
          'device': device,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['data'];
        final token = data['access_token'];

        box.write('token', token);
        box.write('user_id', user['id']);

        Get.snackbar('Welcome', user['username']);
        Get.offAllNamed('/home');
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('Login Failed', error['message'] ?? 'Unknown error');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      clientId: '888475508285-5id3vm5h8rl2sf28pfthqc44cul5mfbv.apps.googleusercontent.com',
      scopes: ['email'],
    );

    try {
      // ⛔️ Tambahkan ini untuk mencegah auto-login akun sebelumnya
      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn(); // ⬅️ Sekarang akan tampil pilihan akun
      final googleAuth = await googleUser?.authentication;

      final idToken = googleAuth?.idToken;
      if (idToken == null) {
        Get.snackbar("Error", "ID Token kosong");
        return;
      }

      final response = await http.post(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/google-login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_token": idToken,
          "device": "Flutter",
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final user = data['user'];
        final token = data['token'];

        if (user == null || user['id'] == null) {
          Get.snackbar("Error", "Data user tidak lengkap");
          return;
        }

        box.write('token', token);
        box.write('user_id', user['id']);
        Get.snackbar("Welcome", "${user['username']} berhasil login");
        Get.offAllNamed('/home');
      } else {
        Get.snackbar("Error", data['error'] ?? "Login gagal");
      }
    } catch (e) {
      print("🔥 Google login error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat login Google");
    }
  }


}