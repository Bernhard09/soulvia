import 'package:flutter/material.dart';
import 'package:soulvie_app/features/mindsorting/data/model/mind_card_model.dart';

// --- DATA MODEL UNTUK KARTU ---

class MindSortingScreen extends StatefulWidget {
  const MindSortingScreen({Key? key}) : super(key: key);

  @override
  State<MindSortingScreen> createState() => _MindSortingScreenState();
}

class _MindSortingScreenState extends State<MindSortingScreen> {
  // 1. STATE GAME
  int _score = 0;
  int _lives = 3;

  // Daftar kartu yang akan dimainkan
  // Kartu paling atas di UI adalah index 0 di List ini
  final List<MindCardModel> _cards = [
    MindCardModel(
      text: "GAADA YANG\nSUKA KAMU\nKAMU ANEH",
      bgColor: const Color(0xFF3B8C1D), // Hijau Gelap
      imagePath: 'assets/images/glove-mindsorting.png',
      correctAction: 'buang', // Ini pikiran negatif, harus dibuang
    ),
    MindCardModel(
      text: "KAMU ITU KEREN\nJADI JANGAN\nMENYERAH !!!",
      bgColor: const Color(0xFF8B0000), // Merah Gelap
      iconData: Icons.wb_sunny, // Pakai icon bawaan sementara
      correctAction: 'simpan', // Ini pikiran positif, harus disimpan
    ),
    // Kamu bisa tambahkan kartu lainnya di sini...
  ];

  // 2. FUNGSI LOGIKA GAME
  void _onCardDropped(MindCardModel card, String action) {
    if (card.correctAction == action) {
      // JAWABAN BENAR
      setState(() {
        _score += 1;
        _cards.removeAt(0); // Hapus kartu teratas
      });
      _showDialog(
        'Berhasil!',
        'Selamat kamu berhasil memilah pikiran ini!',
        isSuccess: true,
      );
    } else {
      // JAWABAN SALAH
      setState(() {
        if (_lives > 0) _lives -= 1;
        _cards.removeAt(0); // Tetap hapus kartunya agar game lanjut
      });

      if (_lives == 0) {
        _showDialog(
          'Game Over',
          'Kesempatan kamu sudah habis. Coba lagi ya!',
          isSuccess: false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Oops! Pilihan yang salah. Kesempatan berkurang.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  // Fungsi memunculkan Pop-up Dialog
  void _showDialog(String title, String content, {required bool isSuccess}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: TextStyle(color: isSuccess ? Colors.green : Colors.red),
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                if (_lives == 0 || _cards.isEmpty) {
                  Navigator.pop(
                    context,
                  ); // Keluar dari screen jika game over / selesai
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background gradient biru/ungu
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8BA3FD), Color(0xFF9AA2FD)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 3. APP BAR CUSTOM
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Mind Sorting',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.ios_share, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // 4. HEADER SKOR & KESEMPATAN (NYAWA)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A98B9), // Warna tosca/biru
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SKOR : $_score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'KESEMPATAN : ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Generate icon hati (💖 jika sisa, 🤍 jika habis)
                        ...List.generate(3, (index) {
                          return Icon(
                            index < _lives
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: index < _lives
                                ? Colors.pinkAccent
                                : Colors.grey.shade300,
                            size: 18,
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 5. AREA TUMPUKAN KARTU (STACK)
              SizedBox(
                height: 350,
                width: double.infinity,
                child: _cards.isEmpty
                    ? const Center(
                        child: Text(
                          "Semua pikiran telah dipilah!",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          // Render kartu dari belakang ke depan
                          // Kita hanya me-render 2 kartu teratas untuk performa
                          if (_cards.length > 1)
                            Transform.rotate(
                              angle: 0.1, // Kartu bawah sedikit miring ke kanan
                              child: _buildCardUI(_cards[1]),
                            ),

                          // Kartu Teratas (Bisa di-drag)
                          Transform.rotate(
                            angle: -0.05, // Kartu atas sedikit miring ke kiri
                            child: Draggable<MindCardModel>(
                              data: _cards[0], // Data yang dibawa saat di-drag
                              feedback: Material(
                                color: Colors.transparent,
                                child: Transform.scale(
                                  scale: 1.05, // Sedikit membesar saat dipegang
                                  child: _buildCardUI(_cards[0]),
                                ),
                              ),
                              childWhenDragging:
                                  Container(), // Kosong saat kartu sedang ditarik
                              child: _buildCardUI(_cards[0]),
                            ),
                          ),
                        ],
                      ),
              ),

              const Spacer(),

              // 6. AREA DRAG TARGET (BUANG & SIMPAN)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TARGET BUANG (KIRI - MERAH)
                    DragTarget<MindCardModel>(
                      onAccept: (card) => _onCardDropped(card, 'buang'),
                      builder: (context, candidateData, rejectedData) {
                        return _buildTargetButton(
                          title: 'BUANG',
                          icon: Icons.delete_outline,
                          color: const Color(0xFF8B0000), // Merah Gelap
                          isHovered: candidateData
                              .isNotEmpty, // Berubah ukuran saat kartu di atasnya
                        );
                      },
                    ),

                    // TARGET SIMPAN (KANAN - HIJAU)
                    DragTarget<MindCardModel>(
                      onAccept: (card) => _onCardDropped(card, 'simpan'),
                      builder: (context, candidateData, rejectedData) {
                        return _buildTargetButton(
                          title: 'SIMPAN',
                          icon: Icons.verified_user_outlined,
                          color: const Color(0xFF3B8C1D), // Hijau Gelap
                          isHovered: candidateData.isNotEmpty,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BANTUAN UNTUK DESAIN KARTU ---
  Widget _buildCardUI(MindCardModel card) {
    return Container(
      width: 220,
      height: 320,
      decoration: BoxDecoration(
        color: card.bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 4), // Border putih tebal
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (card.imagePath != null)
            Image.asset(card.imagePath!, height: 100)
          else if (card.iconData != null)
            Icon(card.iconData, size: 100, color: Colors.amber),
          const SizedBox(height: 30),
          Text(
            card.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BANTUAN UNTUK TOMBOL TARGET ---
  Widget _buildTargetButton({
    required String title,
    required IconData icon,
    required Color color,
    required bool isHovered,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isHovered ? 130 : 120, // Membesar kalau kartu ada di atasnya
      height: isHovered ? 130 : 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHovered ? Colors.white : Colors.transparent,
          width: 3,
        ),
        boxShadow: [
          if (isHovered) const BoxShadow(color: Colors.white54, blurRadius: 15),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 50),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
