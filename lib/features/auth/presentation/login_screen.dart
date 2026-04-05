import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulvie_app/features/auth/logic/auth_controller.dart';
import 'package:soulvie_app/features/auth/presentation/register_screen.dart';
import 'package:soulvie_app/features/dashboard/presentation/dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch status loading dari controller
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Masuk ke MentalHealth')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email, Username, atau No. Telp',
                hint: Text('Masukkan identitas akunmu'),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 30),

            // Tombol Login dengan status Loading
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        // Tangkap" messenger dan navigator SEBELUM await
                        final messeger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);

                        await ref
                            .read(authControllerProvider.notifier)
                            .login(
                              _emailController.text,
                              _passwordController.text,
                            );
                        if (!mounted) return;

                        // Cek jika error, tampilkan Snackbar
                        if (ref.read(authControllerProvider).hasError) {
                          messeger.showSnackBar(
                            const SnackBar(
                              content: Text('Login Gagal! Cek email/password.'),
                            ),
                          );
                        } else {
                          // Jika sukses, pindah ke Dashboard (nanti kita buat)

                          if (mounted) {
                            navigator.pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const DashboardScreen(),
                              ),
                            );
                          }
                        }
                      },
                child: authState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text('Belum punya akun? Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
