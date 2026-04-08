import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:soulvie_app/component/activity_menu/activity_grid.dart';
import 'package:soulvie_app/component/activity_menu/character_card.dart';
import 'package:soulvie_app/component/activity_menu/history_list.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  const Text(
                    'Haii, Pandu', // Nanti bisa diganti dinamis dari database
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
                    ),
                    // <--- ASSET PLACEHOLDER: Foto Profil --->
                    child: const Icon(Icons.person, color: Colors.grey),
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
