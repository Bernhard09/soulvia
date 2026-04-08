import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulvie_app/component/syukur/gratitude_postcard.dart';

class KoleksiSyukurScreen extends ConsumerWidget {
  const KoleksiSyukurScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Data dummy menyesuaikan dengan desain Figma
    final dummyPosts = [
      {
        'name': 'Pandu Revi Arnan',
        'date': '01 Februari 2026',
        'content':
            'Hari ini aku bersyukur karena masih bisa tersenyum, membayar hutangku dengan lunas, dan bertemu teman SMA ku dulu',
      },
      {
        'name': 'Pandu Revi Arnan',
        'date': '25 Januari 2026',
        'content':
            'Akhirnya bisa pulang ke rumah tanpa macet, beli coffe dengan diskon, dan tidak perlu lembur malam ini',
      },
      {
        'name': 'Pandu Revi Arnan',
        'date': '29 Desember 2025',
        'content': 'Senangnya bisa keterima kerja di perusahaan impianku...',
      },
      {
        'name': 'Pandu Revi Arnan',
        'date': '15 November 2025',
        'content':
            'Hari ini aku makan pizza favoritku\nAku menyelesaikan tugasku dengan baik\nAku bisa berkumpul kembali dengan keluargaku yang telah lama ldr',
      },
    ];

    // Bungkus Scaffold dengan DefaultTabController untuk fitur Tab
    return DefaultTabController(
      length: 2, // Ada 2 tab: Postingan mu & Disimpan
      child: Scaffold(
        backgroundColor: Colors.white, // Background bersih sesuai desain
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CUSTOM HEADER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 50,
                left: 16,
                right: 24,
                bottom: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF00A79D), // Warna Teal Soulvia
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
                    'Koleksi Syukur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // <--- ASSET PLACEHOLDER: Foto Profil Header --->
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.grey.shade300,
                    ),
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // --- JUDUL & SUBJUDUL ---
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buat Koleksi Syukur mu',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ayo bagikan koleksi syukur mu dan kumpulkan poin harian',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // --- TAB BAR ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color:
                    Colors.grey.shade100, // Background abu-abu untuk area tab
                borderRadius: BorderRadius.circular(4),
              ),
              child: const TabBar(
                indicatorColor: Color(
                  0xFF00A79D,
                ), // Garis bawah teal saat aktif
                indicatorWeight: 3,
                labelColor: Colors.black,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: 'Postingan mu'),
                  Tab(text: 'Disimpan'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- ISI TAB (LIST POSTINGAN) ---
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Postingan mu
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    itemCount: dummyPosts.length,
                    itemBuilder: (context, index) {
                      final post = dummyPosts[index];
                      return GratitudePostCard(
                        name: post['name']!,
                        date: post['date']!,
                        content: post['content']!,
                      );
                    },
                  ),

                  // Tab 2: Disimpan (Dummy kosong dulu)
                  const Center(
                    child: Text(
                      'Belum ada postingan yang disimpan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
