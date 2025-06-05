import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/newpassword_controller.dart';

class NewpasswordView extends StatefulWidget {
  const NewpasswordView({super.key});

  @override
  State<NewpasswordView> createState() => _NewpasswordViewState();
}

class _NewpasswordViewState extends State<NewpasswordView> {
  final NewpasswordController controller = Get.put(NewpasswordController());

  final Color mainGreen = const Color(0xFF2F5D4E);
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final TextEditingController _newPassCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String email = Get.arguments['email'] ?? '';
    final String otp = Get.arguments['otp'] ?? '';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD2E7DF), Color(0xFFB0CFC4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                const Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'And now,\nyou can create new password!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 38),

                /// New Password Field
                TextField(
                  controller: _newPassCtrl,
                  obscureText: _obscureNew,
                  onChanged: (v) => controller.newpassword.value = v,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 22),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNew
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _obscureNew = !_obscureNew);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Confirm Password Field
                TextField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  onChanged: (v) => controller.confirmPassword.value = v,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 22),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                /// Reset Password Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_newPassCtrl.text.isEmpty ||
                          _confirmCtrl.text.isEmpty) {
                        Get.snackbar('Error', 'Isi semua field');
                        return;
                      }
                      controller.resetPassword(email, otp);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'RESET PASSWORD',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
