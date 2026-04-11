import 'dart:async';
import 'package:flutter/material.dart';

class MovingDetectionActiveScreen extends StatefulWidget {
  const MovingDetectionActiveScreen({super.key});

  @override
  State<MovingDetectionActiveScreen> createState() =>
      _MovingDetectionActiveScreenState();
}

class _MovingDetectionActiveScreenState
    extends State<MovingDetectionActiveScreen> {
  // --- STATE UNTUK LOGIKA MVP ---
  int _currentIndex = 0;
  int _secondsRemaining = 20;
  Timer? _timer;
  bool _isActive = false;

  // Data Dummy Gerakan (Sesuai Gambar Figma-mu)
  final List<Map<String, String>> _poses = [
    {
      'instruction': 'Angkat Kepala, Tangan di Dagu',
      'image_path':
          'assets/images/moving_up.png', // Sesuaikan nama filemu nanti
    },
    {
      'instruction': 'Tengok kiri, Tangan di pipi',
      'image_path': 'assets/images/moving_right.png',
    },
    {
      'instruction': 'Tengkok kanan, Tangan di pipi',
      'image_path': 'assets/images/moving_left.png',
    },
  ];

  @override
  void dispose() {
    _timer?.cancel(); // Pastikan timer mati saat pindah halaman
    super.dispose();
  }

  // Fungsi Mulai / Ulangi Timer
  void _toggleTimer() {
    if (_isActive) {
      _timer?.cancel();
      setState(() {
        _isActive = false;
        _secondsRemaining = 20; // Reset ke 20 detik
      });
    } else {
      setState(() {
        _isActive = true;
        _secondsRemaining = 20;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          timer.cancel();
          setState(() => _isActive = false);
          // Beri notifikasi kalau waktu habis
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Waktu habis! Gerakan selesai.')),
          );
        }
      });
    }
  }

  // Fungsi Pindah Pose
  void _changePose(int step) {
    setState(() {
      _currentIndex = (_currentIndex + step) % _poses.length;
      if (_currentIndex < 0)
        _currentIndex = _poses.length - 1; // Looping ke belakang
      _secondsRemaining = 20; // Reset timer saat ganti pose
      _isActive = false;
      _timer?.cancel();
    });
  }

  // Format angka "20" menjadi "00:20"
  String get _formattedTime {
    return '00:${_secondsRemaining.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentPose = _poses[_currentIndex];

    return Scaffold(
      // --- BACKGROUND GRADIENT KEBIRUAN ---
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6E85F0), // Biru atas
              Color(0xFFA1ACFF), // Ungu/Biru muda bawah
            ],
          ),
          // <--- ASSET PLACEHOLDER: Jika ada background pattern bubble --->
          // image: DecorationImage(
          //   image: AssetImage('assets/images/bg_bubbles.png'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- APP BAR CUSTOM (TRANSPARAN) ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'moving detection',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.ios_share, color: Colors.white),
                      onPressed: () {}, // Dummy share
                    ),
                  ],
                ),
              ),

              // --- AREA KARAKTER & KARTU INSTRUKSI ---
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Karakter 3D (Berada di tengah agak ke bawah)
                    Positioned(
                      bottom:
                          80, // Memberi ruang agar tidak tertutup kartu instruksi
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                        // <--- ASSET PLACEHOLDER: Gambar Karakter --->
                        child: Container(
                          key: ValueKey<int>(
                            _currentIndex,
                          ), // Kunci agar animasi jalan saat ganti index
                          height: 350,
                          width: 300,
                          alignment: Alignment.bottomCenter,
                          // Ganti Icon ini dengan Image.asset(currentPose['image_path']!)
                          child: Image.asset(currentPose['image_path']!),
                        ),
                      ),
                    ),

                    // Kartu Instruksi Teal
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 20.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A79D), // Teal Soulvia
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentPose['instruction']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Pill Timer (Menyala putih saat jalan, pudar saat diam)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _formattedTime,
                              style: TextStyle(
                                color: const Color(0xFF00A79D),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- TOMBOL KONTROL BAWAH ---
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  bottom: 32.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol Kiri (Previous Pose)
                    InkWell(
                      onTap: () => _changePose(-1),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00A79D),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Tombol Tengah (Mulai / Ulangi)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Color(0xFF00A79D),
                                  width: 1.5,
                                ), // Garis border teal
                              ),
                              elevation: 0,
                            ),
                            onPressed: _toggleTimer,
                            child: Text(
                              _isActive ? 'Berhenti' : 'Mulai / Ulangi',
                              style: const TextStyle(
                                color: Color(0xFF00A79D),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tombol Kanan (Next Pose)
                    InkWell(
                      onTap: () => _changePose(1),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00A79D),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
