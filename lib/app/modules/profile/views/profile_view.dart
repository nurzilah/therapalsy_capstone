import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:therapalsy_capstone/app/modules/changepassword/views/changepassword_view.dart';
import 'package:therapalsy_capstone/app/modules/editprofile/views/editprofile_view.dart';
import 'package:therapalsy_capstone/app/modules/faq/views/faq_view.dart';
import 'package:therapalsy_capstone/app/modules/privacypolicy/views/privacypolicy_view.dart';
import 'package:therapalsy_capstone/app/modules/privacypolicy/bindings/privacypolicy_binding.dart';
import 'package:therapalsy_capstone/app/modules/historylogin/views/historylogin_view.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final Color mainGreen = const Color(0xFF306A5A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(height: 250, width: double.infinity, color: mainGreen),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'PROFILE',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 2, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Profile Image
                Obx(() {
                  final imageUrl = controller.profileImage.value;
                  return Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 6),
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: imageUrl != null
                          ? Image.network(
                              'https://evidently-moved-marmoset.ngrok-free.app/$imageUrl',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/pp.png', fit: BoxFit.cover);
                              },
                            )
                          : Image.asset('assets/images/pp.png', fit: BoxFit.cover),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Username & Email
                Obx(() => Column(
                      children: [
                        Text(
                          controller.username.value,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.email.value,
                          style: const TextStyle(fontSize: 14.5, color: Colors.black54),
                        ),
                      ],
                    )),

                const SizedBox(height: 14),

                // Edit Profile Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => EditProfileView()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'EDIT PROFILE',
                        style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Menu Items
                _ProfileMenuItem(
                  icon: Icons.lock_outline,
                  text: 'Change Password',
                  onTap: () => Get.to(() => const ChangepasswordView()),
                ),
                _ProfileMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  text: 'Privacy Policy',
                  onTap: () => Get.to(() => PrivacyPolicyView(), binding: PrivacypolicyBinding()),
                ),
                _ProfileMenuItem(
                  icon: Icons.help_outline,
                  text: 'FAQ',
                  onTap: () => Get.to(() => const FaqView()),
                ),
                _ProfileMenuItem(
                  icon: Icons.history,
                  text: 'Sign In History',
                  onTap: () {
                    final storage = GetStorage();
                    final token = storage.read('token');
                    final userId = storage.read('user_id');
                    if (token != null && userId != null) {
                      Get.toNamed('/historylogin', arguments: {'userId': userId, 'token': token});
                    } else {
                      Get.snackbar('Error', 'User not logged in');
                    }
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.logout,
                  text: 'Sign Out',
                  onTap: () {
                    Get.defaultDialog(
                      title: "Logout",
                      middleText: "Are you sure you want to log out?",
                      textCancel: "Cancel",
                      textConfirm: "Yes",
                      confirmTextColor: Colors.white,
                      onConfirm: controller.logout,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ProfileMenuItem({required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.black54, size: 26),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black38, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}
