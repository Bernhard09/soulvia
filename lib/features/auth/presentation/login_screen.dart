import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. IMPORT RIVERPOD
import 'package:soulvie_app/common/app_colors.dart';
import 'package:soulvie_app/component/header/auth_header.dart';
import 'package:soulvie_app/component/text_field/auth_text_field.dart';
import 'package:soulvie_app/features/auth/logic/auth_controller.dart';
import 'package:soulvie_app/features/auth/presentation/register_screen.dart';
import 'package:soulvie_app/features/auth/screening/presentation/welcome_screening_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

// 4. UBAH MENJADI ConsumerState
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // 5. MENDENGARKAN STATE (Untuk Error dan Navigasi Sukses)
    // ref.listen akan memantau perubahan pada AuthController tanpa me-rebuild seluruh UI
    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        // Jika terjadi error saat login (misal salah password)
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error.toString().replaceAll('Exception: ', ''),
              ), // Membersihkan tulisan Exception
              backgroundColor: Colors.red,
            ),
          );
        },
        // Jika fungsi selesai tanpa error (Login Berhasil)
        data: (_) {
          // Kita cek apakah state sebelumnya adalah loading, untuk memastikan ini adalah hasil dari tombol yang baru saja ditekan
          if (previous != null && previous.isLoading) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const KuesionerWelcomeScreen(),
              ),
            );
          }
        },
      );
    });

    // 6. MEMANTAU STATUS LOADING
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const AuthHeader(),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.20,
                  left: 24.0,
                  right: 24.0,
                  bottom: 24.0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AuthTextField(
                        label:
                            'Username / Email / No. HP', // Diperbarui sesuai logika repository temanmu
                        hintText: 'Masukkan identitasmu',
                        controller: _usernameController,
                      ),
                      const SizedBox(height: 24),

                      AuthTextField(
                        label: 'Password',
                        hintText: '***************',
                        isPassword: !_isPasswordVisible,
                        controller: _passwordController,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          // 7. DISABLE TOMBOL SAAT LOADING
                          onPressed: isLoading
                              ? null
                              : () {
                                  String inputUsername =
                                      _usernameController.text;
                                  String inputPassword =
                                      _passwordController.text;

                                  if (inputUsername.isEmpty ||
                                      inputPassword.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Identitas dan Password tidak boleh kosong!',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  // 8. PANGGIL FUNGSI LOGIN DARI CONTROLLER
                                  ref
                                      .read(authControllerProvider.notifier)
                                      .login(inputUsername, inputPassword);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 0,
                          ),
                          // 9. UBAH TEKS MENJADI INDIKATOR LOADING JIKA SEDANG PROSES
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Belum mempunyai akun? ',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
