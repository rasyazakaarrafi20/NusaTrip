import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'main_page.dart';
import 'pages/splash_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA SESUAI PROMPT ---
    const primaryColor = Color(0xFF3A5EE0); // Biru Utama
    const accentColor = Color(0xFFFF8A3D);  // Oranye
    const bgColorLight = Color(0xFFF3F6FF); // Background Terang
    const textNavy = Color(0xFF111A3A);     // Teks Utama (Navy Gelap)
    const textSecondary = Color(0xFF4B5675); // Teks Sekunder (Abu Navy Gelap)

    // --- SATU TEMA TERANG YANG KONSISTEN ---
    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light, // PAKSA TERANG
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgColorLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
        onSurface: textNavy, // Teks default di atas background terang
      ),
      // Atur TextTheme agar semua teks otomatis warnanya pas (tidak pudar)
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        bodyLarge: const TextStyle(color: textNavy),
        bodyMedium: const TextStyle(color: textNavy),
        bodySmall: const TextStyle(color: textSecondary),
        titleLarge: const TextStyle(color: textNavy, fontWeight: FontWeight.bold),
        titleMedium: const TextStyle(color: textNavy, fontWeight: FontWeight.bold),
        titleSmall: const TextStyle(color: textSecondary, fontWeight: FontWeight.w600),
        labelLarge: const TextStyle(color: textNavy, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NusaTrip',
      theme: lightTheme,
      themeMode: ThemeMode.light, // MATIKAN DARK MODE SEMENTARA
      initialRoute: '/splash', 
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MainPage(),
      },
    );
  }
}