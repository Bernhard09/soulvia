import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pastikan import path ini sesuai dengan lokasi file provider-mu
import 'package:soulvie_app/features/koleksi_syukur/logic/koleksi_provider.dart';
import 'package:soulvie_app/features/koleksi_syukur/model/gratitude.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GratitudePostcard extends ConsumerStatefulWidget {
  const GratitudePostcard({super.key, required this.post});
  final GratitudePost post; // Sekarang kita passing object model-nya langsung

  @override
  ConsumerState<GratitudePostcard> createState() => _GratitudePostCardState();
}

class _GratitudePostCardState extends ConsumerState<GratitudePostcard> {
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                  image: _avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(_avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _avatarUrl == null
                    ? Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      widget.post.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              // --- POPUP MENU HAPUS & SIMPAN ---
              PopupMenuButton<String>(
                icon: const Icon(Icons.menu, color: Colors.black54),
                onSelected: (value) {
                  if (value == 'hapus') {
                    ref
                        .read(koleksiControllerProvider.notifier)
                        .hapusPostingan(widget.post.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Postingan dihapus')),
                    );
                  } else if (value == 'simpan') {
                    ref
                        .read(koleksiControllerProvider.notifier)
                        .toggleSimpan(widget.post.id);
                    final isNowSaved = !widget.post.isSaved; // Status baru
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isNowSaved
                              ? 'Postingan disimpan ke koleksi'
                              : 'Batal menyimpan postingan',
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'simpan',
                    // Label teks berubah secara dinamis tergantung status
                    child: Text(
                      widget.post.isSaved
                          ? 'Hapus dari Simpanan'
                          : 'Simpan Postingan',
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'hapus',
                    child: Text('Hapus', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            widget.post.content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
