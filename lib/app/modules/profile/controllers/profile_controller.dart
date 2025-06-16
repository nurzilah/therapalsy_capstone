import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var profileImage = ''.obs;
  var lastLogin = ''.obs;

  final box = GetStorage();
  final apiUrl = 'https://evidently-moved-marmoset.ngrok-free.app/api/user';

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  void fetchProfile() async {
    final token = box.read('token');
    if (token == null) {
      Get.snackbar('Error', 'Token tidak ditemukan');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      print("🟢 Status: ${response.statusCode}");
      print("📦 Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        username.value = data['username'] ?? '';
        email.value = data['email'] ?? '';
        profileImage.value = data['profileImage'] ?? '';
        lastLogin.value = data['last_login'] ?? '';
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('Error', error['message'] ?? 'Gagal mengambil data profil');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  void logout() {
    box.erase();
    Get.offAllNamed('/login');
  }
}
