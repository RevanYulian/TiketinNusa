import 'package:flutter/material.dart';
import 'splashscren.dart'; // Pastikan nama file sesuai
import 'package:provider/provider.dart';
import 'pengaturan.dart';

void main() {
  runApp(
    // Inisialisasi Provider di sini agar bisa diakses seluruh aplikasi
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
      title: 'TiketinNusa',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      // UBAH BAGIAN INI:
      home: const MainHomePage(), // Ganti dari PengaturanPage ke MainHomePage
    );
  }
}

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A24),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                // Navigasi TANPA animasi geser
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const SplashScreen(),
                    transitionDuration:
                        Duration.zero, // Membuat perpindahan instan
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                padding: const EdgeInsets.all(2),
                child: Image.asset('assets/favicon.png', fit: BoxFit.contain),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 80.0),
              child: Text(
                'TiketinNusa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
