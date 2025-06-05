import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/otp_reset_controller.dart';

class OtpResetView extends StatefulWidget {
  const OtpResetView({super.key});

  @override
  State<OtpResetView> createState() => _OtpResetViewState();
}

class _OtpResetViewState extends State<OtpResetView> {
  final OtpResetController controller = Get.put(OtpResetController());

  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  final Color mainGreen = const Color(0xFF2F5D4E);

  String get otp => _controllers.map((e) => e.text).join();

  @override
  void initState() {
    super.initState();
    controller.email.value = Get.arguments['email'] ?? '';
  }

  void handleInput(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD2E7DF), Color(0xFFB0CFC4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                const Text(
                  'Enter OTP Code',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('OTP sent to: ${controller.email.value}'),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (i) {
                    return SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        onChanged: (val) => handleInput(val, i),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final value = otp;
                      if (value.length != 4) {
                        Get.snackbar('Error', 'OTP harus 4 digit');
                        return;
                      }
                      controller.otp.value = value;
                      controller.verifyOtpAndProceed();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('VERIFY OTP'),
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
