import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soulvie_app/common/app_colors.dart';
import 'package:soulvie_app/features/auth/screening/presentation/form_screening_screen.dart';

class KuesionerWelcomeScreen extends StatelessWidget {
  const KuesionerWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background utama menjadi warna primary (teal)
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Stack(
            children: [
              Positioned(
                top: 0,
                right: -100,
                child: Opacity(
                  opacity: 0.1,
                  child: SvgPicture.asset(
                    'assets/images/app_logo.svg', // Pastikan path SVG kamu benar
                    width: 250,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              // 2. Konten Header
              SafeArea(
                bottom:
                    false, // Hanya SafeArea di bagian atas (notch/status bar)
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Kuesioner',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          // Foto Profil
                          const CircleAvatar(
                            radius: 18,

                            child: Icon(Icons.person, color: Colors.black),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Judul Utama Kuesioner
                      const Text(
                        'Kuisioner DASS - 21',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Depression Anxiety Stress Scales - Short Form',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 5), // Jarak sebelum card putih
                    ],
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Konten
                    const Text(
                      'Penjelasan singkat tentang kuis ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Item 1: 21 Pertanyaan
                    _buildFeatureItem(
                      icon: Icons
                          .article_outlined, // Jika ingin pakai SVG, kamu bisa ganti parameternya nanti
                      title: '21 Pertanyaan',
                      subtitle: '4 pilihan pertanyaan skor',
                    ),
                    const SizedBox(height: 20),

                    // Item 2: Rekomendasi hasil
                    _buildFeatureItem(
                      icon: Icons.star_border_rounded,
                      title: 'Rekomendasi hasil',
                      subtitle: 'Rekomendasi aktivitas harian',
                    ),

                    const SizedBox(height: 32),

                    // Instruksi Teks
                    const Text(
                      'Silakan baca teks di bawah ini dengan saksama agar Anda dapat memahaminya.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // List Bullet Point
                    _buildBulletPoint(
                      'Silakan baca setiap pernyataan dan pilih jawaban yang menunjukkan seberapa besar pernyataan tersebut berlaku untuk Anda selama seminggu terakhir.',
                    ),
                    const SizedBox(height: 12),
                    _buildBulletPoint(
                      'Tidak ada jawaban yang benar atau salah. Jangan menghabiskan terlalu banyak waktu pada setiap pernyataan.',
                    ),

                    // Spacer agar tombol selalu terdorong ke bawah layar
                    const SizedBox(height: 24 * 3),

                    // Tombol Mulai Tes
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigasi ke halaman form kuesioner
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScreeningScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Mulai Tes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Tambahan padding bawah jika di iOS tidak menggunakan SafeArea di body
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER UNTUK ITEM FITUR ---
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        // Lingkaran Icon Hitam/Abu-abu gelap
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFF3A3A3C), // Warna gelap sesuai gambar
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
          /* Jika icon-nya SVG, gunakan ini:
             child: Center(
               child: SvgPicture.asset('assets/icons/nama_icon.svg', width: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
             ),
          */
        ),
        const SizedBox(width: 16),
        // Teks Judul & Subjudul
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET HELPER UNTUK BULLET POINT ---
  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6.0, right: 12.0),
          child: Icon(Icons.circle, size: 6, color: Colors.black54),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
