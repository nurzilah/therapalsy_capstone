import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/article_model.dart';

class HomeController extends GetxController {
  final isLoading = true.obs;
  final topVideos = <Map<String, dynamic>>[].obs;
  final topChannels = <Map<String, dynamic>>[].obs;
  final RxList<Article> _articles = <Article>[].obs;

  List<Article> get articles => _articles;

  @override
  void onInit() {
    super.onInit();
    fetchChartData();
    fetchArticles();
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

        topVideos.assignAll(
          rawVideos.map((e) => {
            'label': e['title'],
            'value': e['views'],
            'url': e['url'],
          }).toList(),
        );

        topChannels.assignAll(
          rawChannels.map((e) => {
            'label': e['channel'],
            'value': e['count'],
            'url': e['url'],
          }).toList(),
        );
      } else {
        Get.snackbar("Error", "Failed to load chart data.");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchArticles() async {
    try {
      final response = await http.get(
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/scrape/bells_palsy_articles'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        _articles.value = jsonData.map((item) => Article.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Gagal mengambil artikel dari server');
      }
    } catch (e) {
      print('Error fetchArticles: $e');
      Get.snackbar('Error', 'Terjadi kesalahan saat mengambil data');
    }
  }
}
