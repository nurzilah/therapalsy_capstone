import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

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
        Uri.parse('https://evidently-moved-marmoset.ngrok-free.app/api/user/history-login/$userId'),
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
      final date = DateTime.parse(timestamp).toLocal();
      return '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}, '
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
    } else if (name.contains('android') || name.contains('realme') || name.contains('xiaomi') || name.contains('samsung')) {
      return const Icon(Icons.android, color: Colors.green);
    } else {
      return const Icon(Icons.device_unknown, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In History'),
        centerTitle: true,
        backgroundColor: const Color(0xFF316B5C),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : loginHistory.isEmpty
              ? const Center(child: Text('Belum ada riwayat login.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: loginHistory.length,
                  separatorBuilder: (context, index) => const Divider(height: 16),
                  itemBuilder: (context, index) {
                    final item = loginHistory[index];
                    final device = item['device'] ?? 'Tidak diketahui';
                    final time = item['timestamp'] ?? item['login_time'] ?? '';
                    return ListTile(
                      leading: _deviceIcon(device),
                      title: Text(device),
                      subtitle: Text(time.isNotEmpty ? formatDateTime(time) : 'Waktu tidak tersedia'),
                    );
                  },
                ),
    );
  }
}
