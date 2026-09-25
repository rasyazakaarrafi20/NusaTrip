import 'package:flutter/material.dart';

import '../fungsi/user_data.dart';
import '../models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showPassword = false;

  void daftar() {
    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (nama.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data harus diisi.'),
        ),
      );
      return;
    }

    final emailSudahAda = userData.any(
      (user) => user.email == email,
    );

    if (emailSudahAda) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email sudah terdaftar.'),
        ),
      );
      return;
    }

    final userBaru = User(
      id: userData.length + 1,
      nama: nama,
      email: email,
      password: password,
    );

    userData.add(userBaru);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pendaftaran berhasil.'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
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
                  Colors.black.withOpacity(0.15),
                  const Color(0xFF2563EB).withOpacity(0.60),
                  const Color(0xFF0F172A).withOpacity(0.92),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Column(
                children: [
                  // TOMBOL KEMBALI
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // LOGO
                  Image.asset(
                    'assets/images/logo_nusatrip.png',
                    width: 130,
                    height: 130,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Buat Akun NusaTrip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Mulai perjalananmu menjelajahi Indonesia.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // FORM CARD
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.20),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // NAMA
                        TextField(
                          controller: namaController,
                          decoration: InputDecoration(
                            labelText: 'Nama',
                            prefixIcon: const Icon(
                              Icons.person_outline,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F9FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // EMAIL
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                            ),
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
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
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

                        const SizedBox(height: 22),

                        // TOMBOL DAFTAR
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: daftar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'DAFTAR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // KEMBALI KE LOGIN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun?',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'MASUK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    '© 2026 NusaTrip',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}