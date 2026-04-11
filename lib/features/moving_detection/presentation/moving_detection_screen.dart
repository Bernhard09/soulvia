import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soulvie_app/features/moving_detection/presentation/moving_detection_active_screen.dart'; // Pastikan package ini sudah di-import

class MovingDetectionScreen extends ConsumerWidget {
  const MovingDetectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F5F5,
      ), // Warna background abu-abu terang
      body: Column(
        children: [
          // --- HEADER MELENGKUNG DENGAN BACKGROUND SVG ---
          Container(
            width: double.infinity,
            clipBehavior: Clip
                .antiAlias, // Penting agar SVG terpotong rapi mengikuti lengkungan
            decoration: const BoxDecoration(
              color: Color(0xFF00A79D), // Warna Teal Soulvia
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Stack(
              children: [
                // 1. Layer Paling Bawah: Background SVG Gelombang
                Positioned.fill(
                  child: SvgPicture.asset(
                    'assets/images/LooperGroup.svg', // Pastikan path ini sesuai
                    fit: BoxFit.cover,
                  ),
                ),

                // 2. Layer Atas: Konten Teks dan Profil
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // App Bar Custom
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Moving Detection',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Avatar & Lencana Kamera
                      const SizedBox(height: 16),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          // Lingkaran Profil
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            // <--- Ganti Icon ini dengan SvgPicture/Image profil nanti --->
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),

                          // Lencana Kamera Kecil
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF00A79D),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Color(0xFF00A79D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Nama User
                      const Text(
                        'Pandu Revi Arnan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ), // Ruang ekstra di bawah melengkung
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- KONTEN TENGAH (KARAKTER & INSTRUKSI) ---
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Placeholder Karakter 3D
                  Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // <--- Ganti Icon ini dengan Image.asset karakter 3D dari Figma --->
                    child: Image.asset('assets/images/moving1.png'),
                  ),

                  // Label "Ikuti Gerakan..."
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A79D),
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Bentuk Pil (Stadium)
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Ikuti Gerakan Karakter Dengan Baik',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- TOMBOL BAWAH ---
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity, // Tombol selebar layar
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A79D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // Aksi Tes Ulang
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovingDetectionActiveScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Mulai Tes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Spasi tambahan untuk area bawah HP agar tidak nabrak notch/nav bar
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
