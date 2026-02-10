// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pengaturan.dart'; // Pastikan mengimport file provider
import 'editprofil.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari LanguageProvider
    final langProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE9EBEA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER HIJAU ---
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      langProvider.t(
                        'acc_info',
                      ), // Menggunakan terjemahan dari provider
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Foto Profil
            const CircleAvatar(
              radius: 82,
              backgroundColor: Color(0xFF1F4529),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/favicon.png'),
              ),
            ),

            const SizedBox(height: 15),

            // Nama Pengguna - Mengambil dari Provider
            Text(
              langProvider.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F4529),
              ),
            ),

            // Tombol Edit Profil
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilPage(),
                  ),
                );
              },
              icon: const Icon(Icons.edit, size: 18, color: Colors.black54),
              label: const Text(
                "Edit Profil",
                style: TextStyle(color: Colors.black54),
              ),
            ),

            const SizedBox(height: 20),

            // Bagian "Tentang"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tentang",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1F4529),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Card Informasi - Semua data mengambil dari langProvider
                  _buildProfileCard(
                    columnContent: [
                      _buildRowInfo("Nama Lengkap", langProvider.name),
                      const Divider(height: 1),
                      _buildRowInfo("E-Mail", langProvider.email),
                    ],
                  ),

                  const SizedBox(height: 15),

                  _buildProfileCard(
                    columnContent: [
                      _buildRowInfo("Nomor Telepon", langProvider.phone),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Tombol Keluar
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                    child: _buildActionCard(
                      icon: Icons.logout,
                      text: "Keluar",
                      textColor: Colors.grey[700]!,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Tombol Hapus Akun
                  GestureDetector(
                    onTap: () {
                      _showDeleteDialog(context);
                    },
                    child: _buildActionCard(
                      icon: Icons.delete_outline,
                      text: "Hapus Akun",
                      textColor: Colors.red,
                      iconColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Akun"),
        content: const Text("Apakah Anda yakin ingin menghapus akun?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            ),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          const Text(" :  "),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard({required List<Widget> columnContent}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: columnContent),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String text,
    required Color textColor,
    Color iconColor = Colors.grey,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 15),
          Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
