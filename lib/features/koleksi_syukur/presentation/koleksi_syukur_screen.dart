import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:soulvie_app/common/app_colors.dart';
import 'package:soulvie_app/component/syukur/gratitude_postcard.dart';
import 'package:soulvie_app/features/koleksi_syukur/logic/koleksi_provider.dart';
import 'package:soulvie_app/features/koleksi_syukur/presentation/buat_koleksi_syukur.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KoleksiSyukurScreen extends ConsumerStatefulWidget {
  const KoleksiSyukurScreen({super.key});

  @override
  ConsumerState<KoleksiSyukurScreen> createState() =>
      _KoleksiSyukurScreenState();
}

class _KoleksiSyukurScreenState extends ConsumerState<KoleksiSyukurScreen> {
  final _supabase = Supabase.instance.client;
  String? _username = null;
  String? _avatarUrl = null;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        _username = data['full_name'] ?? 'User Soulvia';
        _avatarUrl = data['avatar_url'];
      });
    } catch (e) {
      print("Error ambil data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final semuaPostingan = ref.watch(koleksiControllerProvider);

    // 2. Filter data khusus untuk tab "Disimpan"
    final postinganDisimpan = semuaPostingan
        .where((post) => post.isSaved)
        .toList();

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
                  // Tab 1: Postingan mu (Semua data)
                  semuaPostingan.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada postingan',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          itemCount: semuaPostingan.length,
                          itemBuilder: (context, index) {
                            semuaPostingan[index].name = _username ?? 'user';
                            return GratitudePostcard(
                              post: semuaPostingan[index],
                            );
                          },
                        ),

                  // Tab 2: Disimpan (Data yang di-filter)
                  postinganDisimpan.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada postingan yang disimpan',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          itemCount: postinganDisimpan.length,
                          itemBuilder: (context, index) {
                            return GratitudePostcard(
                              post: postinganDisimpan[index],
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BuatKoleksiScreen()),
            );
          },
          backgroundColor: AppColors.primary,
          child: Icon(Icons.add, color: AppColors.background),
        ),
      ),
    );
  }
}
