import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({super.key});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  List<Map<String, dynamic>> channelData = [];
  int? touchedIndex;

  @override
  void initState() {
    super.initState();
    fetchTopChannels();
  }

  Future<void> fetchTopChannels() async {
    final response = await http.get(
      Uri.parse("https://evidently-moved-marmoset.ngrok-free.app/api/chart/top-channels"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        channelData = jsonData
            .map((item) => {
                  "channel": item["channel"] ?? "Unknown",
                  "count": item["count"] ?? 0,
                  "url": item["url"] ?? "",
                })
            .toList();
      });
    } else {
      print("Failed to load chart data: ${response.statusCode}");
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (channelData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    double maxValue = channelData
        .map((e) => e['count'] as int)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                maxY: maxValue + 1,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.black87,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final channel = channelData[group.x.toInt()];
                      return BarTooltipItem(
                        '${channel['channel']}\n${channel['count']} videos',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  touchCallback: (event, response) {
                    if (response != null && response.spot != null) {
                      final index = response.spot!.touchedBarGroupIndex;
                      final count = channelData[index]['count'];
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Jumlah video: $count")),
                      );
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 120,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < channelData.length) {
                          String name = channelData[index]['channel'];
                          String url = channelData[index]['url'];
                          name = name.length > 15 ? name.substring(0, 15) + '…' : name;

                          return GestureDetector(
                            onTap: () => _launchURL(url),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt() + 1}', // Ganti dari 0–9 jadi 1–10
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
                barGroups: channelData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final count = entry.value["count"] as int;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: count.toDouble(),
                        width: 14,
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.teal,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
