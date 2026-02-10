// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'booking.dart';
import 'keranjang.dart'; // IMPORT FILE KERANJANG UNTUK SISTEM SIMPAN

class PesanTiketAirTerjunPage extends StatefulWidget {
  const PesanTiketAirTerjunPage({super.key});

  @override
  State<PesanTiketAirTerjunPage> createState() =>
      _PesanTiketAirTerjunPageState();
}

class _PesanTiketAirTerjunPageState extends State<PesanTiketAirTerjunPage> {
  // --- DATA MASTER AIR TERJUN ---
  final List<Map<String, dynamic>> allDestinations = [
    {
      'nama': 'Madakaripura',
      'wilayah': 'Jawa',
      'lokasi': 'Probolinggo, Jawa Timur',
      'jarak_trek': '1.5 KM',
      'durasi': '30 - 45 Menit',
      'jalur': 'Pintu Utama Madakaripura',
      'kategori': 'Air Terjun',
      'image': 'assets/madakaripura.png',
      'Tarif Hari Kerja (WNA)': '50.000',
      'Tarif Akhir Pekan (WNA)': '60.000',
      'Tarif Hari Kerja (WNI)': '25.000',
      'Tarif Akhir Pekan (WNI)': '33.000',
    },
    {
      'nama': 'Coban Talun',
      'wilayah': 'Jawa',
      'lokasi': 'Batu, Jawa Timur',
      'jarak_trek': '800 Meter',
      'durasi': '15 - 20 Menit',
      'jalur': 'Jalur Hutan Pinus',
      'kategori': 'Air Terjun',
      'image': 'assets/cobanT.png',
      'Tarif Hari Kerja (WNA)': '12.000',
      'Tarif Akhir Pekan (WNA)': '12.000',
      'Tarif Hari Kerja (WNI)': '12.000',
      'Tarif Akhir Pekan (WNI)': '12.000',
    },
    {
      'nama': 'Tegunungan',
      'wilayah': 'Bali dan Nusa Tenggara',
      'lokasi': 'Gianyar, Bali',
      'jarak_trek': '500 Meter',
      'durasi': '10 Menit',
      'jalur': 'Anak Tangga Beton',
      'kategori': 'Air Terjun',
      'image': 'assets/tegunungan.png',
      'Tarif Hari Kerja (WNA)': '20.000',
      'Tarif Akhir Pekan (WNA)': '20.000',
      'Tarif Hari Kerja (WNI)': '20.000',
      'Tarif Akhir Pekan (WNI)': '20.000',
    },
    {
      'nama': 'Sekumpul',
      'wilayah': 'Bali dan Nusa Tenggara',
      'lokasi': 'Buleleng, Bali',
      'jarak_trek': '2 KM',
      'durasi': '1 Jam',
      'jalur': 'Jalur Trekking Lemukih',
      'kategori': 'Air Terjun',
      'image': 'assets/sekumpul.png',
      'Tarif Hari Kerja (WNA)': '20.000',
      'Tarif Akhir Pekan (WNA)': '20.000',
      'Tarif Hari Kerja (WNI)': '10.000',
      'Tarif Akhir Pekan (WNI)': '10.000',
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
          'E-Ticket Air Terjun',
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
                _buildFilterDropdown(
                  title: 'Wilayah',
                  currentSelection: _selectedWilayah,
                  options: [
                    'Semua',
                    'Jawa',
                    'Sumatra',
                    'Bali dan Nusa Tenggara',
                    'Kalimantan',
                    'Sulawesi',
                    'Maluku dan Papua',
                  ],
                  onSelected: (val) {
                    _selectedWilayah = val;
                    _applyFilter();
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      _searchQuery = value;
                      _applyFilter();
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari air terjun...',
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

  Widget _buildFilterDropdown({
    required String title,
    required String currentSelection,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      itemBuilder: (context) => options
          .map((option) => PopupMenuItem(value: option, child: Text(option)))
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
            Text(currentSelection == 'Semua' ? title : currentSelection),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn(
                        Icons.directions_walk,
                        "Jarak Trek",
                        data['jarak_trek'],
                      ),
                      _buildInfoColumn(
                        Icons.schedule,
                        "Durasi",
                        data['durasi'],
                      ),
                      // BAGIAN YANG DIUBAH: DARI WILAYAH MENJADI KATEGORI
                      _buildInfoColumn(
                        Icons.category,
                        "Kategori",
                        data['kategori'],
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
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF1F4529).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.hiking, color: Color(0xFF1F4529)),
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
            "Rp $price",
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
                Row(
                  children: [
                    const Icon(
                      Icons.directions_walk,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      item['jarak_trek'],
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
