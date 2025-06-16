import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../profile/controllers/profile_controller.dart';

class EditprofileController extends GetxController {
  final usernameController = ''.obs;
  final emailController = ''.obs;
  final imagePath = Rxn<File>();
  final networkImage = ''.obs;

  final isLoading = false.obs;
  final box = GetStorage();
  final apiUrl = 'https://evidently-moved-marmoset.ngrok-free.app/api/user';

  @override
  void onInit() {
    super.onInit();
    fetchCurrentProfile();
  }

  void fetchCurrentProfile() async {
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
      networkImage.value = data['profileImage'] ?? '';
    }
  }

  void updateProfile() async {
    final token = box.read('token');
    if (token == null) return;

    isLoading.value = true;

    final response = await http.patch(
      Uri.parse('$apiUrl/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'username': usernameController.value,
        'email': emailController.value,
      }),
    );

    isLoading.value = false;

    if (response.statusCode == 200) {
      Get.snackbar(
        'Berhasil',
        'Username berhasil diperbarui',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      Get.find<ProfileController>().fetchProfile();
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.back();
    } else {
      Get.snackbar(
        'Gagal',
        'Gagal memperbarui profil',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imagePath.value = File(picked.path);
      await uploadProfileImage(imagePath.value!);
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    final token = box.read('token');
    if (token == null) return;

    final request = http.MultipartRequest('POST', Uri.parse('$apiUrl/upload'))
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = jsonDecode(res.body);
      networkImage.value = data['profile_image'];
      Get.find<ProfileController>().fetchProfile();

      Get.snackbar(
        'Berhasil',
        'Foto profil berhasil diperbarui',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Gagal',
        'Gagal mengunggah foto',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
