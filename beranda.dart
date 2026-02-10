// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gunung.dart' as gunung;
import 'pantai.dart' as pantai;
import 'danau.dart' as danau;
import 'air_terjun.dart' as airterjun;
import 'notifikasi.dart';
import 'tiket.dart';
import 'keranjang.dart';
import 'booking.dart';
import 'pengaturan.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Sans-Serif',
        useMaterial3: true,
      ),
      home: const TiketinNusaHome(),
    );
  }
}

class TiketinNusaHome extends StatefulWidget {
  const TiketinNusaHome({super.key});

  @override
  State<TiketinNusaHome> createState() => _TiketinNusaHomeState();
}

class _TiketinNusaHomeState extends State<TiketinNusaHome> {
  int _currentIndex = 0;
  late List<Map<String, String>> calendarDates;
  int selectedDateIndex = 0;
  late DateTime selectDate;

  late List<Widget> _pages;

  final List<String> weekdays = [
    "SEN",
    "SEL",
    "RAB",
    "KAM",
    "JUM",
    "SAB",
    "MIN",
  ];
  final List<String> months = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];

  @override
  void initState() {
    super.initState();
    calendarDates = _generateRealTimeDates();
    selectDate = DateTime.now();
    _pages = [
      _buildHomeBody(),
      const TiketPage(),
      const KeranjangPage(),
      const PengaturanPage(),
    ];
  }

  List<Map<String, String>> _generateRealTimeDates() {
    List<Map<String, String>> dates = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 14; i++) {
      DateTime date = now.add(Duration(days: i));
      dates.add({
        "day": weekdays[date.weekday - 1],
        "date": date.day.toString(),
      });
    }
    return dates;
  }

  // Fungsi untuk membuka search
  void _bukaSearch() {
    showSearch(context: context, delegate: DestinasiSearchDelegate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EFED),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 90), // Jarak pas setelah header stack
          _buildCalendarHeader(),
          _buildCalendarCard(),
          const SizedBox(height: 25), // Spacing antar section yang konsisten
          _buildSectionTitle('Pesan Tiket Masuk'),
          _buildCategoryGrid(),
          const SizedBox(height: 10),
          _buildSectionTitle('Wisata Alam Terpopuler'),
          _buildHorizontalWisata(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _bukaSearch,
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
        ),
        Positioned(
          top: 120,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(
              20,
            ), // Padding diperbesar agar lebih presisi
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Halo, Mau Liburan Kemana?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                // MENGUBAH SEARCH BAR MENJADI TEKS STATIS
                Text(
                  'Temukan destinasi impianmu dan nikmati perjalanan tak terlupakan bersama kami.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    height: 1.4, // Menambah line height agar lebih enak dibaca
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Menyesuaikan Header Kalender agar sejajar (Presisi)
  Widget _buildCalendarHeader() {
    DateTime now = selectDate;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        "${months[now.month - 1]} ${now.year}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color(0xFF1F4529),
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: calendarDates.length,
          itemBuilder: (context, index) {
            final item = calendarDates[index];
            final isSelected = index == selectedDateIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDateIndex = index;
                  selectDate = DateTime.now().add(Duration(days: index));
                });
              },
              child: Container(
                width: 60,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1F4529)
                      : const Color(0xFFE8EFED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item["day"]!,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      item["date"]!,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9, // Sedikit lebih tinggi untuk menampung teks
        children: [
          _buildCatIcon(
            Icons.terrain,
            "Gunung",
            const gunung.PesanTiketGunungPage(),
          ),
          _buildCatIcon(
            Icons.waterfall_chart,
            "Air Terjun",
            const airterjun.PesanTiketAirTerjunPage(),
          ),
          _buildCatIcon(
            Icons.beach_access,
            "Pantai",
            const pantai.PesanTiketPantaiPage(),
          ),
          _buildCatIcon(
            Icons.water,
            "Danau",
            const danau.PesanTiketDanauPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildCatIcon(IconData icon, String label, Widget targetPage) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetPage),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD9E3D8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: const Color(0xFF1F4529), size: 24),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalWisata() {
    final popularDestinations = DataDestinasi.getAllDestinations()
        .take(4)
        .toList();

    return SizedBox(
      height: 210, // Ketinggian dikunci agar seragam
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: popularDestinations.length,
        itemBuilder: (context, index) {
          final item = popularDestinations[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UniversalDetailWisataPage(data: item),
              ),
            ),
            child: Container(
              width:
                  170, // Lebar dikurangi sedikit agar kartu berikutnya terlihat (sebagai affordance)
              margin: const EdgeInsets.only(right: 15, bottom: 5, top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // Gunakan Expanded agar gambar mengisi ruang sisa dengan pas
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Image.asset(
                        item['image'],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['nama'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['wilayah'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF1F4529),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_rounded),
          label: 'Tiket',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket_rounded),
          label: 'Keranjang',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Pengaturan',
        ),
      ],
    );
  }
}

// ========== DATA DESTINASI ==========
class DataDestinasi {
  static List<Map<String, dynamic>> getAllDestinations() {
    return [
      // DATA GUNUNG
      {
        'nama': 'Gunung Rinjani',
        'wilayah': 'Bali dan Nusa Tenggara',
        'lokasi': 'Lombok, NTB',
        'ketinggian': '3.726 MDPL',
        'estimasi': '3 Hari 2 Malam',
        'jalur': 'Sembalun, Senaru, Torean',
        'kategori': 'Gunung',
        'image': 'assets/rinjani.png',
        'Tarif Hari Kerja (WNA)': '150.000',
        'Tarif Akhir Pekan (WNA)': '250.000',
        'Tarif Hari Kerja (WNI)': '5.000',
        'Tarif Akhir Pekan (WNI)': '7.500',
      },
      {
        'nama': 'Gunung Merbabu',
        'wilayah': 'Jawa',
        'lokasi': 'Boyolali, Jawa Tengah',
        'ketinggian': '3.142 MDPL',
        'estimasi': '8 - 10 Jam',
        'jalur': 'Selo, Suwanting, Wekas',
        'kategori': 'Gunung',
        'image': 'assets/merbabu.png',
        'Tarif Hari Kerja (WNA)': '200.000',
        'Tarif Akhir Pekan (WNA)': '300.000',
        'Tarif Hari Kerja (WNI)': '20.000',
        'Tarif Akhir Pekan (WNI)': '30.000',
      },
      {
        'nama': 'Gunung Arjuna',
        'wilayah': 'Jawa',
        'lokasi': 'Pasuruan, Jawa Timur',
        'ketinggian': '3.339 MDPL',
        'estimasi': '2 Hari 1 Malam',
        'jalur': 'Tretes, Purwosari, Lawang',
        'kategori': 'Gunung',
        'image': 'assets/arjuno.png',
        'Tarif Hari Kerja (WNA)': '200.000',
        'Tarif Akhir Pekan (WNA)': '200.000',
        'Tarif Hari Kerja (WNI)': '20.000',
        'Tarif Akhir Pekan (WNI)': '25.000',
      },
      {
        'nama': 'Gunung Kerinci',
        'wilayah': 'Sumatra',
        'lokasi': 'Kerinci, Jambi',
        'ketinggian': '3.805 MDPL',
        'estimasi': '2 Hari 1 Malam',
        'jalur': 'Kersik Tuo',
        'kategori': 'Gunung',
        'image': 'assets/kerinci.png',
        'Tarif Hari Kerja (WNA)': '310.000',
        'Tarif Akhir Pekan (WNA)': '460.000',
        'Tarif Hari Kerja (WNI)': '20.000',
        'Tarif Akhir Pekan (WNI)': '25.000',
      },
      {
        'nama': 'Gunung Lawu',
        'wilayah': 'Jawa',
        'lokasi': 'Karanganyar, Jawa Tengah',
        'ketinggian': '3.265 MDPL',
        'estimasi': '7 - 9 Jam',
        'jalur': 'Cetho, Cemoro Sewu, Cemoro Kandang',
        'kategori': 'Gunung',
        'image': 'assets/lawu.png',
        'Tarif Hari Kerja (WNA)': '25.000',
        'Tarif Akhir Pekan (WNA)': '35.000',
        'Tarif Hari Kerja (WNI)': '20.000',
        'Tarif Akhir Pekan (WNI)': '30.000',
      },

      // DATA PANTAI
      {
        'nama': 'Pantai Tanjung Tinggi',
        'wilayah': 'Sumatra',
        'lokasi': 'Belitung, Bangka Belitung',
        'kategori': 'Pantai',
        'tipe_pasir': 'Putih Halus',
        'suhu': '29°C',
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

      // DATA DANAU
      {
        'nama': 'Danau Labuan Cermin',
        'wilayah': 'Kalimantan',
        'lokasi': 'Berau, Kalimantan Timur',
        'kategori': 'Danau',
        'kedalaman': '15 Meter',
        'status': 'Aman Berenang',
        'image': 'assets/LabuanC.png',
        'jalur': 'Akses menggunakan perahu sewa dari dermaga Desa Biduk-Biduk.',
        'Tarif Hari Kerja (WNA)': '50.000',
        'Tarif Akhir Pekan (WNA)': '50.000',
        'Tarif Hari Kerja (WNI)': '15.000',
        'Tarif Akhir Pekan (WNI)': '15.000',
      },
      {
        'nama': 'Danau Sentani',
        'wilayah': 'Maluku dan Papua',
        'lokasi': 'Jayapura, Papua',
        'kategori': 'Danau',
        'kedalaman': '75 Meter',
        'status': 'Wisata Perahu',
        'image': 'assets/Sentani.png',
        'jalur':
            'Dapat diakses langsung melalui jalan raya utama Jayapura-Sentani.',
        'Tarif Hari Kerja (WNA)': '10.000',
        'Tarif Akhir Pekan (WNA)': '10.000',
        'Tarif Hari Kerja (WNI)': '10.000',
        'Tarif Akhir Pekan (WNI)': '10.000',
      },
      {
        'nama': 'Danau Kelimutu',
        'wilayah': 'Bali dan Nusa Tenggara',
        'lokasi': 'Ende, NTT',
        'kategori': 'Danau',
        'kedalaman': '127 Meter',
        'status': 'Hanya Observasi',
        'image': 'assets/Kelimutu.png',
        'jalur':
            'Jalur aspal mendaki dari Desa Moni hingga area parkir puncak.',
        'Tarif Hari Kerja (WNA)': '150.000',
        'Tarif Akhir Pekan (WNA)': '150.000',
        'Tarif Hari Kerja (WNI)': '20.000',
        'Tarif Akhir Pekan (WNI)': '20.000',
      },
      {
        'nama': 'Danau Toba',
        'wilayah': 'Sumatra',
        'lokasi': 'Samosir, Sumatra Utara',
        'kategori': 'Danau',
        'kedalaman': '505 Meter',
        'status': 'Aman Berenang',
        'image': 'assets/Toba.png',
        'jalur': 'Akses kapal feri dari Pelabuhan Ajibata menuju Tomok/Tuktuk.',
        'Tarif Hari Kerja (WNA)': '30.000',
        'Tarif Akhir Pekan (WNA)': '40.000',
        'Tarif Hari Kerja (WNI)': '15.000',
        'Tarif Akhir Pekan (WNI)': '20.000',
      },
      {
        'nama': 'Danau Kumbolo',
        'wilayah': 'Jawa',
        'lokasi': 'Lumajang, Jawa Timur',
        'kategori': 'Danau',
        'kedalaman': '28 Meter',
        'status': 'Dilarang Berenang',
        'image': 'assets/Kumbolo.png',
        'jalur':
            'Trekking melalui jalur pendakian Gunung Semeru (Pos Ranu Pani).',
        'Tarif Hari Kerja (WNA)': '210.000',
        'Tarif Akhir Pekan (WNA)': '310.000',
        'Tarif Hari Kerja (WNI)': '19.000',
        'Tarif Akhir Pekan (WNI)': '24.000',
      },

      // DATA AIR TERJUN
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
  }
}

// ========== SEARCH DELEGATE ==========
class DestinasiSearchDelegate extends SearchDelegate<Map<String, dynamic>?> {
  @override
  String get searchFieldLabel => 'Cari destinasi...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F4529),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.white),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    final allDestinations = DataDestinasi.getAllDestinations();

    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              'Cari Destinasi Wisata',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ketik nama atau lokasi destinasi',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final suggestions = allDestinations.where((dest) {
      final queryLower = query.toLowerCase();
      return dest['nama'].toLowerCase().contains(queryLower) ||
          dest['lokasi'].toLowerCase().contains(queryLower) ||
          dest['kategori'].toLowerCase().contains(queryLower) ||
          dest['wilayah'].toLowerCase().contains(queryLower);
    }).toList();

    if (suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 20),
            const Text(
              "Destinasi Tidak Ditemukan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Coba kata kunci lain",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              close(context, item);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UniversalDetailWisataPage(data: item),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item['image'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['nama'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item['lokasi'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F4529).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['kategori'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1F4529),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Color(0xFF1F4529),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ========== UNIVERSAL DETAIL PAGE ==========
class UniversalDetailWisataPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const UniversalDetailWisataPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F4529),
        toolbarHeight: 100,
        title: Text(data['nama'], style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
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
                child: const Icon(Icons.image, size: 80),
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
                      Expanded(
                        child: Text(
                          data['lokasi'],
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 40, thickness: 1),
                  _buildCategorySpecificInfo(),
                  const Divider(height: 40, thickness: 1),
                  const Text(
                    "Jalur Akses",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF1F4529)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.alt_route, color: Color(0xFF1F4529)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            data['jalur'] ?? '-',
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

  Widget _buildCategorySpecificInfo() {
    final kategori = data['kategori'];

    if (kategori == 'Gunung') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoColumn(
            Icons.terrain,
            "Ketinggian",
            data['ketinggian'] ?? '-',
          ),
          _buildInfoColumn(Icons.timer, "Estimasi", data['estimasi'] ?? '-'),
          _buildInfoColumn(Icons.category, "Kategori", data['kategori']),
        ],
      );
    } else if (kategori == 'Pantai') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoColumn(
            Icons.beach_access,
            "Tipe Pasir",
            data['tipe_pasir'] ?? '-',
          ),
          _buildInfoColumn(Icons.thermostat, "Suhu", data['suhu'] ?? '-'),
          _buildInfoColumn(Icons.category, "Kategori", data['kategori']),
        ],
      );
    } else if (kategori == 'Danau') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoColumn(
            Icons.straighten,
            "Kedalaman",
            data['kedalaman'] ?? '-',
          ),
          _buildInfoColumn(Icons.security, "Status", data['status'] ?? '-'),
          _buildInfoColumn(Icons.category, "Kategori", data['kategori']),
        ],
      );
    } else if (kategori == 'Air Terjun') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoColumn(
            Icons.directions_walk,
            "Jarak Trek",
            data['jarak_trek'] ?? '-',
          ),
          _buildInfoColumn(Icons.timer, "Durasi", data['durasi'] ?? '-'),
          _buildInfoColumn(Icons.category, "Kategori", data['kategori']),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoColumn(Icons.category, "Kategori", data['kategori']),
        _buildInfoColumn(Icons.place, "Wilayah", data['wilayah'] ?? '-'),
      ],
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF1F4529), size: 28),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
