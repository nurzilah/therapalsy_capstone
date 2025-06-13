import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/editprofile_controller.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});
  final controller = Get.put(EditprofileController());
  final Color mainGreen = const Color(0xFF306A5A);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController emailCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        nameCtrl.text = controller.usernameController.value;
        emailCtrl.text = controller.emailController.value;

        return Stack(
          children: [
            Container(height: 250, width: double.infinity, color: mainGreen),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // AppBar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'EDIT PROFILE',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 48), // Spacer
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Profile Image + Edit
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Obx(() {
                          return Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 6),
                              color: Colors.grey.shade200,
                            ),
                            child: ClipOval(
                              child: controller.imagePath.value != null
                                  ? Image.file(controller.imagePath.value!, fit: BoxFit.cover)
                                  : Image.asset('assets/images/terapi.png', fit: BoxFit.cover),
                            ),
                          );
                        }),
                        Positioned(
                          bottom: 12,
                          right: MediaQuery.of(context).size.width / 2 - 90,
                          child: InkWell(
                            onTap: controller.pickAndUploadImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: mainGreen,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.edit, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Form Fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Username', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: nameCtrl,
                            onChanged: (val) => controller.usernameController.value = val,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: emailCtrl,
                            readOnly: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Save Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
