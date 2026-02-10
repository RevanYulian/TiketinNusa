import 'package:flutter/material.dart';
import 'beranda.dart'; // Menghubungkan ke halaman Beranda setelah masuk
import 'registrasi.dart'; // Menghubungkan ke halaman Registrasi jika belum punya akun

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Fungsi simulasi untuk menangani klik sosial media
  void _handleSocialLogin(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Masuk dengan $provider...'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1B3D26),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- TOMBOL BACK ---
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1B3D26),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Kembali ke Onboarding
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // --- JUDUL ---
              const Text(
                'Selamat Datang!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3D26),
                ),
              ),
              const Text(
                'Silahkan Masuk Ke Akun Anda',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),

              const SizedBox(height: 40),

              // --- INPUT FIELDS ---
              _buildTextField(hint: 'E-Mail'),
              _buildTextField(hint: 'Kata Sandi', isPassword: true),

              const SizedBox(height: 10),

              // --- LUPA KATA SANDI ---
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Logika lupa kata sandi
                  },
                  child: const Text(
                    "Lupa Kata Sandi?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- TOMBOL MASUK ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TiketinNusaHome(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3D26),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Atau Masuk Dengan',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              // --- SOSIAL MEDIA (Google, Facebook, Apple) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialIcon(
                    context: context,
                    url:
                        'https://cdn-icons-png.flaticon.com/512/2991/2991148.png', // Google
                    label: 'Google',
                  ),
                  const SizedBox(width: 20),
                  _socialIcon(
                    context: context,
                    url:
                        'https://cdn-icons-png.flaticon.com/512/733/733547.png', // Facebook
                    label: 'Facebook',
                  ),
                  const SizedBox(width: 20),
                  _socialIcon(
                    context: context,
                    url:
                        'https://cdn-icons-png.flaticon.com/512/0/747.png', // Apple
                    label: 'Apple',
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- NAVIGASI KE REGISTRASI ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        color: Color(0xFF1B3D26),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget: Input Field
  Widget _buildTextField({required String hint, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          filled: true,
          fillColor: const Color(0xFFE0E0E0),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Helper Widget: Ikon Sosial Media (Network Image)
  Widget _socialIcon({
    required BuildContext context,
    required String url,
    required String label,
  }) {
    return InkWell(
      onTap: () => _handleSocialLogin(context, label),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 60,
        width: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }
}
