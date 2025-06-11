import 'package:get/get.dart';

class PrivacypolicyController extends GetxController {
  // Observable untuk lastUpdate
  final lastUpdate = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Set tanggal sekarang sebagai lastUpdate
    lastUpdate.value = DateTime.now().toString().split(' ')[0];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
