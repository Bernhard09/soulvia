import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soulvie_app/features/koleksi_syukur/presentation/koleksi_syukur_screen.dart';
import 'package:soulvie_app/features/meditation/presentation/meditation_screen.dart';
import 'package:soulvie_app/features/mindsorting/presentation/mindsorting_screen.dart';

class ActivityGrid extends ConsumerWidget {
  const ActivityGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>> activities = [
      {
        'id': 'meditasi',
        'title': 'Meditasi',
        'color': Colors.blue.shade100,
        'image': 'meditation.jpg',
        'screen': MeditasiScreen(),
      },
      {
        'id': 'moving',
        'title': 'moving detection',
        'color': Colors.green.shade100,
        'image': 'moving_detection.jpg',
        'screen': Placeholder(),
      },
      {
        'id': 'koleksi',
        'title': 'Koleksi Syukur',
        'color': Colors.cyan.shade100,
        'image': 'koleksi_syukur.jpg',
        'screen': KoleksiSyukurScreen(),
      },
      {
        'id': 'sorting',
        'title': 'Mind Sorting',
        'color': Colors.orange.shade100,
        'image': 'mind_sorting.jpg',
        'screen': MindSortingScreen(),
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3, // Menyesuaikan proporsi kotak Figma
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: activities.map((activity) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior:
              Clip.antiAlias, // Penting agar lengkungan bawah tidak tembus
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => activity['screen'] as Widget),
              );
            },
            child: Column(
              children: [
                // Bagian atas (Gambar Ilustrasi)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color:
                        activity['color']
                            as Color, // Warna placeholder background
                    // <--- ASSET PLACEHOLDER: Gambar Ilustrasi (Meditasi dll) --->
                    child: Image.asset(
                      'assets/images/${activity['image']}',
                      fit: BoxFit.fill,
                    ),
                    // child: const Icon(
                    //   Icons.image,
                    //   size: 40,
                    //   color: Colors.black26,
                    // ),
                  ),
                ),
                // Bagian bawah (Pita Teal / Banner Teks)
                Container(
                  width: double.infinity,
                  color: const Color(0xFF00A79D),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    activity['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
