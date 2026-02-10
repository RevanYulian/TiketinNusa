// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'booking.dart';
import 'keranjang.dart'; // IMPORT FILE KERANJANG UNTUK SISTEM SIMPAN

class PesanTiketPantaiPage extends StatefulWidget {
  const PesanTiketPantaiPage({super.key});

  @override
  State<PesanTiketPantaiPage> createState() => _PesanTiketPantaiPageState();
}

class _PesanTiketPantaiPageState extends State<PesanTiketPantaiPage> {
  // --- DATA MASTER PANTAI ---
  final List<Map<String, dynamic>> allDestinations = [
    {
      'nama': 'Pantai Tanjung Tinggi',
      'wilayah': 'Sumatra',
      'lokasi': 'Belitung, Bangka Belitung',
      'kategori': 'Pantai',
      'tipe_pasir': 'Putih Halus', // Tambahan data tipe pasir
      'suhu': '29°C', // Tambahan data suhu
      'image': 'assets/tanjungT.png',
      'jalur':
          'Akses aspal mulus, dapat ditempuh 45 menit dari pusat Kota Tanjung Pandan.',
      'Tarif Hari Kerja (WNA)': '20.000',
      'Tarif Akhir Pekan (WNA)': '20.000',
      'Tarif Hari Kerja (WNI)': '5.000',
      'Tarif Akhir Pekan (WNI)': '5.000',
    },
    {
      'nama': 'Pantai Pink',
      'wilayah': 'Bali dan Nusa Tenggara',
      'lokasi': 'Lombok, NTB',
      'kategori': 'Pantai',
      'tipe_pasir': 'Pink Merah Muda',
      'suhu': '30°C',
      'image': 'assets/pink.png',
      'jalur':
          'Akses terbaik menggunakan kapal cepat dari Pelabuhan Tanjung Luar.',
      'Tarif Hari Kerja (WNA)': '50.000',
      'Tarif Akhir Pekan (WNA)': '50.000',
      'Tarif Hari Kerja (WNI)': '10.000',
      'Tarif Akhir Pekan (WNI)': '10.000',
    },
    {
      'nama': 'Pantai Tanjung Bira',
      'wilayah': 'Sulawesi',
      'lokasi': 'Bulukumba, Sulawesi Selatan',
      'kategori': 'Pantai',
      'tipe_pasir': 'Putih Kristal',
      'suhu': '28°C',
      'image': 'assets/tanjungB.png',
      'jalur':
          'Jalan raya trans Sulawesi dengan pemandangan pesisir yang indah.',
      'Tarif Hari Kerja (WNA)': '40.000',
      'Tarif Akhir Pekan (WNA)': '50.000',
      'Tarif Hari Kerja (WNI)': '15.000',
      'Tarif Akhir Pekan (WNI)': '20.000',
    },
    {
      'nama': 'Pantai Kuta',
      'wilayah': 'Bali dan Nusa Tenggara',
      'lokasi': 'Badung, Bali',
      'kategori': 'Pantai',
      'tipe_pasir': 'Putih Kecokelatan',
      'suhu': '31°C',
      'image': 'assets/kuta.png',
      'jalur':
          'Lokasi sangat strategis di pusat pariwisata, dekat dengan Bandara Ngurah Rai.',
      'Tarif Hari Kerja (WNA)': '0',
      'Tarif Akhir Pekan (WNA)': '0',
      'Tarif Hari Kerja (WNI)': '0',
      'Tarif Akhir Pekan (WNI)': '0',
    },
  ];

