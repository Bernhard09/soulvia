import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soulvie_app/features/auth/presentation/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  String _username = " "; // Default sementara
  String? _avatarUrl; // Akan berisi URL dari Supabase

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // --- 1. FUNGSI AMBIL DATA PROFIL ---
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

  // --- 2. FUNGSI UPLOAD FOTO ---
  Future<void> _uploadFoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // User batal memilih

    setState(() => _isLoading = true);

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Belum login");

      final file = File(image.path);
      final fileExt = image.path.split('.').last;
      final fileName =
          '${user.id}-${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      // 1. Upload ke bucket 'avatars'
      await _supabase.storage.from('avatars').upload(fileName, file);

      // 2. Dapatkan Public URL
      final imageUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);

      // 3. Update tabel profiles
      await _supabase
          .from('profiles')
          .update({'avatar_url': imageUrl})
          .eq('id', user.id);

      // 4. Update UI
      setState(() => _avatarUrl = imageUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diperbarui!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal upload: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- 3. FUNGSI EDIT NAMA (POPUP) ---
  void _tampilkanDialogEdit() {
    final TextEditingController nameController = TextEditingController(
      text: _username,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profil'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nama Lengkap'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A79D),
              ),
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  // Update ke Supabase
                  final user = _supabase.auth.currentUser;
                  if (user != null) {
                    await _supabase
                        .from('profiles')
                        .update({'username': newName})
                        .eq('id', user.id);
                  }
                  setState(() => _username = newName); // Update UI
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- 4. FUNGSI LOGOUT ---
  Future<void> _logout() async {
    await _supabase.auth.signOut();
    // Tambahkan navigasi kembali ke halaman Login di sini (Sufyaan pasti sudah buat route-nya)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==========================================
            // BAGIAN HEADER & AVATAR
            // ==========================================
            SizedBox(
              height: 320,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Background Teal Lengkung
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00A79D),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          // App Bar Area
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              children: [
                                // IconButton(
                                //   icon: const Icon(
                                //     Icons.arrow_back,
                                //     color: Colors.white,
                                //   ),
                                //   onPressed: () => Navigator.pop(context),
                                // ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Profil',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Avatar & Kamera
                  Positioned(
                    top: 130,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            // Lingkaran Foto
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                image: _avatarUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(_avatarUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null, // Jika null, tampilkan child (Icon)
                              ),
                              child: _avatarUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),

                            // Loading Indikator ATAU Tombol Kamera
                            if (_isLoading)
                              const Positioned(
                                right: 10,
                                bottom: 10,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF00A79D),
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: _uploadFoto, // Panggil fungsi upload
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF00A79D),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Color(0xFF00A79D),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Nama User
                        Text(
                          _username,
                          style: const TextStyle(
                            color: Colors
                                .black87, // Di desain terlihat nama ada di area putih/bawah lengkungan
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // MENU PENGATURAN
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Akun dan Pengaturan',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Menu Edit Data
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.person_outline,
                      color: Colors.black54,
                    ),
                    title: const Text(
                      'Edit Data',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black54,
                    ),
                    onTap: _tampilkanDialogEdit, // Panggil popup edit
                  ),
                  const Divider(color: Colors.black12),

                  // Menu Ganti Password
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.vpn_key_outlined,
                      color: Colors.black54,
                    ),
                    title: const Text(
                      'Ganti Password',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black54,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Ganti Password segera hadir!'),
                        ),
                      );
                    },
                  ),
                  const Divider(color: Colors.black12),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ==========================================
            // TOMBOL KELUAR
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A79D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.meeting_room_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Keluar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _logout, // Panggil fungsi logout
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
