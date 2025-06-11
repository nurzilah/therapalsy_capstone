import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/historylogin_controller.dart';

class HistoryloginView extends StatelessWidget {
  final HistoryloginController controller = Get.put(HistoryloginController());

  HistoryloginView({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Get.arguments['userId'];
    final token = Get.arguments['token'];

    controller.fetchLoginHistory(userId, token);

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Login')),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.loginHistory.isEmpty) return const Center(child: Text('Belum ada riwayat login.'));
        return ListView.builder(
          itemCount: controller.loginHistory.length,
          itemBuilder: (context, index) {
            final item = controller.loginHistory[index];
            return ListTile(
              title: Text(item['device'] ?? '-'),
              subtitle: Text(item['login_time'] ?? ''),
            );
          },
        );
      }),
    );
  }
}
