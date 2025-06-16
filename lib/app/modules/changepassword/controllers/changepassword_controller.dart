import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangepasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var obscureOld = true.obs;
  var obscureNew = true.obs;
  var obscureConfirm = true.obs;

  var passwordMismatch = false.obs;
  var isLoading = false.obs;

  final box = GetStorage();
  final String apiUrl = 'https://evidently-moved-marmoset.ngrok-free.app/api/user/change-password';

  void toggleOldVisibility() => obscureOld.toggle();
  void toggleNewVisibility() => obscureNew.toggle();
  void toggleConfirmVisibility() => obscureConfirm.toggle();

  void checkPasswordMatch() {
    passwordMismatch.value =
        newPasswordController.text != confirmPasswordController.text;
  }

  void changePassword() async {
    checkPasswordMatch();
    if (passwordMismatch.value) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    isLoading.value = true;
    final token = box.read('token');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'old_password': oldPasswordController.text,
          'new_password': newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password changed successfully');
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        final error = jsonDecode(response.body)['message'];
        Get.snackbar('Error', error ?? 'Failed to change password');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
