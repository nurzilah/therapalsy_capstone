import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ChangepasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final box = GetStorage();

  final apiUrl = 'https://evidently-moved-marmoset.ngrok-free.app/api/user/change-password';

  void changePassword() async {
    final token = box.read('token');
    if (token == null) {
      Get.snackbar('Error', 'Token tidak ditemukan. Silakan login ulang.');
      return;
    }

    final oldPassword = oldPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validasi
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Semua field wajib diisi');
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Password baru dan konfirmasi tidak cocok');
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar('Berhasil', 'Password berhasil diubah');
      Get.back();
    } else {
      final body = jsonDecode(response.body);
      Get.snackbar('Gagal', body['message'] ?? 'Terjadi kesalahan');
    }
  }
}
