import 'package:flutter/material.dart';

/// Class untuk mengelola data notifikasi secara global dalam aplikasi
class NotificationData {
  // Daftar notifikasi statis agar data tetap tersimpan selama aplikasi berjalan
  static List<Map<String, String>> list = [
    {
      'judul': 'Terimakasih',
      'isi': 'Terimakasih sudah bergabung dengan kami di TiketinNusa',
      'waktu': '1 Menit Yang Lalu',
    },
    {
      'judul': 'Selamat Datang!',
      'isi': 'Selamat Datang Arip Wijaya di TiketinNusa',
      'waktu': '45 Menit Yang Lalu',
    },
  ];

  /// Fungsi untuk menambah notifikasi baru dari halaman lain (misal: Booking)
  static void addNotification(String judul, String isi) {
    list.insert(0, {'judul': judul, 'isi': isi, 'waktu': 'Baru saja'});
  }
}

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background abu-abu kehijauan sesuai pedoman main.dart
      backgroundColor: const Color(0xFFE8EFED),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F4529),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: NotificationData.list.isEmpty
          ? const Center(
              child: Text(
                "Tidak ada notifikasi",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: NotificationData.list.length,
              itemBuilder: (context, index) {
                final item = NotificationData.list[index];
                return _buildNotificationCard(item);
              },
            ),
    );
  }

  /// Widget kartu notifikasi sesuai dengan screenshot referensi
  Widget _buildNotificationCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['judul']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                item['waktu']!,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item['isi']!,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
