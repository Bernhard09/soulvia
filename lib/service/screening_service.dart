class ScreeningService {
  
  /// Menerima List<int> berisi 21 jawaban user (skor 0-3).
  /// Mengembalikan Map berisi skor akhir dan interpretasi kategorinya.
  Map<String, dynamic> calculateDass21(List<int> answers) {
    // Validasi agar memastikan data yang masuk tidak kurang dari 21
    if (answers.length != 21) {
      throw Exception('Jumlah jawaban tidak valid. Harus tepat 21 jawaban.');
    }


    int rawDepression = answers[2] + answers[4] + answers[9] + answers[12] + 
                        answers[15] + answers[16] + answers[20];

    // 2. Kategori KECEMASAN (Soal: 2, 4, 7, 9, 15, 19, 20)
    int rawAnxiety = answers[1] + answers[3] + answers[6] + answers[8] + 
                     answers[14] + answers[18] + answers[19];

    // 3. Kategori STRES (Soal: 1, 6, 8, 11, 12, 14, 18)
    int rawStress = answers[0] + answers[5] + answers[7] + answers[10] + 
                    answers[11] + answers[13] + answers[17];

    // --- RUMUS DASS-21: Skor dijumlahkan lalu DIKALI 2 ---
    int finalDepression = rawDepression * 2;
    int finalAnxiety = rawAnxiety * 2;
    int finalStress = rawStress * 2;

    // --- KEMBALIKAN HASIL BERSERTA INTERPRETASINYA ---
    return {
      'depresi': {
        'skor': finalDepression,
        'kategori': _getDepressionCategory(finalDepression),
      },
      'kecemasan': {
        'skor': finalAnxiety,
        'kategori': _getAnxietyCategory(finalAnxiety),
      },
      'stres': {
        'skor': finalStress,
        'kategori': _getStressCategory(finalStress),
      }
    };
  }

  // ===========================================================================
  // FUNGSI HELPER INTERPRETASI SKOR (Berdasarkan Tabel di Gambar)
  // ===========================================================================

  String _getDepressionCategory(int score) {
    if (score <= 9) return 'Normal';
    if (score <= 13) return 'Ringan';
    if (score <= 20) return 'Sedang';
    if (score <= 27) return 'Berat';
    return 'Sangat Berat';
  }

  String _getAnxietyCategory(int score) {
    if (score <= 7) return 'Normal';
    if (score <= 9) return 'Ringan';
    if (score <= 14) return 'Sedang';
    if (score <= 19) return 'Berat';
    return 'Sangat Berat';
  }

  String _getStressCategory(int score) {
    if (score <= 14) return 'Normal';
    if (score <= 18) return 'Ringan';
    if (score <= 25) return 'Sedang';
    if (score <= 33) return 'Berat';
    return 'Sangat Berat';
  }
}