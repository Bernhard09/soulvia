import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:soulvie_app/component/activity_menu/activity_grid.dart';
import 'package:soulvie_app/component/activity_menu/character_card.dart';
import 'package:soulvie_app/component/activity_menu/history_list.dart';
import 'package:soulvie_app/service/lifecycle_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
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
        _username = data['full_name'].split(' ')[0] ?? 'User Soulvia';
        _avatarUrl = data['avatar_url'];
      });
    } catch (e) {
      print("Error ambil data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = ref.watch(lifeCycleServiceProvider);

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F5F5,
      ), // Warna background abu-abu terang
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CUSTOM CURVED HEADER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 30,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF00A79D), // Warna Teal Soulvia
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Haii, ${_username ?? 'user'}', // Nanti bisa diganti dinamis dari database
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.grey.shade300,
                      image: _avatarUrl != null
                          ? DecorationImage(
                              image: NetworkImage(_avatarUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    // <--- ASSET PLACEHOLDER: Foto Profil --->
                    child: _avatarUrl == null
                        ? Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                ],
              ),
            ),

            // --- KONTEN BAWAH ---
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CharacterCard(),
                  SizedBox(height: 24),

                  Text(
                    'Aktivitas Harian',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Selesaikan Aktivitas dan Kumpulkan Poin',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  SizedBox(height: 12),
                  ActivityGrid(),
                  SizedBox(height: 24),

                  Text(
                    'Riwayat Aktivitas Anda',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Ayo lanjutkan dan dapatkan poin untuk update pet lucu',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  SizedBox(height: 12),
                  HistoryList(),
                  SizedBox(height: 40), // Spasi bawah ekstra
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
