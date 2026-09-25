import 'package:flutter/material.dart';

import 'profile_page.dart';
import 'detail_wisata.dart';
import 'favorite_page.dart';
import '../fungsi/favorite_data.dart';
import '../widgets/category_section.dart';
import '../widgets/destination_card.dart';
import '../fungsi/wisata_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = '';
  String kategoriDipilih = 'Semua';

  @override
  Widget build(BuildContext context) {
    final hasilPencarian = wisata.where((tempat) {
      final cocokSearch = tempat.nama
          .toLowerCase()
          .contains(search.toLowerCase());

      final cocokKategori = kategoriDipilih == 'Semua' ||
          tempat.kategori == kategoriDipilih;

      return cocokSearch && cocokKategori;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'NusaTrip',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 45,
              minHeight: 45,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritePage(),
                ),
              ).then((_) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.favorite_border),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 45,
              minHeight: 45,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
          const SizedBox(width: 5),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jelajahi Indonesia 🇮🇩',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Temukan destinasi wisata terbaik di seluruh nusantara.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari destinasi...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            CategorySection(
              kategoriDipilih: kategoriDipilih,
              onKategoriChanged: (kategori) {
                setState(() {
                  kategoriDipilih = kategori;
                });
              },
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Destinasi Populer',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      kategoriDipilih = 'Semua';
                      search = '';
                    });
                  },
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),

            hasilPencarian.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text(
                        'Destinasi tidak ditemukan',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: hasilPencarian.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 700
                              ? 4
                              : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio:
                          MediaQuery.of(context).size.width > 700
                              ? 1.35
                              : 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final tempat = hasilPencarian[index];

                      return DestinationCard(
                        wisata: tempat,
                        isFavorite:
                            FavoriteData.cekFavorit(tempat),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailWisata(
                                wisata: tempat,
                              ),
                            ),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                        onFavorite: () {
                          setState(() {
                            if (FavoriteData.cekFavorit(
                              tempat,
                            )) {
                              FavoriteData.hapus(tempat);
                            } else {
                              FavoriteData.tambah(tempat);
                            }
                          });
                        },
                      );
                    },
                  ),

            const SizedBox(height: 25),

            Center(
              child: Text(
                '© 2026 NusaTrip',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}