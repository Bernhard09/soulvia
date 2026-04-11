import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulvie_app/service/lifecycle_service.dart';

import 'dart:io'; // Untuk membaca file lokal
import 'package:image_picker/image_picker.dart'; // Package yang baru diinstall
import 'package:supabase_flutter/supabase_flutter.dart';
import '../logic/koleksi_provider.dart';

class BuatKoleksiScreen extends ConsumerStatefulWidget {
  const BuatKoleksiScreen({super.key});

  @override
  ConsumerState<BuatKoleksiScreen> createState() => _BuatKoleksiScreenState();
}

class _BuatKoleksiScreenState extends ConsumerState<BuatKoleksiScreen> {
  final TextEditingController _contentController = TextEditingController();
  final List<String> _selectedImages =
      []; // List untuk menampung gambar sementara
  final ImagePicker _picker = ImagePicker();

  final _supabase = Supabase.instance.client;
  String? _username = null;
  String? _avatarUrl = null;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  // Fungsi asli untuk mengambil gambar dari Galeri Lokal
  Future<void> _pickLocalImage() async {
    try {
      // Membuka galeri bawaan HP
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          // Menyimpan 'path' (alamat file) lokal ke dalam list
          _selectedImages.add(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membuka galeri: $e')));
    }
  }

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

  // Fungsi Dummy untuk pura-pura upload gambar (MVP Mode)
  void _pickDummyImage() {
    setState(() {
      // Menambahkan URL gambar dummy setiap kali tombol galeri ditekan
      _selectedImages.add(
        'https://picsum.photos/seed/${DateTime.now().second}/200/200',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.only(
            top: 40,
            left: 16,
            right: 24,
            bottom: 20,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF00A79D),
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
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- INFO PROFIL & PRIVASI ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
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
                            ? Icon(Icons.person, size: 30, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _username?? 'user',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            '09 April 2026',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Dropdown Privasi
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: 12,
                                  color: Colors.black54,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Postinganmu',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- INPUT TEKS ---
                  TextField(
                    controller: _contentController,
                    maxLines: null, // Agar bisa enter berkali-kali
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Apa yang kamu syukuri hari ini?',
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- PREVIEW GAMBAR (Hanya muncul jika ada gambar) ---
                  if (_selectedImages.isNotEmpty)
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                  File(_selectedImages[index]),
                                ), // Pakai NetworkImage untuk dummy URL
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),

          // --- TOOLBAR BAWAH ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: _pickLocalImage,
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A79D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Cek jika kosong
                    if (_contentController.text.trim().isEmpty &&
                        _selectedImages.isEmpty) {
                      return;
                    }

                    // 1. Panggil Provider untuk menyimpan data
                    ref
                        .read(koleksiControllerProvider.notifier)
                        .tambahPostingan(
                          _contentController.text,
                          _selectedImages,
                        );

                    ref
                        .read(lifeCycleServiceProvider.notifier)
                        .updateActivity('koleksi_syukur');

                    ref.read(lifeCycleServiceProvider.notifier).addPoint();

                    // 2. Tampilkan pesan sukses dan kembali ke halaman sebelumnya
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Postingan berhasil dibagikan!'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Bagikan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
