import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notifikasi.dart';
import 'beranda.dart'; // Import ini penting untuk mengakses DestinasiSearchDelegate dan DataDestinasi

// --- DATA STORAGE TIKET STATIS ---
class TicketData {
  static ValueNotifier<List<Map<String, dynamic>>> myTickets = ValueNotifier(
    [],
  );

  static void addTicket(Map<String, dynamic> ticket) {
    myTickets.value = [ticket, ...myTickets.value];
  }
}

class TiketPage extends StatefulWidget {
  const TiketPage({super.key});

  @override
  State<TiketPage> createState() => _TiketPageState();
}

class _TiketPageState extends State<TiketPage> {
  // Helper Format Rupiah
  String _formatCurrency(dynamic amount) {
    int price = 0;
    if (amount is String) {
      price =
          int.tryParse(amount.replaceAll('.', '').replaceAll('Rp ', '')) ?? 0;
    } else if (amount is int) {
      price = amount;
    }
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  // --- FUNGSI PENCARIAN DIUBAH UNTUK MENCARI WISATA ALAM ---
  void _showSearch() {
    // Menggunakan DestinasiSearchDelegate yang ada di main.dart
    // sehingga data yang dicari adalah data dari DataDestinasi.getAllDestinations()
    showSearch(context: context, delegate: DestinasiSearchDelegate());
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
              valueListenable: TicketData.myTickets,
              builder: (context, List<Map<String, dynamic>> tickets, child) {
                return tickets.isEmpty
                    ? _buildEmptyState()
                    : _buildTicketList(tickets);
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
          Row(
            children: [
              // Tombol Search sekarang mencari Wisata Alam (Gunung, Pantai, dll)
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 28),
                onPressed: _showSearch,
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
          const Icon(
            Icons.confirmation_number_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            "Belum Ada Riwayat Tiket",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Jika ingin kembali ke tab beranda, pastikan navigasi sesuai dengan struktur app Anda
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TiketinNusaHome(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F4529),
            ),
            child: const Text(
              "Mulai Pesan",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketList(List<Map<String, dynamic>> tickets) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        return _buildTicketCard(tickets[index]);
      },
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    return GestureDetector(
      onTap: () => _showTicketDetail(ticket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
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
        child: Row(
          children: [
            const Icon(
              Icons.confirmation_number,
              color: Color(0xFF1F4529),
              size: 40,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket['nama'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Kunjungan: ${ticket['tglMasuk']}",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(ticket['totalHarga']),
                    style: const TextStyle(
                      color: Color(0xFF1F4529),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.qr_code_2_rounded,
              color: Colors.black54,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  // Menampilkan modal struk tiket (Tetap dipertahankan untuk riwayat tiket)
  void _showTicketDetail(Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "E-STRUK PEMBAYARAN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAF9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.qr_code_2_rounded,
                    size: 140,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ID: TKN-${ticket['nama'].hashCode}",
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.black12,
                  ),
                  _buildDetailRow("Destinasi", ticket['nama']),
                  _buildDetailRow("Tanggal", ticket['tglMasuk']),
                  _buildDetailRow("Status", "LUNAS", isSuccess: true),
                  const Divider(),
                  _buildDetailRow(
                    "TOTAL BAYAR",
                    _formatCurrency(ticket['totalHarga']),
                    isBold: true,
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F4529),
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Tutup",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isSuccess = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold || isSuccess
                  ? FontWeight.bold
                  : FontWeight.w600,
              color: isSuccess ? Colors.green : Colors.black,
              fontSize: isBold ? 16 : 13,
            ),
          ),
        ],
      ),
    );
  }
}
