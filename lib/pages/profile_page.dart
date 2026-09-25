import 'package:flutter/material.dart';
import 'about_me.dart';
import '../fungsi/user_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Navbar
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 30),

            // Foto profil
            const CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xFF2563EB),
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            // Nama pengguna
            Text(
              userAktif?.nama ?? 'Pengguna',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // Email pengguna
            Text(
              userAktif?.email ?? '-',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            // Menu About Me
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF2563EB),
                ),
                title: const Text(
                  'About Me',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Tentang saya dan NusaTrip',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutMe(),
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            // Tombol logout
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  userAktif = null;

                  Navigator.pushReplacementNamed(
                    context,
                    '/login',
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}