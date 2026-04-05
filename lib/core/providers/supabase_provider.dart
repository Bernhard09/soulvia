import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_provider.g.dart';

@riverpod
SupabaseClient supabaseClient(ref) {
  // Mengambil instance client yang sudah di-initialize di main.dart
  return Supabase.instance.client;
}