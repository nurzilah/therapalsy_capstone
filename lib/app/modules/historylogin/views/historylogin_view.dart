import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class HistoryloginView extends StatefulWidget {
  const HistoryloginView({super.key});

  @override
  State<HistoryloginView> createState() => _HistoryloginViewState();
}

class _HistoryloginViewState extends State<HistoryloginView> {
  List<dynamic> loginHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLoginHistory();
  }

  Future<void> fetchLoginHistory() async {
    final box = GetStorage();
    final userId = box.read('user_id');
    final token = box.read('token');

    if (userId == null || token == null) {
      Get.snackbar('Error', 'User belum login');
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://evidently-moved-marmoset.ngrok-free.app/api/user/history-login/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          loginHistory = data['data'];
          isLoading = false;
        });
      } else {
        Get.snackbar('Error', 'Gagal memuat riwayat login');
        setState(() => isLoading = false);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      setState(() => isLoading = false);
    }
  }

  String formatDateTime(String timestamp) {
    try {
      if (!timestamp.endsWith('Z') && !timestamp.contains('+')) {
        timestamp = '$timestamp' + 'Z';
      }
      final utcDate = DateTime.parse(timestamp).toUtc();
      final wibDate = utcDate.add(const Duration(hours: 7));
      return '${wibDate.day.toString().padLeft(2, '0')} '
          '${_monthName(wibDate.month)} ${wibDate.year}, '
          '${wibDate.hour.toString().padLeft(2, '0')}:'
          '${wibDate.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Format tanggal salah';
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }

  Icon _deviceIcon(String deviceName) {
    final name = deviceName.toLowerCase();
    if (name.contains('iphone')) {
      return const Icon(Icons.phone_iphone, color: Colors.blueAccent);
    } else if (name.contains('android') ||
        name.contains('realme') ||
        name.contains('xiaomi') ||
        name.contains('samsung') ||
        name.contains('oppo')) {
      return const Icon(Icons.android, color: Colors.green);
    } else {
      return const Icon(Icons.devices_other, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGN IN HISTORY'),
        centerTitle: true,
        backgroundColor: const Color(0xFF306A5A),
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : loginHistory.isEmpty
              ? const Center(child: Text('Belum ada riwayat login.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: loginHistory.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = loginHistory[index];
                    final device = item['device'] ?? 'Tidak diketahui';
                    final time =
                        item['timestamp'] ?? item['login_time'] ?? '';
                    final formattedTime = time.isNotEmpty
                        ? formatDateTime(time)
                        : 'Waktu tidak tersedia';

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100]!.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: _deviceIcon(device),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    device,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    formattedTime,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
