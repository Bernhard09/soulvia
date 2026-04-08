import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soulvie_app/features/auth/presentation/welcome_screen.dart';
import 'package:soulvie_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:soulvie_app/common/app_colors.dart'; // Sesuaikan path-nya

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 1. Setup Animasi (Durasi 1.5 detik)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Membuat kurva animasi agar lebih natural (melambat di akhir)
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // Mulai animasi
    _animationController.forward();

    // 2. Jalankan logika pengecekan token setelah animasi sedikit berjalan
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Tahan splash screen selama minimal 2.5 detik agar animasi terlihat utuh
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      // Token masih ada -> Arahkan ke WelcomeScreen (atau Home)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value, 
              child: Transform.scale(
                scale: 0.8 + (_animation.value * 0.2), 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo SVG
                    SvgPicture.asset(
                      'assets/images/app_logo.svg', 
                      width: 100,
                      height: 120,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary, 
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Teks SOULVIA
                    const Text(
                      'SOULVIA',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary, // Mewarnai teks dengan warna primary
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}