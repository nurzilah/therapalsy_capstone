import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  final isLoading = true.obs;
  final topVideos = <Map<String, dynamic>>[].obs;
  final topChannels = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    isLoading(true);
    try {
      final videoRes = await http.get(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/chart/top-videos'),
      );
      final channelRes = await http.get(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/chart/top-channels'),
      );

      if (videoRes.statusCode == 200 && channelRes.statusCode == 200) {
        final rawVideos = List<Map<String, dynamic>>.from(json.decode(videoRes.body));
        final rawChannels = List<Map<String, dynamic>>.from(json.decode(channelRes.body));

        // Format data video
        topVideos.assignAll(
          rawVideos.map((e) => {
                'label': e['title'],
                'value': e['views'],
                'url': e['url'],
              }).toList(),
        );

        // Format data channel
        topChannels.assignAll(
          rawChannels.map((e) => {
                'label': e['channel'],
                'value': e['count'],
                'url': e['url'], // <-- penting untuk buka link
              }).toList(),
        );
      } else {
        Get.snackbar("Error", "Gagal memuat grafik dari server.");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading(false);
    }
  }

  // Tambahan: untuk refresh data setelah login ulang
  Future<void> refreshChartData() async {
    await fetchChartData();
  }
}
