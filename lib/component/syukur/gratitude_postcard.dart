import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GratitudePostCard extends ConsumerWidget {
  final String name;
  final String date;
  final String content;

  const GratitudePostCard({
    super.key,
    required this.name,
    required this.date,
    required this.content,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0), // Jarak antar postingan
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Header Postingan (Profil, Nama, Tanggal, Menu)
          Row(
            children: [
              // <--- ASSET PLACEHOLDER: Foto Profil Postingan --->
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              
              // Nama dan Tanggal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                    ),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              ),
              
              // Ikon Menu (Tiga Garis)
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black54),
                onPressed: () {
                  // Aksi saat menu diklik (bisa untuk Edit/Hapus nanti)
                },
              )
            ],
          ),
          const SizedBox(height: 12),
          
          // Bagian Teks Konten
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4, // Jarak antar baris agar nyaman dibaca
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}