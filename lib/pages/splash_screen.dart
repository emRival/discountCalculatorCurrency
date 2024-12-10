import 'dart:async';

import 'package:discount_and_currency_calculator/pages/navigation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    super.initState();
    // Delay 3 detik
    Timer(const Duration(seconds: 3), () {
      // Pindah ke halaman HomeScreen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyNavigation()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 105, 104, 107),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau animasi
            Image.asset(
              'assets/images/icon.png', // pastikan gambar ada di folder assets
              width: 200, // ukuran gambar
              height: 200,
            ),
            const SizedBox(height: 20),
            // Teks Splash
            const Text(
              'KalkuDiskon',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
