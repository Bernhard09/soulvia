import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soulvie_app/core/providers/supabase_provider.dart';

part 'profile_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> userProfile(ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final user = supabase.auth.currentUser;

  if (user == null) throw Exception('User tidak ditemukan');

  final data = await supabase
      .from('profiles')
      .select()
      .eq('id', user.id)
      .single();
      
  return data;
}