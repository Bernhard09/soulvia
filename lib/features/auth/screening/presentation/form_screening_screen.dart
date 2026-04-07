import 'package:flutter/material.dart';
import 'package:soulvie_app/common/app_colors.dart';
import 'package:soulvie_app/features/auth/screening/presentation/result_screening_screen.dart';
import 'package:soulvie_app/service/screening_service.dart';

// 1. Model Data untuk Kuesioner
class Kuesioner {
  final String question;
  int? selectedScore; // Menyimpan skor (0-3), null jika belum dijawab

  Kuesioner({required this.question, this.selectedScore});
}

class ScreeningScreen extends StatefulWidget {
  const ScreeningScreen({super.key});

  @override
  State<ScreeningScreen> createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends State<ScreeningScreen> {
  // 2. State untuk melacak nomor halaman saat ini (dimulai dari 0)
  int _currentIndex = 0;

  // 3. Data 21 Pertanyaan DASS-21 (Saya isi 5 pertama sebagai contoh, silakan lengkapi)
  final List<Kuesioner> _kuesionerList = [
    Kuesioner(question: "Saya merasa sulit untuk rileks"),
    Kuesioner(question: "Saya merasakan mulut saya kering"),
    Kuesioner(question: "Saya tidak bisa berfikir positif"),
    Kuesioner(question: "Saya sering merasa kesulitan bernapas"),
    Kuesioner(
      question:
          "Saya merasa kesulitan untuk memiliki inisiatif melakukan suatu hal",
    ),
    Kuesioner(
      question:
          "Saya sering kali bersikap berlebihan dalam menanggapi suatu hal",
    ),
    Kuesioner(question: "Saya sering merasakan tremor/ gemetar di tubuh"),
    Kuesioner(
      question: "Saya merasa sering kehabisan tenaga akibat perasaan cemas",
    ),
    Kuesioner(
      question:
          "Saya sering merasa khawatir berada pada situasi yang dapat membuat saya merasa panik dan bersikap konyol",
    ),
    Kuesioner(question: "Saya merasa tidak memiliki sesuatu untuk dikerjakan"),
    Kuesioner(question: "Saya sering merasa cemas/ khawatir"),
    Kuesioner(question: "Saya sering kesulitan untuk bersantai"),
    Kuesioner(question: "Saya sering merasa galau"),
    Kuesioner(
      question:
          "Saya tidak pernah menoleransi semua hal yang mengganggu sesuatu yang saya kerjakan",
    ),
    Kuesioner(question: "Saya merasa sering panik"),
    Kuesioner(question: "Saya tidak merasa antusias dalam segala hal"),
    Kuesioner(question: "Saya merasa tidak berguna sebagai manusia"),
    Kuesioner(question: "Saya cenderung sensitive"),
    Kuesioner(
      question: "Saya sering dapat merasakan ketika jantung berdetak kencang",
    ),
    Kuesioner(question: "Saya sering merasa takut tanpa alasan"),
    Kuesioner(question: "Saya merasa hidup saya tidak berharga"),
  ];

  // Controller untuk scroll indikator angka di atas agar otomatis geser
  final ScrollController _scrollController = ScrollController();

  void _nextQuestion() {
    if (_currentIndex < _kuesionerList.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _scrollToCurrentIndex();
    }
  }

  void _prevQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _scrollToCurrentIndex();
    }
  }

  void _scrollToCurrentIndex() {
    // Otomatis menggeser indikator angka di atas
    _scrollController.animateTo(
      _currentIndex * 45.0, // Estimasi lebar 1 item indikator
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool get _isAllAnswered {
    return _kuesionerList.every((kuesioner) => kuesioner.selectedScore != null);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Jarak atas (bisa ditambahkan Header/Appbar jika perlu)
            const SizedBox(height: 20),

            // Bagian Putih (Form)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Garis Drag (Dekorasi)
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- Indikator Angka Horizontal ---
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _kuesionerList.length,
                        itemBuilder: (context, index) {
                          bool isActive = index == _currentIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            child: Container(
                              width: 40,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary
                                    : const Color(0xFFE0E0E0),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Garis Pemisah
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12,
                      ),
                      child: Divider(color: Colors.grey, thickness: 0.5),
                    ),

                    // --- Teks Pertanyaan ---
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              _kuesionerList[_currentIndex].question,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            // --- Opsi Jawaban ---
                            _buildOptionButton("Hampir Selalu", 3),
                            const SizedBox(height: 16),
                            _buildOptionButton("Sering", 2),
                            const SizedBox(height: 16),
                            _buildOptionButton("Kadang-kadang", 1),
                            const SizedBox(height: 16),
                            _buildOptionButton("Tidak Pernah", 0),
                          ],
                        ),
                      ),
                    ),

                    // --- Navigasi Bawah ---
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Tombol Prev (Kiri)
                          InkWell(
                            onTap: _currentIndex > 0 ? _prevQuestion : null,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _currentIndex > 0
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),

                          // Tombol Selesaikan (Tengah)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: ElevatedButton(
                                // Jika _isAllAnswered bernilai true, tombol bisa dipencet.
                                // Jika false, diisi null (otomatis membuat tombol disabled/mati)
                                onPressed: _isAllAnswered
                                    ? () {
                                        // 1. Ambil semua skor dari model kuesioner
                                        List<int> userAnswers = _kuesionerList
                                            .map((q) => q.selectedScore!)
                                            .toList();

                                        // 2. Panggil ScreeningService untuk menghitung
                                        final service = ScreeningService();
                                        Map<String, dynamic> results = service
                                            .calculateDass21(userAnswers);

                                        // 3. Navigasi ke ResultScreen sambil membawa data hasil
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ResultScreen(
                                              // Kita ambil salah satu kategori untuk ditampilkan sebagai judul utama,
                                              // misalnya kategori Depresi (sesuai desain UI kamu)
                                              testResult:
                                                  "Depresi ${results['depresi']['kategori']}",
                                              // Kamu juga bisa mengirimkan seluruh map results jika halaman hasil
                                              // ingin menampilkan detail Kecemasan dan Stres juga.
                                            ),
                                          ),
                                        );
                                      }
                                    : null, // <-- Ini kunci untuk mematikan tombol
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  // Warna saat tombol aktif
                                  backgroundColor: AppColors.primary,
                                  // Warna saat tombol mati (belum selesai dijawab semua)
                                  disabledBackgroundColor: Colors.grey.shade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Selesaikan',
                                  style: TextStyle(
                                    // Teks putih jika aktif, abu-abu gelap jika mati
                                    color: _isAllAnswered
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Tombol Next (Kanan)
                          InkWell(
                            onTap: _currentIndex < _kuesionerList.length - 1
                                ? _nextQuestion
                                : null,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _currentIndex < _kuesionerList.length - 1
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Helper untuk Tombol Opsi ---
  Widget _buildOptionButton(String text, int scoreValue) {
    // Cek apakah opsi ini adalah opsi yang sedang dipilih user
    bool isSelected = _kuesionerList[_currentIndex].selectedScore == scoreValue;

    return InkWell(
      onTap: () {
        setState(() {
          // Simpan jawaban user ke dalam list
          _kuesionerList[_currentIndex].selectedScore = scoreValue;
        });

        // Opsional: Otomatis lanjut ke soal berikutnya setelah menjawab (hilangkan komentar di bawah jika mau)
        // Future.delayed(const Duration(milliseconds: 300), () {
        //   _nextQuestion();
        // });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          // Jika dipilih warnanya teal, jika tidak warnanya abu-abu terang
          color: isSelected ? AppColors.primary : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              // Jika dipilih teksnya putih, jika tidak teksnya teal
              color: isSelected ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
