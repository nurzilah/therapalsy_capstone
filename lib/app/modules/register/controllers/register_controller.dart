import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class RegisterController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var name = ''.obs;
  var confirmPassword = ''.obs;
  var isLoading = false.obs;

  final box = GetStorage();

  Future<void> registerUser() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Password and confirmation do not match!');
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': name.value,
          'email': email.value,
          'password': password.value,
        }),
      );

      isLoading.value = false;

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'OTP has been sent to your email');
        Get.toNamed('/otp', arguments: {'email': email.value});
      } else {
        Get.snackbar('Failed', jsonDecode(response.body)['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Server error: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email'],
        serverClientId: '888475508285-vv1sgvf71ehn12d4evdsdaf3gbmg5ttv.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final idToken = googleAuth?.idToken;

      if (idToken == null) {
        Get.snackbar('Error', 'Google ID Token is not available');
        return;
      }

      final response = await http.post(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['data'];
        final token = data['access_token'];

        box.write('token', token);
        box.write('user_id', user['id']);

        Get.snackbar('Success', 'Logged in with Google');
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Failed', jsonDecode(response.body)['message'] ?? 'Login failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Google login error: $e');
    }
  }
}