import 'package:flutter/material.dart';
import 'dart:async'; // Diperlukan untuk Timer/Future
import 'p.dart'; // Mengimport OnboardingScreen dari p.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    // Logika berpindah halaman setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A24), //
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 180,
              height: 180,
              child: Image.asset(
                'assets/favicon.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.confirmation_number_outlined,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (index) {
                          double begin = index * 0.2;
                          double end = begin + 0.6;

                          double value = CurvedAnimation(
                            parent: _controller,
                            curve: Interval(
                              begin > 1.0 ? 0.0 : begin,
                              end > 1.0 ? 1.0 : end,
                            ),
                          ).value;

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            transform: Matrix4.translationValues(
                              0,
                              -6 * value,
                              0,
                            ),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'TiketinNusa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
