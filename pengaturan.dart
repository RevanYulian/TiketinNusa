// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'halamanprofil.dart';
import 'beranda.dart';
import 'notifikasi.dart';

// --- 1. LANGUAGE & PROFILE PROVIDER ---
class LanguageProvider extends ChangeNotifier {
  String _selectedLanguage = 'Indonesia';

  // Data Profil yang bisa diubah
  String _name = "Arip Wijaya";
  String _email = "aripwijaya28@gmail.com";
  String _phone = "+62 891 2345 6789";

  String get selectedLanguage => _selectedLanguage;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;

  final Map<String, Map<String, String>> _translations = {
    'Indonesia': {
      'app_title': 'TiketinNusa',
      'settings': 'Pengaturan',
      'acc_info': 'Informasi Akun',
      'notif': 'Notifikasi',
      'lang': 'Bahasa',
      'choose_lang': 'Pilih Bahasa',
      'home': 'Beranda',
      'order': 'Tiket',
      'cart': 'Keranjang',
    },
    'English': {
      'app_title': 'TiketinNusa',
      'settings': 'Settings',
      'acc_info': 'Account Information',
      'notif': 'Notifications',
      'lang': 'Language',
      'choose_lang': 'Select Language',
      'home': 'Home',
      'order': 'Tickets',
      'cart': 'Cart',
    },
  };

  String t(String key) {
    return _translations[_selectedLanguage]?[key] ?? key;
  }

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  // Fungsi untuk memperbarui data profil dari halaman edit
  void updateProfile(String newName, String newEmail, String newPhone) {
    _name = newName;
    _email = newEmail;
    _phone = newPhone;
    notifyListeners(); // Memberitahu semua widget untuk refresh
  }
}

// --- 2. HALAMAN PENGATURAN ---
class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  bool isNotificationOn = true;

  void _showSearch() {
    showSearch(context: context, delegate: DestinasiSearchDelegate());
  }

  void _showLanguagePicker(LanguageProvider langProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                langProvider.t('choose_lang'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text('Indonesia'),
                trailing: langProvider.selectedLanguage == 'Indonesia'
                    ? const Icon(Icons.check, color: Color(0xFF1F4529))
                    : null,
                onTap: () {
                  langProvider.setLanguage('Indonesia');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                trailing: langProvider.selectedLanguage == 'English'
                    ? const Icon(Icons.check, color: Color(0xFF1F4529))
                    : null,
                onTap: () {
                  langProvider.setLanguage('English');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE8EFED),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER (Area Hijau) ---
            Container(
              height: 144,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
              decoration: const BoxDecoration(color: Color(0xFF1F4529)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    langProvider.t('app_title'),
                    style: const TextStyle(
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
            ),

            // --- KONTEN UTAMA ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECTION 1: PROFIL USER (Data dari Provider) ---
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFF1F4529),
                          child: CircleAvatar(
                            radius: 47,
                            backgroundImage: AssetImage('assets/favicon.png'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          langProvider.name, // Dinamis dari Provider
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F4529),
                          ),
                        ),
                        Text(
                          langProvider.email, // Dinamis dari Provider
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    langProvider.t('settings'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F4529),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Item Informasi Akun
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF1F4529),
                      ),
                      title: Text(langProvider.t('acc_info')),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyProfilePage(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Item Notifikasi
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF1F4529),
                      ),
                      title: Text(langProvider.t('notif')),
                      trailing: Switch(
                        value: isNotificationOn,
                        activeColor: const Color(0xFF1F4529),
                        onChanged: (value) =>
                            setState(() => isNotificationOn = value),
                      ),
                    ),
                  ),

                  // Item Bahasa
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.language,
                        color: Color(0xFF1F4529),
                      ),
                      title: Text(langProvider.t('lang')),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            langProvider.selectedLanguage,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                      onTap: () => _showLanguagePicker(langProvider),
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
