import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryList extends ConsumerWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = [
      {
        'week': 'Minggu Ke-3',
        'mainActivity': 'Meditasi',
        'details': ['Meditasi Pagi (10:00)', 'Mood Tracker (10:05)']
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final entry = history[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ExpansionTile( 
            // Bagian Kiri (Ikon Persegi Rounded)
            leading: Container(
              width: 50, height: 50,
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
              // <--- ASSET PLACEHOLDER: Ikon Riwayat --->
              child: const Icon(Icons.self_improvement, color: Color(0xFF00A79D)),
            ),
            title: Text(entry['week'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text(entry['mainActivity'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            shape: const Border(),
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            childrenPadding: const EdgeInsets.only(left: 80, right: 16, bottom: 16),
            // Isi Dropdown
            children: (entry['details'] as List).map((detail) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: Color(0xFF00A79D)), 
                    const SizedBox(width: 8),
                    Text(detail as String, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}