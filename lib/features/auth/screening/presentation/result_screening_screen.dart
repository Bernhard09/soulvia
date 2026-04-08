import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soulvie_app/common/app_colors.dart';
import 'package:soulvie_app/features/dashboard/presentation/dashboard_screen.dart';

class ResultScreen extends StatefulWidget {
  final String testResult;

  const ResultScreen({super.key, required this.testResult});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // State untuk mengontrol apakah card aktivitas sedang terbuka atau tertutup
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            // Hapus 'height: 210' agar Container tumbuh sesuai isi
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Stack(
              children: [
                // Watermark Logo SVG Samar (Latar Belakang)
                Positioned(
                  top: -40,
                  right: -100,
                  child: Opacity(
                    opacity: 0.1,
                    child: SvgPicture.asset(
                      'assets/images/app_logo.svg', // Pastikan path benar di pubspec.yaml
                      width: 250,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),

                // SafeArea agar konten tidak menabrak status bar (notch)
                SafeArea(
                  bottom: false, // Jarak bawah diatur padding Container
                  child: Padding(
                    // Berikan padding yang cukup di bawah agar lengkungan render rapi
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 16,
                      bottom: 40,
                    ),
                    child: Column(
                      // crossAxisAlignment diatur .center agar teks di tengah sesuai desain
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // AppBar Custom (Tombol Back & Judul)
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DashboardScreen(),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Rekomendasi Soulvia',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ), // Jarak ke teks "Hasil Tes Anda"
                        // Teks Penjelasan Kecil
                        const Text(
                          'Hasil Tes Anda',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 8),

                        // Menampilkan Hasil Dinamis (Sesuai parameter input)
                        Text(
                          widget.testResult, // Menggunakan variabel input
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),
                        const Text(
                          'Rekomendasi terbaik dari Soulvia berdasarkan\nKuesioner DASS 21',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- BODY SECTION (Scrollable Content) ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Konten
                  const Text(
                    'Ayo jalani aktivitas mu Hari ini!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Yuk bergerak hari ini, jaga mood tetap positif!',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // --- EXPANDABLE CARD AKTIVITAS ---
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF5F5F5,
                      ), // Warna abu-abu terang sesuai gambar
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: [
                        // Card Header (Gambar, Teks, Tombol Toggle)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Tambahkan ini agar semua elemen rata atas
                          children: [
                            // 1. Gambar Avatar PNG
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/images/ilustrasi_aktivitas.svg'
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // 2. Info Aktivitas
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Aktivitas Harian 1',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '18 Maret 2024',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // 3. (BARU) Cyan Pill dan Icon digabung dalam Column
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .end, // Agar merapat ke kanan
                              children: [
                                // Hiasan Cyan Pill
                                Container(
                                  width:
                                      40, // Sedikit dilebarkan agar proporsional
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ), // Jarak atas-bawah antara pill dan ikon
                                // Tombol Minus/Plus (Toggle Dropdown)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                  child: Icon(
                                    _isExpanded
                                        ? Icons.remove_circle_outline
                                        : Icons.add_circle_outline,
                                    color: Colors.black87,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // List Item di dalam Card (Hanya muncul jika _isExpanded == true)
                        if (_isExpanded) ...[
                          const SizedBox(height: 20),
                          _buildActivityItem(
                            'Moving Detection',
                            'Mulai peregangan hari ini!',
                          ),
                          _buildActivityItem(
                            'Meditasi',
                            'Tenangkan pikiranmu sejenak.',
                          ),
                          _buildActivityItem(
                            'Koleksi Syukur',
                            'Catat hal-hal baik yang terjadi hari ini.',
                          ),
                          _buildActivityItem(
                            'Mind Sorting',
                            'Rapikan isi kepalamu agar lebih fokus.',
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- BOTTOM BUTTON (Tes Ulang) ---
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tes Ulang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER UNTUK ITEM AKTIVITAS ---
  Widget _buildActivityItem(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          // Lingkaran Centang Tosca
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4.0),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),

          // Teks Judul & Subjudul
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
