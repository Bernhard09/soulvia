import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/auth_controller.dart';
import 'login_screen.dart'; // Import untuk navigasi balik

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // 1. Controller untuk setiap input
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Akun Soulvia')),
      body: SingleChildScrollView(
        // Agar tidak error saat keyboard muncul
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Input Fields
            _buildTextField(_fullNameController, 'Nama Lengkap', Icons.person),
            const SizedBox(height: 12),
            _buildTextField(
              _usernameController,
              'Username',
              Icons.alternate_email,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _emailController,
              'Email',
              Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _phoneController,
              'No. Telp',
              Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _passwordController,
              'Password',
              Icons.lock,
              obscureText: true,
            ),

            const SizedBox(height: 32),

            // Tombol Daftar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF009688,
                  ), // Warna Teal Soulvia
                  foregroundColor: Colors.white,
                ),
                onPressed: authState.isLoading ? null : _onRegister,
                child: authState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Daftar Sekarang',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // Link ke Login
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Sudah punya akun? Masuk di sini'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk TextField agar kode tidak berantakan
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF009688)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // 2. Fungsi Logika Pendaftaran
  void _onRegister() async {
    // Tangkap navigator & messenger sebelum await (agar tidak ada garis biru)
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    await ref
        .read(authControllerProvider.notifier)
        .register(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          username: _usernameController.text.trim(),
          fullName: _fullNameController.text.trim(),
          phone: _phoneController.text.trim(),
        );

    if (!mounted) return;

    if (ref.read(authControllerProvider).hasError) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran Gagal! Cek kembali data Anda.'),
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Berhasil Daftar! Silakan cek email konfirmasi.'),
        ),
      );
      // Kembali ke halaman Login setelah sukses
      navigator.pop();
    }
  }
}
