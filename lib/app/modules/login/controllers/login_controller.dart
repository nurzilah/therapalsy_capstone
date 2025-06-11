import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:therapalsy_capstone/app/modules/auth/services/auth_services.dart';
import 'package:therapalsy_capstone/app/routes/app_pages.dart';
import 'package:therapalsy_capstone/app/modules/models/user_model.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<void> login() async {
    try {
      final response = await http.post(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/auth/login'),
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

  void loginWithGoogle() async {
    print("[DEBUG] loginWithGoogle() dipanggil");
    try {
      await _googleSignIn.signOut();
      final account = await _googleSignIn.signIn();

      if (account != null) {
        final auth = await account.authentication;

        final idToken = auth.idToken;

        if (idToken != null) {
          isLoading.value = true;
          final user = await AuthServices.googleLogin(idToken);
          isLoading.value = false;

          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('token', user.token);
          // await prefs.setString('email', user.user.email);
          // await prefs.setString('username', user.user.username);
          // await prefs.setString('user_id', user.user.id);

          // final box = GetStorage();
          // box.write('username', user.user.username);
          // box.write('email', user.user.email);
          // box.write('hasPassword', user.user.hasPassword);

          if (user.user.hasPassword == false) {
            Get.offAllNamed(Routes.HOME,
                arguments: {'needSetPassword': true});
          } else {
            Get.snackbar(
                'Login Berhasil', 'Selamat datang ${user.user.username}!');
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          Get.snackbar('Error', 'Gagal mendapatkan token dari Google');
        }
      } else {}
    } catch (e) {
      isLoading.value = false;
      print("Google login error: $e");
      Get.snackbar('Error', 'Gagal login dengan Google');
    }
  }
}
