import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:therapalsy_capstone/app/modules/auth/services/auth_services.dart';
import 'package:therapalsy_capstone/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  final isLoading = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: '888475508285-ipmk1l0t86ep59itk2vf70crm9eaja2o.apps.googleusercontent.com',
  );

  // final String baseUrl = 'https://177e-163-227-64-50.ngrok-free.app/auth'; // Ganti IP sesuai backend

  // Future<void> register() async {
  //   isLoading.value = true;
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/register'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'username': usernameController.text,
  //       'email': emailController.text,
  //       'password': passwordController.text,
  //     }),
  //   );
  //   isLoading.value = false;

  //   if (response.statusCode == 201) {
  //     Get.snackbar('Success', 'Check email for OTP verification');
  //   } else {
  //     Get.snackbar('Error', jsonDecode(response.body)['message']);
  //   }
  // }

  // Future<void> login() async {
  //   isLoading.value = true;
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/login'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'email': emailController.text,
  //       'password': passwordController.text,
  //     }),
  //   );
  //   isLoading.value = false;

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     Get.snackbar('Welcome', data['data']['username']);
  //     // Simpan token kalau perlu
  //   } else {
  //     Get.snackbar('Login Failed', jsonDecode(response.body)['message']);
  //   }
  // }

    void loginWithGoogle() async {
  print("[DEBUG] loginWithGoogle() dipanggil");

  try {
    await _googleSignIn.signOut(); // Bersihkan sesi sebelumnya
    print("[DEBUG] signOut selesai");

    final account = await _googleSignIn.signIn();
    print("[DEBUG] hasil signIn(): $account");

    if (account != null) {
      final auth = await account.authentication;
      print("[DEBUG] account.authentication selesai");

      final idToken = auth.idToken;
      final accessToken = auth.accessToken;

      print("✅ Google account: ${account.email}");
      print("✅ ID Token: $idToken");
      print("✅ Access Token: $accessToken");

      if (idToken != null) {
        isLoading.value = true;
        final user = await AuthServices.googleLogin(idToken);
        isLoading.value = false;

        if (user.user.hasPassword == false) {
          print("[DEBUG] User belum punya password, ke HOME dengan argumen");
          Get.offAllNamed(Routes.HOME, arguments: {'needSetPassword': true});
        } else {
          print("[DEBUG] User login sukses, ke HOME");
          Get.snackbar('Login Berhasil', 'Selamat datang ${user.user.username}!');
          Get.offAllNamed(Routes.HOME);
        }
      } else {
        print("❌ Gagal dapatkan ID token");
        Get.snackbar('Error', 'Gagal mendapatkan token dari Google');
      }
    } else {
      print("⚠️ Google sign-in dibatalkan user.");
      Get.snackbar('Login Dibatalkan', 'Anda membatalkan login dengan Google');
    }
  } catch (e, stack) {
    isLoading.value = false;
    print("❌ Exception: $e");
    print("Stacktrace:\n$stack");
    Get.snackbar('Error', 'Gagal login dengan Google: $e');
  }
}

}
