import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final SupabaseClient _supabase;
  AuthRepository(this._supabase);

  // Fungsi Daftar
  Future<void> signUp(String email, String password, String username) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  // Fungsi Login
  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  // Cek Session
  Session? get currentSession => _supabase.auth.currentSession;
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(Supabase.instance.client);
}
