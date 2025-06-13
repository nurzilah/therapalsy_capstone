import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditprofileController extends GetxController {
  final box = GetStorage();
  final apiUrl = 'https://evidently-moved-marmoset.ngrok-free.app/api/user';

  var usernameController = ''.obs;
  var emailController = ''.obs;
  var imagePath = Rxn<File>();

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  void fetchProfile() async {
    final token = box.read('token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse('$apiUrl/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      usernameController.value = data['username'] ?? '';
      emailController.value = data['email'] ?? '';
    } else {
      Get.snackbar('Error', 'Gagal mengambil data profil');
    }
  }

  void pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imagePath.value = File(pickedFile.path);
    }
  }

  Future<void> updateProfile() async {
    await _updateUsernameEmail();
    await _uploadProfilePicture();

    Get.back(); // kembali ke halaman profile
    Get.snackbar('Sukses', 'Profil berhasil diperbarui');
  }

  Future<void> _updateUsernameEmail() async {
    final token = box.read('token');
    final response = await http.patch(
      Uri.parse('$apiUrl/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': usernameController.value,
        'email': emailController.value,
      }),
    );

    if (response.statusCode != 200) {
      Get.snackbar('Error', 'Gagal update nama/email');
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (imagePath.value == null) return;

    final token = box.read('token');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/upload'),
    )
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', imagePath.value!.path));

    final response = await request.send();

    if (response.statusCode != 200) {
      Get.snackbar('Error', 'Gagal upload foto profil');
    }
  }
}