  List<Map<String, dynamic>> displayedItems = [];
  String _selectedWilayah = 'Semua';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    displayedItems = allDestinations;
  }

  void _applyFilter() {
    setState(() {
      displayedItems = allDestinations.where((item) {
        final matchesSearch = item['nama'].toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        final matchesWilayah =
            _selectedWilayah == 'Semua' || item['wilayah'] == _selectedWilayah;
        return matchesSearch && matchesWilayah;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F4529),
        toolbarHeight: 110,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'E-Ticket Pantai',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildFilterDropdown(),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      _searchQuery = value;
                      _applyFilter();
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari pantai...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: displayedItems.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: displayedItems.length,
                    itemBuilder: (context, index) {
                      final item = displayedItems[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailWisataPage(data: item),
                          ),
                        ),
                        child: TicketCard(item: item),
                      );
                    },
                  )
                : const Center(child: Text('Destinasi tidak ditemukan')),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return PopupMenuButton<String>(
      onSelected: (val) {
        _selectedWilayah = val;
        _applyFilter();
      },
      color: Colors.white,
      itemBuilder: (context) =>
          [
                'Semua',
                'Jawa',
                'Sumatra',
                'Bali dan Nusa Tenggara',
                'Kalimantan',
                'Sulawesi',
                'Maluku dan Papua',
              ]
              .map(
                (option) => PopupMenuItem(value: option, child: Text(option)),
              )
              .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            const Icon(Icons.filter_list, size: 18),
            const SizedBox(width: 6),
            Text(_selectedWilayah == 'Semua' ? 'Wilayah' : _selectedWilayah),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class DetailWisataPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const DetailWisataPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F4529),
        toolbarHeight: 80,
        title: Text(
          data['nama'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              data['image'],
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                color: Colors.grey,
                height: 250,
                child: const Icon(Icons.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['nama'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        data['lokasi'],
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(height: 40, thickness: 1),

                  // SEKSI INFO YANG DIUBAH
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn(
                        Icons.thermostat,
                        "Suhu",
                        data['suhu'] ?? '30°C', // Menampilkan Suhu
                      ),
                      _buildInfoColumn(
                        Icons.layers,
                        "Tipe Pasir",
                        data['tipe_pasir'] ?? 'Putih', // Menampilkan Tipe Pasir
                      ),
                      _buildInfoColumn(
                        Icons.category,
                        "Kategori",
                        data['kategori'], // Menampilkan Kategori
                      ),
                    ],
                  ),

                  const Divider(height: 40, thickness: 1),
                  const Text(
                    "Jalur Akses Utama",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF1F4529).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.directions_car,
                          color: Color(0xFF1F4529),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            data['jalur'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Informasi Tarif",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 15),
                  _buildPriceItem(
                    "WNI - Hari Kerja",
                    data['Tarif Hari Kerja (WNI)'],
                  ),
                  _buildPriceItem(
                    "WNI - Akhir Pekan",
                    data['Tarif Akhir Pekan (WNI)'],
                  ),
                  _buildPriceItem(
                    "WNA - Hari Kerja",
                    data['Tarif Hari Kerja (WNA)'],
                  ),
                  _buildPriceItem(
                    "WNA - Akhir Pekan",
                    data['Tarif Akhir Pekan (WNA)'],
                  ),
                  const SizedBox(height: 40),

                  // TOMBOL AKSI
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            SavedData.toggleSave(data);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${data['nama']} ditambahkan ke keranjang",
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF1F4529),
                              width: 2,
                            ),
                            minimumSize: const Size.fromHeight(55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Icon(
                            Icons.shopping_basket,
                            color: Color(0xFF1F4529),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookingPage(dataWisata: data),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1F4529),
                            minimumSize: const Size.fromHeight(55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Booking Sekarang",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1F4529), size: 28),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPriceItem(String label, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(
            price == "0" ? "Gratis" : "Rp $price",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F4529),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const TicketCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFF1F4529),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.asset(
                item['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  height: 180,
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
                child: Text(
                  item['nama'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cari bagian ini di paling bawah file pantai.dart
                Row(
                  children: [
                    const Icon(
                      Icons.thermostat, // Ganti icon menjadi suhu
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      item['suhu'] ??
                          '30°C', // Ganti item['wilayah'] menjadi item['suhu']
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  item['lokasi'],
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
