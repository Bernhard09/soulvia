import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CharacterCard extends ConsumerWidget {
  const CharacterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.end,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Karakter Aktif (Kiri)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Level 1',
                  style: TextStyle(
                    color: Color(0xFF00A79D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.pentagon, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text(
                      '5',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A79D),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // <--- ASSET PLACEHOLDER: Karakter Level 1 --->
                      child: Image.asset('assets/images/kucing1.png'),
                      // child: const Icon(Icons.pets, size: 50, color: Color(0xFF00A79D)),
                    ),
                  ],
                ),

                // Poin Saat ini (Atas Kanan)
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 70), // Spacer agar sejajar
                  ],
                ),

                // Karakter Terkunci 1
                _buildLockedCharacter('40', 'kucing2.png'),
                // Karakter Terkunci 2
                _buildLockedCharacter('80', 'kucing3.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget bantuan untuk karakter terkunci
  Widget _buildLockedCharacter(String pointReq, String asset) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              // <--- ASSET PLACEHOLDER: Karakter Terkunci --->
              child: Image.asset('assets/images/$asset'),
            ),
            // Ikon Gembok
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.pentagon, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              pointReq,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF00A79D),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
