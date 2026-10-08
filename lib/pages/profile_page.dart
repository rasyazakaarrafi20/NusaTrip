import 'package:flutter/material.dart';

import 'about_me.dart';
import 'account_page.dart';
import 'favorite_page.dart';
import 'trip_page.dart';

import '../fungsi/user_data.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_logout_button.dart';

import '../fungsi/favorite_data.dart';
import '../fungsi/review_data.dart';

import '../widgets/profile_stats.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            ProfileHeader(
              nama: userAktif?.nama ?? 'Pengguna',
              email: userAktif?.email ?? '-',
            ),

            const SizedBox(height: 25),

            ProfileStats(
              jumlahFavorit: FavoriteData.favorit.length,
              jumlahReview: userAktif == null
                  ? 0
                  : reviewData
                      .where(
                        (review) => review.idUser == userAktif!.id,
                      )
                      .length,
            ),

            const SizedBox(height: 25),

            ProfileMenuItem(
              icon: Icons.favorite,
              iconColor: Colors.red,
              title: 'Favorit',
              subtitle: 'Destinasi tersimpan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritePage(),
                  ),
                );
              },
            ),

            ProfileMenuItem(
              icon: Icons.calendar_month,
              iconColor: const Color(0xFF2563EB),
              title: 'Rencana Perjalanan',
              subtitle: 'Lihat dan kelola perjalanan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TripPage(),
                  ),
                );
              },
            ),

            ProfileMenuItem(
              icon: Icons.person,
              iconColor: const Color(0xFF2563EB),
              title: 'Akun',
              subtitle: 'Informasi akun',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountPage(),
                  ),
                );
              },
            ),

            ProfileMenuItem(
              icon: Icons.info,
              iconColor: Colors.green,
              title: 'About NusaTrip',
              subtitle: 'Tentang aplikasi',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutMe(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            ProfileLogoutButton(
              onTap: () {
                userAktif = null;

                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}