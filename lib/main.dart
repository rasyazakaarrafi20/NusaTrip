import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'fungsi/theme_controller.dart';

import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'main_page.dart';
import 'pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://sujcirezycmbyucenhpo.supabase.co',
    anonKey: 'sb_publishable_d5VAD7vu-pOl2CeSr3-83Q_FFa6T6L6',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3A5EE0);
    const accentColor = Color(0xFFFF8A3D);
    const bgColorLight = Color(0xFFF3F6FF);
    const textNavy = Color(0xFF111A3A);
    const textSecondary = Color(0xFF4B5675);

    final ThemeData lightTheme = FlexThemeData.light(
      primary: primaryColor,
      secondary: accentColor,
      appBarBackground: const Color(0xFF2563EB),
      scaffoldBackground: bgColorLight,
      appBarStyle: FlexAppBarStyle.background,
      useMaterial3: true,
    ).copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        bodyLarge: const TextStyle(color: textNavy),
        bodyMedium: const TextStyle(color: textNavy),
        bodySmall: const TextStyle(color: textSecondary),
        titleLarge: const TextStyle(
          color: textNavy,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: const TextStyle(
          color: textNavy,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: const TextStyle(
          color: textSecondary,
          fontWeight: FontWeight.w600,
        ),
        labelLarge: const TextStyle(
          color: textNavy,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );

    final ThemeData darkTheme = FlexThemeData.dark(
      primary: const Color(0xFF91A9FF),
      secondary: const Color(0xFFFFAB75),
      appBarBackground: const Color(0xFF172554),
      scaffoldBackground: const Color(0xFF10182B),
      appBarStyle: FlexAppBarStyle.background,
      useMaterial3: true,
    ).copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.dark().textTheme,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1B2540),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NusaTrip',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeController.instance.themeMode,
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const MainPage(),
          },
        );
      },
    );
  }
}
