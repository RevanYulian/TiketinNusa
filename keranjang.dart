// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'beranda.dart';
import 'notifikasi.dart';

// Import semua file kategori agar bisa akses DetailWisataPage masing-masing
import 'gunung.dart' as gunung;
import 'air_terjun.dart' as air_terjun;
import 'danau.dart' as danau;
import 'pantai.dart' as pantai;

// --- DATA STORAGE SIMPAN STATIS ---
class SavedData {
  static ValueNotifier<List<Map<String, dynamic>>> mySavedItems = ValueNotifier(
    [],
  );

  static void toggleSave(Map<String, dynamic> item) {
    var currentList = List<Map<String, dynamic>>.from(mySavedItems.value);
    // Cek berdasarkan nama unik
    int index = currentList.indexWhere((e) => e['nama'] == item['nama']);

    if (index != -1) {
      currentList.removeAt(index);
    } else {
      currentList.add(item);
    }
    mySavedItems.value = currentList;
  }
}

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  // Fungsi untuk membuka search yang sama dengan di main.dart
  void _bukaSearch() {
    showSearch(context: context, delegate: DestinasiSearchDelegate());
  }

  // Fungsi helper untuk menentukan ke halaman detail mana aplikasi harus pergi
  void _navigateToDetail(BuildContext context, Map<String, dynamic> item) {
    Widget detailPage;
    String kategori = item['kategori']?.toString().toLowerCase() ?? '';

    // Logika pengalihan berdasarkan kategori data
    if (kategori == 'gunung') {
      detailPage = gunung.DetailWisataPage(data: item);
    } else if (kategori == 'air terjun') {
      detailPage = air_terjun.DetailWisataPage(data: item);
    } else if (kategori == 'danau') {
      detailPage = danau.DetailWisataPage(data: item);
    } else if (kategori == 'pantai') {
      detailPage = pantai.DetailWisataPage(data: item);
    } else {
      // Fallback menggunakan UniversalDetailWisataPage dari main.dart
      detailPage = UniversalDetailWisataPage(data: item);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detailPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EFED),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: SavedData.mySavedItems,
              builder: (context, List<Map<String, dynamic>> savedItems, child) {
                return savedItems.isEmpty
                    ? _buildEmptyState()
                    : _buildSavedList(savedItems);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 144,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      decoration: const BoxDecoration(color: Color(0xFF1F4529)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TiketinNusa',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Row untuk menampung Search dan Notifikasi agar sejajar dengan main.dart
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 28),
                onPressed: _bukaSearch, // Pemicu fungsi pencarian
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotifikasiPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            "Anda Belum Menyimpan Apapun",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                // Navigasi balik ke Beranda
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TiketinNusaHome(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F4529),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Cari Sekarang",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedList(List<Map<String, dynamic>> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => _navigateToDetail(context, item), // Navigasi dinamis
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item['image'] ?? '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nama'] ?? 'Tanpa Nama',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        item['kategori'] ?? 'Wisata',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark, color: Color(0xFF1F4529)),
                  onPressed: () {
                    SavedData.toggleSave(item);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
