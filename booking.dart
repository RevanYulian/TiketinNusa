import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'notifikasi.dart';
import 'tiket.dart'; // PASTIKAN FILE TIKET.DART SUDAH ADA

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> dataWisata;
  const BookingPage({super.key, required this.dataWisata});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  String _selectedPaymentMethod = "QRIS";
  String? _selectedBank;

  final List<String> _listBanks = [
    "Visa",
    "Mastercard",
    "BCA",
    "Mandiri",
    "BNI",
    "BRI",
    "JCB",
    "American Express",
  ];

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _tglMasukController = TextEditingController();
  final TextEditingController _tglKeluarController = TextEditingController();
  final TextEditingController _expiredController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _jumlahPesananController = TextEditingController(
    text: "1",
  );

  String? _selectedNegara;
  String? _selectedGender;

  final List<String> _listNegara = [
    "Indonesia",
    "Malaysia",
    "Singapura",
    "Thailand",
    "Lainnya",
  ];
  final List<String> _listGender = ["Laki-laki", "Perempuan"];

  @override
  void initState() {
    super.initState();
    _codeController.text = (Random().nextInt(900) + 100).toString();
  }

  int get _hargaSatuan {
    bool isWNI = _selectedNegara == "Indonesia";
    String key = isWNI ? 'Tarif Hari Kerja (WNI)' : 'Tarif Hari Kerja (WNA)';
    // Membersihkan titik agar bisa dihitung sebagai angka
    String priceRaw = widget.dataWisata[key].toString().replaceAll('.', '');
    return int.tryParse(priceRaw) ?? 0;
  }

  int get _totalBiaya {
    int jumlah = int.tryParse(_jumlahPesananController.text) ?? 0;
    return _hargaSatuan * jumlah;
  }

  String _formatRupiah(int amount) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller, {
    bool isMasuk = false,
  }) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1F4529),
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
        controller.text = formattedDate;
        if (isMasuk) {
          DateTime expiredDate = picked.add(const Duration(days: 1));
          _expiredController.text = DateFormat(
            'dd/MM/yyyy',
          ).format(expiredDate);
        }
      });
    }
  }

  void _nextPage() => _pageController.nextPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F4529),
        toolbarHeight: 78,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _previousPage,
        ),
        title: Text(
          "Tiket ${widget.dataWisata['nama']}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentStep = index),
        children: [_buildStepLokasi(), _buildStepBiodata(), _buildStepBayar()],
      ),
    );
  }

  Widget _buildStepLokasi() {
    bool isGunung = widget.dataWisata['kategori'] == 'Gunung';
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (isGunung) ...[
                  _buildField(
                    "Pos Perizinan Masuk",
                    Icons.location_on_outlined,
                  ),
                  _buildField(
                    "Pos Perizinan Keluar",
                    Icons.location_on_outlined,
                  ),
                ],
                _buildDateField(
                  "Tanggal Masuk",
                  _tglMasukController,
                  isMasuk: true,
                ),
                _buildDateField("Tanggal Keluar", _tglKeluarController),
                _buildField(
                  "Jumlah Pemesanan",
                  Icons.people_outline,
                  controller: _jumlahPesananController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => setState(() {}),
                ),
              ],
            ),
          ),
          _buildPrimaryButton("Berikutnya", _nextPage),
        ],
      ),
    );
  }

  Widget _buildStepBiodata() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildField(
                  "Masukkan Nama",
                  Icons.person_outline,
                  controller: _namaController,
                ),
                _buildField(
                  "Masukkan Nomor Handphone",
                  Icons.phone_android,
                  controller: _hpController,
                ),
                _buildField("Masukkan Alamat Rumah", Icons.home_outlined),
                _buildDropdownField(
                  "Negara",
                  Icons.flag_outlined,
                  _listNegara,
                  _selectedNegara,
                  (val) => setState(() => _selectedNegara = val),
                ),
                _buildDropdownField(
                  "Gender",
                  Icons.wc,
                  _listGender,
                  _selectedGender,
                  (val) => setState(() => _selectedGender = val),
                ),
              ],
            ),
          ),
          _buildPrimaryButton("Berikutnya", _nextPage),
        ],
      ),
    );
  }

  Widget _buildStepBayar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Biaya :",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            _formatRupiah(_totalBiaya),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F4529),
            ),
          ),
          const Text(
            "Includes Online Activations (2.0%)",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildPayTab("QRIS", Icons.qr_code_scanner),
              const SizedBox(width: 10),
              _buildPayTab("Kartu Kredit/Debit", Icons.credit_card),
            ],
          ),
          const SizedBox(height: 20),
          if (_selectedPaymentMethod == "Kartu Kredit/Debit") ...[
            _buildDropdownField(
              "Pilih Bank / Jaringan",
              Icons.account_balance,
              _listBanks,
              _selectedBank,
              (val) => setState(() => _selectedBank = val),
            ),
            _buildField("Nomor Kartu", Icons.credit_card),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    "Exp",
                    Icons.calendar_month,
                    controller: _expiredController,
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildField(
                    "CVV",
                    Icons.lock_outline,
                    controller: _codeController,
                    readOnly: true,
                  ),
                ),
              ],
            ),
          ] else ...[
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Column(
                  children: [
                    SizedBox(height: 15),
                    Icon(Icons.qr_code_2, size: 180, color: Colors.black),
                    SizedBox(height: 10),
                    Text(
                      "TiketinNusa - QRIS Payment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "TID: 0123456789",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const Spacer(),
          _buildPrimaryButton("Konfirmasi Bayar", _showSuccessDialog),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF1F4529), size: 60),
            const SizedBox(height: 10),
            const Text(
              "Booking Berhasil!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              _formatRupiah(_totalBiaya),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F4529),
              ),
            ),
            const Divider(),
            _buildReceiptRow("Metode", _selectedPaymentMethod),
            if (_selectedPaymentMethod == "Kartu Kredit/Debit")
              _buildReceiptRow("Bank", _selectedBank ?? "Kartu"),
            _buildReceiptRow(
              "Tanggal",
              DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.qr_code_2, size: 80, color: Colors.black),
            const Text(
              "Scan di pintu masuk",
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildPrimaryButton("Selesai", () {
              // --- LOGIKA INTEGRASI KE TIKET.DART ---
              TicketData.addTicket({
                'nama': widget.dataWisata['nama'],
                'tglMasuk': _tglMasukController.text,
                'totalHarga': _totalBiaya, // Mengirim data harga
                'status': 'Sudah Dibayar',
              });

              NotificationData.addNotification(
                'Booking Berhasil!',
                'E-Ticket untuk ${widget.dataWisata['nama']} senilai ${_formatRupiah(_totalBiaya)} telah terbit.',
              );

              Navigator.pop(context); // Tutup dialog
              Navigator.of(
                context,
              ).popUntil((route) => route.isFirst); // Kembali ke Beranda
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPayTab(String label, IconData icon) {
    bool isActive = _selectedPaymentMethod == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPaymentMethod = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1F4529) : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.black54,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black54,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String hint,
    IconData icon, {
    TextEditingController? controller,
    bool readOnly = false,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F4529),
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? Colors.grey[50] : Colors.white,
              prefixIcon: Icon(icon, size: 20, color: const Color(0xFF1F4529)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF1F4529),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    String label,
    TextEditingController controller, {
    bool isMasuk = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F4529),
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            readOnly: true,
            onTap: () => _selectDate(context, controller, isMasuk: isMasuk),
            decoration: InputDecoration(
              hintText: "dd/mm/yyyy",
              prefixIcon: const Icon(
                Icons.calendar_today,
                size: 20,
                color: Color(0xFF1F4529),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    IconData icon,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F4529),
            ),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            initialValue: selectedValue,
            dropdownColor: Colors.white,
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: const Color(0xFF1F4529)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1F4529),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
