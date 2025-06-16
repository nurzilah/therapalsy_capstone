import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/changepassword_controller.dart';

class ChangepasswordView extends StatelessWidget {
  const ChangepasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangepasswordController());
    final Color mainGreen = const Color(0xFF306A5A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainGreen,
        title: const Text('CHANGE PASSWORD'),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Old Password', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: controller.oldPasswordController,
              obscureText: controller.obscureOld.value,
              decoration: InputDecoration(
                hintText: 'Enter your current password',
                hintStyle: TextStyle(color: Colors.black38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureOld.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: controller.toggleOldVisibility,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text('New Password', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: controller.newPasswordController,
              obscureText: controller.obscureNew.value,
              decoration: InputDecoration(
                hintText: 'Enter a new password',
                hintStyle: TextStyle(color: Colors.black38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureNew.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: controller.toggleNewVisibility,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Confirm New Password', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: controller.confirmPasswordController,
              obscureText: controller.obscureConfirm.value,
              decoration: InputDecoration(
                hintText: 'Re-enter the new password',
                hintStyle: TextStyle(color: Colors.black38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureConfirm.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: controller.toggleConfirmVisibility,
                ),
                errorText: controller.passwordMismatch.value ? "Passwords do not match" : null,
              ),
              onChanged: (_) => controller.checkPasswordMatch(),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: controller.isLoading.value ? null : controller.changePassword,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'SAVE',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
