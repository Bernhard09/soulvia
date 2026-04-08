import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. IMPORT RIVERPOD
import 'package:soulvie_app/common/app_colors.dart';
import 'package:soulvie_app/component/header/auth_header.dart';
import 'package:soulvie_app/component/text_field/auth_text_field.dart';
import 'package:soulvie_app/features/auth/logic/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // 4. LENGKAPI SEMUA CONTROLLER (Sesuai kebutuhan AuthController)
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        },
        data: (_) {
          if (previous != null && previous.isLoading) {
            // Jika sukses mendaftar, tampilkan pesan dan kembali ke halaman Login
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pendaftaran berhasil! Silakan masuk.'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context); // Kembali ke LoginScreen
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
                  bottom: 40.0,
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
                      // --- Kumpulan Text Field ---
                      AuthTextField(
                        label: 'Nama Lengkap',
                        hintText: 'Masukkan nama lengkap',
                        controller: _fullNameController,
                      ),
                      const SizedBox(height: 20),

                      AuthTextField(
                        label: 'Username',
                        hintText: 'pandu123',
                        controller: _usernameController,
                      ),
                      const SizedBox(height: 20),

                      // FIELD BARU: Email
                      AuthTextField(
                        label: 'Email',
                        hintText: 'contoh@email.com',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),

                      // FIELD BARU: No. HP
                      AuthTextField(
                        label: 'Nomor HP',
                        hintText: '081234567890',
                        controller: _phoneController,
                      ),
                      const SizedBox(height: 20),

                      AuthTextField(
                        label: 'Email',
                        hintText: 'pandu@email.com',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),
          
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

                      const SizedBox(height: 40),

                      // Tombol Daftar
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          // 7. DISABLE TOMBOL SAAT LOADING
                          onPressed: isLoading
                              ? null
                              : () {
                                  String fullName = _fullNameController.text.trim();
                                  String username = _usernameController.text.trim();
                                  String email = _emailController.text.trim();
                                  String phone = _phoneController.text.trim();
                                  String password = _passwordController.text;

                                  // Validasi sederhana (Pastikan tidak ada yang kosong)
                                  if (fullName.isEmpty ||
                                      username.isEmpty ||
                                      email.isEmpty ||
                                      phone.isEmpty ||
                                      password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Semua field harus diisi!'),
                                      ),
                                    );
                                    return;
                                  }

                                  // 8. PANGGIL FUNGSI REGISTER DARI CONTROLLER
                                  ref.read(authControllerProvider.notifier).register(
                                        email: email,
                                        password: password,
                                        username: username,
                                        fullName: fullName,
                                        phone: phone,
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 0,
                          ),
                          // 9. INDIKATOR LOADING
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
                                  'Daftar',
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
                            'Sudah mempunyai akun? ',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Masuk',
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