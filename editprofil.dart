import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pengaturan.dart'; // Import provider agar bisa akses data profil

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  // Inisialisasi controller kosong terlebih dahulu
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    // Mengambil data awal dari Provider saat halaman dibuka
    final profile = Provider.of<LanguageProvider>(context, listen: false);

    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBEA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER SELARAS ---
            Container(
              height: 144,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 60, 20, 0),
              decoration: const BoxDecoration(color: Color(0xFF1F4529)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Edit Profil",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Input Nama
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Lengkap",
                      labelStyle: TextStyle(color: Color(0xFF1F4529)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1F4529)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Input Email
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "E-Mail",
                      labelStyle: TextStyle(color: Color(0xFF1F4529)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1F4529)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Input Telepon
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: "Nomor Telepon",
                      labelStyle: TextStyle(color: Color(0xFF1F4529)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1F4529)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Tombol Simpan
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F4529),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // 1. Simpan data ke Provider agar halaman lain ter-update
                      Provider.of<LanguageProvider>(
                        context,
                        listen: false,
                      ).updateProfile(
                        _nameController.text,
                        _emailController.text,
                        _phoneController.text,
                      );

                      // 2. Beri feedback singkat (Opsional)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profil berhasil diperbarui!"),
                        ),
                      );

                      // 3. Kembali ke halaman sebelumnya
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Simpan Perubahan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
