import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../fungsi/theme_controller.dart';
import '../fungsi/favorite_data.dart';
import '../fungsi/review_data.dart';
import '../fungsi/user_data.dart';

import 'about_me.dart';
import 'account_page.dart';
import 'favorite_page.dart';
import 'trip_page.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_logout_button.dart';
import '../widgets/profile_stats.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _bukaAkun() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AccountPage(),
      ),
    );

    if (!mounted) return;

    if (hasil == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const biru = Color(0xFF2563EB);

    final user = Supabase.instance.client.auth.currentUser;

    final namaUser =
        user?.userMetadata?['full_name'] ?? 'Pengguna NusaTrip';

    final emailUser = user?.email ?? '-';

    final jumlahReview = user == null
        ? 0
        : reviewData
            .where((review) => review.idUser.toString() == user.id)
            .length;

    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, child) {
        final isDark = ThemeController.instance.isDarkMode;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                theme.appBarTheme.backgroundColor ?? colors.primary,
            foregroundColor:
                theme.appBarTheme.foregroundColor ?? colors.onPrimary,
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

                // HEADER PROFIL
                ProfileHeader(
                  nama: namaUser.toString(),
                  email: emailUser,
                  fotoProfilUrl:
                      user?.userMetadata?['avatar_url']?.toString(),
                  fotoProfil: userAktif?.fotoProfil,
                  gunakanFluttermoji:
                      user?.userMetadata?['avatar_mode'] == 'fluttermoji',
                ),

                const SizedBox(height: 25),

                // STATISTIK PROFIL
                ProfileStats(
                  jumlahFavorit: FavoriteData.favorit.length,
                  jumlahReview: jumlahReview,
                ),

                const SizedBox(height: 25),

                // MENU FAVORIT
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

                // MENU RENCANA PERJALANAN
                ProfileMenuItem(
                  icon: Icons.calendar_month,
                  iconColor: biru,
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

                // MENU AKUN
                ProfileMenuItem(
                  icon: Icons.person,
                  iconColor: biru,
                  title: 'Akun',
                  subtitle: 'Ubah nama, email, dan foto profil',
                  onTap: _bukaAkun,
                ),

                // MENU ABOUT
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

                const SizedBox(height: 15),

                // PENGATURAN DARK MODE
                Card(
                  child: SwitchListTile(
                    secondary: Icon(
                      isDark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: colors.primary,
                    ),

                    title: const Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      isDark
                          ? 'Tampilan gelap aktif'
                          : 'Tampilan terang aktif',
                    ),

                    value: isDark,

                    activeThumbColor: colors.primary,

                    onChanged: (value) {
                      ThemeController.instance.setDarkMode(value);
                    },
                  ),
                ),

                const SizedBox(height: 15),

                // LOGOUT
                ProfileLogoutButton(
                  onTap: () async {
                    await Supabase.instance.client.auth.signOut();

                    if (context.mounted) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/login',
                      );
                    }
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
