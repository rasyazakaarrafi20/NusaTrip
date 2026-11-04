import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  // --- DATA ANGGOTA KELOMPOK 3 (SUDAH 5 ORANG) ---
  static const List<Map<String, String>> teamMembers = [
    {
      'name': 'Rasya Zaka Arrafi',
      'nim': '25051204419',
      'role': 'Project Owner / Lead Developer',
      'instagram': 'rrafie_20',
      'image': 'assets/images/fotogua.jpeg',
    },
    {
      'name': 'Dea Apriani Agustin',
      'nim': '0987654321',
      'role': 'UI/UX & Frontend',
      'instagram': 'deayyaa16',
      'image': '',
    },
    {
      'name': 'Fauzan Ramdhani Fajri',
      'nim': '25051204400',
      'role': 'UI/UX & Frontend',
      'instagram': 'fau.zanrf',
      'image': '',
    },
    {
      'name': 'Aghnia Khairi Faza Maverika',
      'nim': '25051204404',
      'role': 'UI/UX & Frontend',
      'instagram': 'aniiarchivee',
      'image': '',
    },
    {
      'name': 'Anggota 5',
      'nim': '9988776655',
      'role': 'UI/UX & Frontend',
      'instagram': 'username_ig_5',
      'image': '',
    },
  ];

  // Fungsi buka Instagram
  Future<void> _launchInstagram(BuildContext context, String username) async {
    final Uri url = Uri.parse('https://instagram.com/$username');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka Instagram @$username')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        title: const Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // --- LOGIKA RESPONSIF UKURAN KARTU ---
          double maxWidth = constraints.maxWidth;
          double cardWidth = maxWidth - 40; // Default HP (1 kolom)
          double padding = 20.0;

          if (maxWidth > 1024) {
            // Laptop (3 kolom)
            padding = 32.0;
            // Lebar maksimal 1100, dibagi 3, dikurangi jarak antar kartu (16x2)
            cardWidth =
                ((maxWidth > 1100 ? 1100 : maxWidth) - (padding * 2) - 32) / 3;
          } else if (maxWidth >= 600) {
            // Tablet (2 kolom)
            padding = 24.0;
            cardWidth = (maxWidth - (padding * 2) - 16) / 2;
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER ABOUT US ---
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.travel_explore,
                            size: 80,
                            color: Color(0xFF2563EB),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Tim NusaTrip',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Kelompok 3',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Kami adalah tim developer di balik aplikasi eksplorasi wisata Indonesia.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- TENTANG APLIKASI ---
                    const Text(
                      'Tentang NusaTrip',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'NusaTrip adalah aplikasi eksplorasi destinasi '
                      'wisata Indonesia. Pengguna dapat mencari dan '
                      'melihat berbagai destinasi wisata yang tersedia. '
                      'Aplikasi ini dibuat untuk memenuhi tugas mata kuliah PBP.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- TEKNOLOGI ---
                    const Text(
                      'Teknologi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildTechChip('Flutter', Icons.flutter_dash),
                        _buildTechChip('Dart', Icons.code),
                        _buildTechChip('Cloudflare', Icons.cloud),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // --- TIM DEVELOPER (MENGGUNAKAN WRAP AGAR KE TENGAH) ---
                    const Text(
                      'Tim Developer',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Wrap(
                      spacing: 16, // Jarak horizontal antar kartu
                      runSpacing: 16, // Jarak vertikal antar baris
                      alignment: WrapAlignment
                          .center, // KUNCI: Agar sisa 1 kartu ke tengah
                      children: teamMembers.map((member) {
                        return SizedBox(
                          width: cardWidth, // Lebar dinamis
                          height:
                              275, // KUNCI: Tinggi dikunci agar tidak overflow
                          child: _buildMemberCard(context, member),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET KARTU ANGGOTA ---
  Widget _buildMemberCard(BuildContext context, Map<String, String> member) {
    final bool hasImage = member['image']!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // FOTO PROFIL
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFF2563EB).withOpacity(0.1),
            child: hasImage
                ? ClipOval(
                    child: Image.asset(
                      member['image']!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: 45,
                          color: Color(0xFF2563EB),
                        );
                      },
                    ),
                  )
                : const Icon(Icons.person, size: 45, color: Color(0xFF2563EB)),
          ),
          const SizedBox(height: 12),

          // NAMA
          Text(
            member['name']!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // NIM
          Text(
            'NIM: ${member['nim']}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),

          // PERAN
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              member['role']!,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Spacer(),

          // TOMBOL INSTAGRAM
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _launchInstagram(context, member['instagram']!),
              icon: const Icon(Icons.camera_alt_outlined, size: 16),
              label: const Text('Instagram', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET CHIP TEKNOLOGI ---
  Widget _buildTechChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16, color: const Color(0xFF2563EB)),
      label: Text(label),
      backgroundColor: const Color(0xFF2563EB).withOpacity(0.1),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF2563EB),
      ),
    );
  }
}
