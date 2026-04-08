import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/mood_controller.dart';
import '../logic/profile_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    const primaryTeal = Color.fromARGB(255, 0, 159, 156);

    // Mengambil tinggi status bar (poni/kamera HP)
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea DIHAPUS agar background Teal bisa menembus sampai ke jam/baterai di atas
      body: profileAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: primaryTeal)),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (profile) => SingleChildScrollView(
          child: Stack(
            children: [
              // 1. LAYER BELAKANG: Background Teal Melengkung
              Container(
                height: 240 + topPadding, // Tinggi menyesuaikan status bar
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: primaryTeal,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
              ),

              // 2. LAYER DEPAN: Semua Konten (Column)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spasi manual untuk menggantikan SafeArea
                  SizedBox(height: topPadding + 20),

                  // HEADER (Haii, Bryant & Avatar)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Haii, ${profile['full_name']?.split(' ')[0] ?? 'User'}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white24,
                          backgroundImage: AssetImage(
                            'assets/images/avatar_astronot.png',
                          ),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // MOOD CARD (Otomatis menumpuk menyeberangi garis lengkung Teal)
                  _buildMoodCard(context, ref),

                  const SizedBox(
                    height: 24,
                  ), // Jarak yang pas agar tidak dempet
                  // KALENDER / STREAK
                  _buildCalendarRow(primaryTeal),

                  const SizedBox(height: 24),

                  // GRAFIK DASS-21
                  _buildChartSection(),

                  const SizedBox(height: 24),

                  // STATUS CARD (Depresi Normal)
                  _buildStatusCard(primaryTeal),

                  const SizedBox(height: 24),

                  // AKTIVITAS HARIAN (Desain yang Bagus Dikembalikan)
                  _buildDailyActivities(primaryTeal),

                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),


    );
  }

  // --- SUB WIDGETS ---

  Widget _buildMoodCard(context, ref) {
    final moods = [
      {'emoji': '😫', 'label': 'Depresi'},
      {'emoji': '😢', 'label': 'Sedih'},
      {'emoji': '😐', 'label': 'Netral'},
      {'emoji': '🤩', 'label': 'Senang'},
      {'emoji': '😆', 'label': 'Bahagia'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Apa kabarmu hari ini?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: moods.asMap().entries.map((entry) {
              final index = entry.key;
              final mood = entry.value;
              // Score dibuat 1 sampai 5 (1: Depresi, 5: Bahagia)
              final moodScore = index + 1;

              return GestureDetector(
                onTap: () async {
                  // Tampilkan indikator loading kecil di bawah
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Menyimpan mood...'),
                      duration: Duration(milliseconds: 500),
                    ),
                  );

                  // Bungkus dengan try-catch
                  try {
                    // Panggil fungsi provider
                    await ref
                        .read(moodControllerProvider.notifier)
                        .saveMood(moodScore, mood['label']!);

                    // Jika berhasil, muncul SnackBar Hijau
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Mood "${mood['label']}" berhasil dicatat! ✨',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    // Jika GAGAL, muncul SnackBar Merah berisi pesan error aslinya
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal menyimpan: $e'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                  }

                  // // Panggil mesin provider untuk mengirim data
                  // await ref
                  //     .read(moodControllerProvider.notifier)
                  //     .saveMood(moodScore, mood['label']!);

                  // // Berikan feedback sukses ke user
                  // if (context.mounted) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text(
                  //         'Mood "${mood['label']}" berhasil dicatat! ✨',
                  //       ),
                  //       backgroundColor: Colors.green,
                  //     ),
                  //   );
                  // }
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        mood['emoji']!,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mood['label']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarRow(Color primaryTeal) {
    final days = [
      {'day': 'Sen', 'date': '18', 'active': false, 'fire': true},
      {'day': 'Sel', 'date': '19', 'active': true, 'fire': true},
      {'day': 'Rab', 'date': '20', 'active': false, 'fire': false},
      {'day': 'Kam', 'date': '21', 'active': false, 'fire': false},
      {'day': 'Jum', 'date': '22', 'active': false, 'fire': false},
      {'day': 'Sab', 'date': '23', 'active': false, 'fire': false},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: days.map((d) {
          final isActive = d['active'] as bool;
          final hasFire = d['fire'] as bool;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isActive ? primaryTeal : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isActive ? null : Border.all(color: Colors.grey.shade200),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: primaryTeal.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              children: [
                if (hasFire)
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 16,
                  )
                else
                  Icon(Icons.circle, color: primaryTeal, size: 10),
                const SizedBox(height: 8),
                Text(
                  d['day'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.white : Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  d['date'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Text(
            "Grafik DASS-21 Mingguan\n(Siap dipasang fl_chart)",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(Color primaryTeal) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryTeal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Depresi Normal",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              "Buka Aktivitas",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyActivities(Color primaryTeal) {
    final List<Map<String, dynamic>> activities = [
      {
        'title': 'Mood tracker',
        'subtitle': 'Bagaimana perasaanmu hari ini?',
        'icon': Icons.mood,
        'isDone': true,
      },
      {
        'title': 'Meditasi',
        'subtitle': 'Kembalikan mood dengan meditasi',
        'icon': Icons.self_improvement,
        'isDone': false,
      },
      {
        'title': 'Peregangan',
        'subtitle': 'Mulai peregangan hari ini!',
        'icon': Icons.accessibility_new,
        'isDone': false,
      },
      {
        'title': 'Koleksi Syukur',
        'subtitle': 'Tuliskan hal yang kamu syukuri',
        'icon': Icons.auto_awesome,
        'isDone': false,
      },
      {
        'title': 'Mind Sorting',
        'subtitle': 'Rapikan pikiranmu sekarang',
        'icon': Icons.psychology,
        'isDone': false,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ayo Lanjutkan Aktivitas Harianmu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Ayo selesaikan kegiatan mu untuk mendapatkan poin.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Header Bagian Aktivitas
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // PENGGUNAAN LOGIKA "PEMAIN CADANGAN" (ASSET FALLBACK)
                      child: Center(
                        child: Image.asset(
                          'assets/images/ilustrasi_aktivitas.png', // Nama file dari Figma
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                          // Jika error (file tidak ada), Flutter akan menjalankan errorBuilder
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.calendar_today,
                              color: primaryTeal,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Aktivitas Harian",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "05 April 2026",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryTeal.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: primaryTeal,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "1/5",
                            style: TextStyle(
                              color: primaryTeal,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // MENGURANGI GAP: Jarak disusutkan dari 20 jadi 12
                const SizedBox(height: 12),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // MENGHILANGKAN GAP BAWAAN: Set padding jadi nol agar tidak bentrok
                  padding: EdgeInsets.zero,
                  itemCount: activities.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = activities[index];
                    return _buildTaskItem(
                      item['isDone'] ? Icons.check : Icons.close,
                      primaryTeal,
                      item['title'],
                      item['subtitle'],
                      item['isDone'],
                      item['icon'],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Update Helper _buildTaskItem agar menerima icon spesifik
  Widget _buildTaskItem(
    IconData statusIcon,
    Color primaryColor,
    String title,
    String subtitle,
    bool isDone,
    IconData activityIcon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Lingkaran Status (Check/Cross)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDone ? primaryColor : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          // Judul dan Deskripsi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          // Icon representatif di sebelah kanan
          Icon(activityIcon, color: primaryColor.withAlpha(150), size: 24),
        ],
      ),
    );
  }
}
