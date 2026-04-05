import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/profile_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F9), // Background soft
      body: SafeArea(
        child: profileAsync.when(
          data: (profile) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Nama & Avatar)
                _buildHeader(profile['full_name'] ?? 'User'),
                const SizedBox(height: 30),

                // 2. Mood Tracker Card
                _buildMoodCard(),
                const SizedBox(height: 30),

                // 3. Grafik Perkembangan (Placeholder)
                const Text("Perkembanganmu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _buildChartPlaceholder(),
                const SizedBox(height: 30),

                // 4. Aktivitas Harian
                const Text("Aktivitas Harianmu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _buildActivityList(),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Haii, $name", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Bagaimana perasaanmu?", style: TextStyle(color: Colors.grey)),
          ],
        ),
        const CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xFF009688),
          child: Icon(Icons.person, color: Colors.white),
        )
      ],
    );
  }

  Widget _buildMoodCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text("Apa kabarmu hari ini?", style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['😫', '😔', '😐', '😊', '🤩'].map((e) => 
              Text(e, style: const TextStyle(fontSize: 30))).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: Text("Grafik DASS-21 muncul di sini")),
    );
  }

  Widget _buildActivityList() {
    final activities = [
      {'title': 'Mood Tracker', 'icon': Icons.mood, 'done': true},
      {'title': 'Guided Meditation', 'icon': Icons.self_improvement, 'done': false},
      {'title': 'Daily Journal', 'icon': Icons.book, 'done': false},
    ];

    return Column(
      children: activities.map((act) => ListTile(
        leading: Icon(act['icon'] as IconData, color: const Color(0xFF009688)),
        title: Text(act['title'] as String),
        trailing: Icon(
          (act['done'] as bool) ? Icons.check_circle : Icons.circle_outlined,
          color: (act['done'] as bool) ? Colors.green : Colors.grey,
        ),
      )).toList(),
    );
  }
}