import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modules/home/controllers/home_controller.dart'; // ganti sesuai path kamu

class PieChartWidget extends StatelessWidget {
  PieChartWidget({Key? key}) : super(key: key);

  final pastelColors = const [
    Color(0xFFFFB5E8),
    Color(0xFFB28DFF),
    Color(0xFFA0E7E5),
    Color(0xFFFFDAC1),
    Color(0xFFB5F2EA),
    Color(0xFFFDCBFA),
    Color(0xFFF3FFE3),
    Color(0xFFFFF5BA),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final data = controller.topVideos;

      if (data.isEmpty) {
        return const Text("Tidak ada data pie chart.");
      }

      final total = data.fold<double>(
        0.0,
        (sum, item) => sum + (item['value'] as num).toDouble(),
      );

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                  sections: List.generate(data.length, (i) {
                    final item = data[i];
                    final value = item['value'].toDouble();
                    final percentage = ((value / total) * 100).toStringAsFixed(1);
                    return PieChartSectionData(
                      color: pastelColors[i % pastelColors.length],
                      value: value,
                      title: '$percentage%',
                      radius: 70,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    );
                  }),
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) async {
                      if (event.isInterestedForInteractions &&
                          response?.touchedSection != null) {
                        final index = response!.touchedSection!.touchedSectionIndex;
                        final item = data[index];
                        final url = item['url'];
                        if (url != null && url.toString().isNotEmpty) {
                          final uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(data.length, (i) {
                final item = data[i];
                final color = pastelColors[i % pastelColors.length];
                final label = item['label'];
                final url = item['url'];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (url != null && url.toString().isNotEmpty) {
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Tidak dapat membuka link")),
                                );
                              }
                            }
                          },
                          child: Text(
                            label.length > 60 ? '${label.substring(0, 60)}...' : label,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
