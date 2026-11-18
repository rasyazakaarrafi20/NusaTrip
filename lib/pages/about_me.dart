
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  static const List<Map<String, dynamic>> teamMembers = [
    {
      'name': 'Rasya Zaka Arrafi',
      'nim': '25051204419',
      'role': 'BACKEND & API INTEGRATION',
      'instagram': 'rrafie.20',
      'image': 'assets/images/fotogua.jpeg',
    },
    {
      'name': 'Dea Apriani Agustin',
      'nim': '25051204387',
      'role': 'DATABASE & AUTH',
      'instagram': 'deaaayya',
      'image': 'assets/images/foto_dea.jpg',
    },
    {
      'name': 'Aghnia Khairi Faza Maverika',
      'nim': '25051204404',
      'role': 'UI/UX DESIGNER',
      'instagram': 'aniiarchivee',
      'image': 'assets/images/foto_aghnia.jpeg',
    },
    {
      'name': 'Nila Nazatul Fafa',
      'nim': '25051204415',
      'role': 'FRONTEND DEVELOPER & QA',
      'instagram': 'nzf.nilaa__',
      'image': 'assets/images/foto_nila.jpeg',
    },
    {
      'name': 'Fauzan Ramdhani Fajri',
      'nim': '25051204400',
      'role': 'FRONTEND DEVELOPER & QA',
      'instagram': 'fau.zanrf',
      'image': 'assets/images/foto_fauzan.jpg',
    },
  ];

  Future<void> _launchInstagram(
    BuildContext context,
    String username,
  ) async {
    final Uri url = Uri.parse('https://instagram.com/$username');

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka Instagram @$username'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final appBarBackground =
        theme.appBarTheme.backgroundColor ?? colors.primary;

    final appBarForeground =
        theme.appBarTheme.foregroundColor ?? colors.onPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        title: Text(
          'About Us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appBarForeground,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER NUSATRIP
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF60A5FA),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB)
                        .withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logo_nusatrip.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.travel_explore,
                          size: 50,
                          color: Color(0xFF2563EB),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tim NusaTrip',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Kelompok 3',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kami adalah tim developer di balik aplikasi eksplorasi wisata Indonesia. NusaTrip dibuat untuk memenuhi tugas mata kuliah PBP.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle(
              'Teknologi yang Digunakan',
              theme,
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTechChip('Flutter', Icons.flutter_dash, colors),
                _buildTechChip('Dart', Icons.code, colors),
                _buildTechChip('Cloudflare', Icons.cloud, colors),
                _buildTechChip('Supabase', Icons.storage, colors),
              ],
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Fitur Utama', theme),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.outlineVariant
                      .withValues(alpha: 0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.12 : 0.03,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildFeatureItem(
                    Icons.explore,
                    'Eksplorasi Wisata',
                    'Menemukan destinasi populer di seluruh Indonesia.',
                    colors,
                  ),
                  Divider(
                    height: 24,
                    color: colors.outlineVariant,
                  ),
                  _buildFeatureItem(
                    Icons.calendar_month,
                    'Rencana Perjalanan',
                    'Mencatat dan menyimpan jadwal liburan dengan mudah.',
                    colors,
                  ),
                  Divider(
                    height: 24,
                    color: colors.outlineVariant,
                  ),
                  _buildFeatureItem(
                    Icons.favorite,
                    'Daftar Favorit',
                    'Menyimpan tempat wisata impian dalam satu klik.',
                    colors,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Tim Developer', theme),

            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                final member = teamMembers[index];

                return _buildTeamCard(
                  context,
                  member,
                  colors,
                  isDark,
                );
              },
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                'NusaTrip v1.0.0 • Tugas Mata Kuliah PBP 2026',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    ThemeData theme,
  ) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTeamCard(
    BuildContext context,
    Map<String, dynamic> member,
    ColorScheme colors,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 140,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            right: 110,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['role'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'NIM: ${member['nim']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () => _launchInstagram(
                          context,
                          member['instagram'],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: colors.outlineVariant
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                size: 12,
                                color: Color(0xFFE1306C),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '@${member['instagram']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(19),
                topLeft: Radius.circular(20),
              ),
              child: Image.asset(
                member['image'],
                width: 110,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 110,
                    height: 140,
                    color: colors.primaryContainer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 30,
                          color: colors.primary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Foto tidak ada',
                          style: TextStyle(
                            fontSize: 9,
                            color: colors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechChip(
    String label,
    IconData icon,
    ColorScheme colors,
  ) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: colors.primary,
      ),
      label: Text(label),
      backgroundColor: colors.primaryContainer,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: colors.onPrimaryContainer,
        fontSize: 12,
      ),
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String title,
    String subtitle,
    ColorScheme colors,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: colors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: colors.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
