import 'package:riverpod_annotation/riverpod_annotation.dart';
// Sesuaikan import ini dengan lokasi file supabase_provider milikmu
import '../../../core/providers/supabase_provider.dart';

part 'mood_controller.g.dart';

@riverpod
class MoodController extends _$MoodController {
  @override
  FutureOr<void> build() {
    // State awal, tidak melakukan apa-apa saat pertama kali di-load
  }

  // Fungsi murni untuk mengirim data ke Supabase tanpa mengubah state Riverpod
  Future<void> saveMood(int moodScore, String moodLabel) async {
    final supabase = ref.read(supabaseClientProvider);
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    // Pastikan baris 'note' SUDAH DIHAPUS jika kamu belum membuat kolomnya di Supabase
    await supabase.from('daily_moods').upsert({
      'user_id': user.id,
      'mood_score': moodScore,
    });
  }
}
