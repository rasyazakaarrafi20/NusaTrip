import 'package:flutter/material.dart';
import '../fungsi/user_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

    void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final user = userData.where(
      (user) => user.email == email,
    );

    if (user.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email belum terdaftar.'),
        ),
      );
      return;
    }

    final userDitemukan = user.first;

    if (userDitemukan.password != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password salah.'),
        ),
      );
      return;
    }

    userAktif = userDitemukan;

    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/home');
  }

  // POPUP LOGIN
  void tampilkanLogin() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),

              // JUDUL
              title: const Text(
                'Selamat Datang 👋',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Masuk untuk melanjutkan perjalananmu.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // EMAIL
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: const Color(0xFFF5F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // PASSWORD
                  TextField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setDialogState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),

              // TOMBOL
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

              actions: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'MASUK',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // FOTO BACKGROUND
          SizedBox.expand(
            child: Image.asset(
              'assets/images/gunungbromo.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.10),
                  const Color(0xFF2563EB).withOpacity(0.55),
                  const Color(0xFF0F172A).withOpacity(0.90),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ISI HALAMAN
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    // LOGO NUSATRIP
                    Image.asset(
                      'assets/images/logo_nusatrip.png',
                      width: 210,
                      height: 210,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 15),
                    const SizedBox(height: 8),

                    // TAGLINE
                    const Text(
                      'Jelajahi Keindahan\nIndonesia Bersama Kami',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 45),

                    // TOMBOL MASUK
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: tampilkanLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'MASUK',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // TOMBOL DAFTAR
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'DAFTAR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // FOOTER
                    const Text(
                      '© 2026 NusaTrip',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
