import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _mountainAnimation;
  late Animation<double> _sunAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _mountainAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeOut)),
    );
    _sunAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.2, curve: Curves.easeOut)),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6, curve: Curves.easeIn)),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6, curve: Curves.easeOutBack)),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 4200), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login'); 
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0E1327), 
              Color(0xFF3A5EE0), 
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Efek Cahaya
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.35,
              child: FadeTransition(
                opacity: _sunAnimation,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3A5EE0).withValues(alpha: 0.3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3A5EE0).withValues(alpha: 0.5),
                        blurRadius: 60,
                        spreadRadius: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),

            // 2. Siluet Gunung
            AnimatedBuilder(
              animation: _mountainAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: -_mountainAnimation.value, 
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 250),
                    painter: MountainPainter(),
                  ),
                );
              },
            ),

            // 3. Logo & Tagline
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: Column(
                      children: [
                        // --- REVISI: LOGO PAKAI GAMBAR DI KAPSUL PUTIH ---
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95), // Kapsul putih
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/logo_nusatrip.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Teks NusaTrip pakai font Anton
                        Text(
                          'NusaTrip',
                          style: GoogleFonts.anton(
                            color: Colors.white,
                            fontSize: 40,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Jelajahi Keindahan Indonesia Bersama Kami',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 4. Indikator Loading
            Positioned(
              bottom: 60,
              child: FadeTransition(
                opacity: _logoFadeAnimation,
                child: const SizedBox(
                  width: 50,
                  height: 3,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.3, size.height * 0.3); 
    path.lineTo(size.width * 0.5, size.height * 0.6);
    path.lineTo(size.width * 0.7, size.height * 0.2); 
    path.lineTo(size.width, size.height * 0.7);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}