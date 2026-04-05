import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soulvie_app/core/providers/supabase_provider.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final SupabaseClient _supabase;
  AuthRepository(this._supabase);

  // Fungsi Daftar
  // Future<void> signUp(String email, String password, String username) async {
  //   await _supabase.auth.signUp(
  //     email: email,
  //     password: password,
  //     data: {'username': username},
  //   );
  // }

  // LOGIKA REGISTER
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
    required String phone,
  }) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'username': username,
        'full_name': fullName,
        'phone_number': phone,
      },
    );
  }

  // LOGIKA LOGIN MULTI-IDENTIFIER
  Future<void> signIn(String identifier, String password) async {
    String? targetEmail;

    // 1. Cek apakah identifier adalah Email (ada tanda @)
    if (identifier.contains('@')) {
      targetEmail = identifier;
    } else {
      // 2. Jika bukan email, cari di tabel profiles berdasarkan username ATAU phone
      final response = await _supabase
          .from('profiles')
          .select('email')
          .or('username.eq.$identifier,phone_number.eq.$identifier')
          .maybeSingle();

      if (response != null) {
        targetEmail = response['email'];
      }
    }

    if (targetEmail == null) {
      throw Exception('Identitas tidak ditemukan');
    }

    // 3. Login menggunakan email yang ditemukan
    await _supabase.auth.signInWithPassword(
      email: targetEmail,
      password: password,
    );
  }
  // // Fungsi Login
  // Future<void> signIn(String email, String password) async {
  //   await _supabase.auth.signInWithPassword(email: email, password: password);
  // }

  // Cek Session
  Session? get currentSession => _supabase.auth.currentSession;
}

@riverpod
AuthRepository authRepository(Ref ref) {
  // ambil
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(client);
}
