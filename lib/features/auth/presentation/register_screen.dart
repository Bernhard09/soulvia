import 'package:flutter/material.dart';
import 'package:soulvie_app/common/app_colors.dart';
import 'package:soulvie_app/component/header/auth_header.dart';
import 'package:soulvie_app/component/text_field/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 1. Inisialisasi semua controller sesuai permintaan
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  // 2. Jangan lupa dispose SEMUA controller
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

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Memanggil Header yang sudah dipisah
            const AuthHeader(),

            // Card Form Register
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.20,
                  left: 24.0,
                  right: 24.0,
                  bottom: 40.0, // Tambah padding bawah agar nyaman di-scroll
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

                      // Lupa Password Dihapus, langsung beri jarak ke tombol
                      const SizedBox(height: 40),

                      // Tombol Daftar
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Mengambil nilai teks untuk validasi / API
                            String inputFullName = _fullNameController.text;
                            String inputUsername = _usernameController.text;
                            String inputPassword = _passwordController.text;

                            // Contoh validasi sederhana
                            if (inputFullName.isEmpty ||
                                inputUsername.isEmpty ||
                                inputPassword.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Semua field harus diisi!'),
                                ),
                              );
                              return;
                            }
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
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

                      // Teks Pindah ke halaman Login
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
