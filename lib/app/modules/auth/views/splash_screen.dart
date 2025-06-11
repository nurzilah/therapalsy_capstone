import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Delay + cek token
    Future.delayed(const Duration(seconds: 2), () {
      final box = GetStorage();
      final token = box.read('token');

      if (token != null) {
        Get.offAllNamed(Routes.HOME); // kalau sudah login
      } else {
        Get.offAllNamed(Routes.WELCOME); // belum login
      }
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo_therapalsy.png'),
          width: 250,
        ),
      ),
    );
  }
}
