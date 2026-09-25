import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Navbar
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        title: const Text(
          'About Me',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Isi halaman
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Profil pembuat aplikasi
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                      'assets/images/fotogua.jpeg',
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Arrafi',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Mahasiswa Teknik Informatika',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Tentang saya
            const Text(
              'Tentang Saya',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Saya adalah mahasiswa Teknik Informatika '
              'yang sedang mempelajari pengembangan aplikasi '
              'mobile menggunakan Flutter.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // Tentang aplikasi
            const Text(
              'Tentang NusaTrip',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'NusaTrip adalah aplikasi eksplorasi destinasi '
              'wisata Indonesia. Pengguna dapat mencari dan '
              'melihat berbagai destinasi wisata yang tersedia.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // Teknologi
            const Text(
              'Teknologi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.code,
                    color: Color(0xFF2563EB),
                  ),

                  SizedBox(width: 10),

                  Text(
                    'Flutter & Dart',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}