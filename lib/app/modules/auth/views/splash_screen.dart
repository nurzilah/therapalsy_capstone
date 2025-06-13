import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan dijalankan setelah UI dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final box = GetStorage();
      final token = box.read('token');
      final userId = box.read('user_id');

      print('✅ TOKEN: $token');
      print('✅ USER ID: $userId');

      await Future.delayed(const Duration(seconds: 2)); // delay splash
      if (token != null && userId != null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.WELCOME);
      }
    });

    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo_therapalsy.png'),
          width: 250,
        ),
      ),
    );
  }
}
