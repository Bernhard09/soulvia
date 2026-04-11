import 'package:flutter/material.dart';
import 'dart:math';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5), // Background abu-abu terang
        body: Column(
          children: [
            // --- 1. HEADER KUSTOM (TEAL) SAJA ---
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF00A79D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Mood Tracker',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ), // Jarak pemisah agar TabBar turun ke bawah
            // --- 2. TAB BAR (BENTUK PIL, MELAYANG DI ATAS KONTEN) ---
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ), // Margin agar tidak mentok layar
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors
                    .transparent, // Penting: Menghilangkan garis bawah bawaan Flutter
                indicator: BoxDecoration(
                  color: const Color(0xFF00A79D),
                  borderRadius: BorderRadius.circular(25),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Harian'),
                  Tab(text: 'Mingguan'),
                ],
              ),
            ),

            // --- 3. ISI KONTEN ---
            Expanded(
              child: TabBarView(
                children: [_buildTabHarian(), _buildTabMingguan()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: HARIAN
  // ==========================================
  Widget _buildTabHarian() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF00A79D),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Akhir-akhir ini, kamu mungkin butuh waktu untuk menenangkan diri. Yuk, mulai dari langkah kecil hari ini',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Donut Chart Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mood harian mu!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Senin, 2 Februari 2026',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    Icon(Icons.send, color: Colors.black87),
                  ],
                ),
                const SizedBox(height: 30),

                // Pure Flutter Donut Chart
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: CustomPaint(
                      painter: DonutChartPainter(),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Bahagia!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Mendominasi harimu',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Emoji Counters
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEmojiBadge('😆', 'Bahagia', '23', Colors.orange),
                    _buildEmojiBadge('😁', 'Senang', '4', Colors.green),
                    _buildEmojiBadge('😐', 'Netral', '2', Colors.redAccent),
                    _buildEmojiBadge('😢', 'Sedih', '5', Colors.blue),
                    _buildEmojiBadge('😫', 'Depresi', '12', Colors.pink),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Log History
          const Text(
            'Senin, 2 Februari 2026',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Berikut laporan mood harian kamu!',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Text('😆', style: TextStyle(fontSize: 40)),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '17.00',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Kamu merasa bahagia hari ini!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: MINGGUAN (GRAFIK BATANG)
  // ==========================================
  Widget _buildTabMingguan() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF00A79D),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Belakangan ini, suasana hatimu mungkin sedang kurang stabil. Yuk, pelan-pelan kita perbaiki bersama',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Bar Chart Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grafik DASS - 21',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sentuh grafik untuk melihat selengkapnya',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    Icon(Icons.send, color: Colors.black87),
                  ],
                ),
                const SizedBox(height: 20),

                // Bar Chart Buatan Sendiri (Anti-Error)
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      // Sumbu Y (Emoji)
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('😆', style: TextStyle(fontSize: 16)),
                          Text('😁', style: TextStyle(fontSize: 16)),
                          Text('😐', style: TextStyle(fontSize: 16)),
                          Text('😢', style: TextStyle(fontSize: 16)),
                          Text('😫', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 20), // Spasi untuk label X
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Sumbu X (Batang)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildBar(40, 'Ke-1', false),
                            _buildBar(80, 'Ke-2', false),
                            _buildBar(140, 'Ke-3', false),
                            _buildBar(120, 'Ke-4', true), // Highlight
                            _buildBar(30, 'Ke-5', false),
                            _buildBar(140, 'Ke-6', false),
                            _buildBar(100, 'Ke-7', false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Log History
          const Text(
            'Minggu, 1 Maret 2026',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Berikut laporan grafik DASS-21 bulanan kamu!',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Text('😆', style: TextStyle(fontSize: 40)),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minggu Ke-1',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Suasana hatimu berangsur baik',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Bantuan: Badge Emoji + Angka
  Widget _buildEmojiBadge(
    String emoji,
    String label,
    String count,
    Color countColor,
  ) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: countColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: countColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  // Widget Bantuan: Batang Grafik
  Widget _buildBar(double height, String label, bool isHighlighted) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 25,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF00A79D),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.teal.shade50 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                  fontWeight: isHighlighted
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (isHighlighted)
                const Icon(Icons.circle, size: 6, color: Color(0xFF00A79D)),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// KANVAS UNTUK GRAFIK DONAT
// ==========================================
class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 25.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Ujung lurus seperti di desain

    // Konversi nilai menjadi persentase derajat (Total 360)
    // Dummy Data: Kuning(40%), Biru(20%), Pink(25%), Hijau(15%)

    double startAngle = -pi / 2; // Mulai dari arah jam 12

    // Segmen 1: Kuning (Bahagia)
    paint.color = Colors.amber.shade300;
    final sweep1 = 360 * 0.40 * (pi / 180);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep1 - 0.05,
      false,
      paint,
    );

    // Segmen 2: Biru (Sedih)
    startAngle += sweep1;
    paint.color = Colors.lightBlue.shade300;
    final sweep2 = 360 * 0.20 * (pi / 180);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep2 - 0.05,
      false,
      paint,
    );

    // Segmen 3: Pink (Depresi)
    startAngle += sweep2;
    paint.color = Colors.pinkAccent.shade200;
    final sweep3 = 360 * 0.25 * (pi / 180);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep3 - 0.05,
      false,
      paint,
    );

    // Segmen 4: Hijau (Senang)
    startAngle += sweep3;
    paint.color = Colors.lightGreenAccent.shade400;
    final sweep4 = 360 * 0.15 * (pi / 180);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep4 - 0.05,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
