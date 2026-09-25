import 'package:flutter/material.dart';

import '../fungsi/favorite_data.dart';
import '../fungsi/wisata_data.dart';
import '../fungsi/kategori_data.dart';
import '../models/wisata.dart';
import '../widgets/explore_banner.dart';
import '../widgets/explore_category.dart';
import '../widgets/explore_list_card.dart';
import '../widgets/trending_card.dart';
import 'detail_wisata.dart';
import 'favorite_page.dart';
import 'profile_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String search = '';
  String kategoriDipilih = '';


  void bukaDetail(Wisata tempat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailWisata(
          wisata: tempat,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void pilihKategori(String kategori) {
    setState(() {
      if (kategori == 'Semua') {
        kategoriDipilih = '';
      } else {
        kategoriDipilih = kategori;
      }

      search = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasilSearch = wisata.where((tempat) {
      final cocokSearch = tempat.nama
          .toLowerCase()
          .contains(search.toLowerCase());

      final cocokKategori = kategoriDipilih.isEmpty ||
          tempat.kategori == kategoriDipilih;

      return cocokSearch && cocokKategori;
    }).toList();

    final destinasiPilihan =
        wisata.isNotEmpty ? wisata.first : null;

    final trending = wisata.length > 1
        ? wisata.sublist(
            1,
            wisata.length > 4 ? 4 : wisata.length,
          )
        : <Wisata>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),

    appBar: AppBar(
      backgroundColor: const Color(0xFF2563EB),
      foregroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading:
          search.isNotEmpty || kategoriDipilih.isNotEmpty,
      leading:
          search.isNotEmpty || kategoriDipilih.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      search = '';
                      kategoriDipilih = '';
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                )
              : null,
      title: Text(
        search.isNotEmpty || kategoriDipilih.isNotEmpty
            ? 'Hasil Pencarian'
            : 'Explore',
        style: const TextStyle(
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
            );
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
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Temukan Tempat Impianmu ✨',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Jelajahi berbagai destinasi menarik di Indonesia.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

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
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            if (search.isNotEmpty || kategoriDipilih.isNotEmpty) ...[
              const SizedBox(height: 25),

              const Text(
                'Hasil Pencarian',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              hasilSearch.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'Destinasi tidak ditemukan',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: hasilSearch.map((tempat) {
                        return ExploreListCard(
                          wisata: tempat,
                          isFavorite:
                              FavoriteData.cekFavorit(tempat),
                          onTap: () {
                            bukaDetail(tempat);
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
                      }).toList(),
                    ),
            ] else ...[
              const SizedBox(height: 28),

              const Text(
                '✨ Destinasi Pilihan',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (destinasiPilihan != null)
                ExploreBanner(
                  wisata: destinasiPilihan,
                  isFavorite: FavoriteData.cekFavorit(
                    destinasiPilihan,
                  ),
                  onTap: () {
                    bukaDetail(destinasiPilihan);
                  },
                  onFavorite: () {
                    setState(() {
                      if (FavoriteData.cekFavorit(
                        destinasiPilihan,
                      )) {
                        FavoriteData.hapus(
                          destinasiPilihan,
                        );
                      } else {
                        FavoriteData.tambah(
                          destinasiPilihan,
                        );
                      }
                    });
                  },
                ),

              const SizedBox(height: 28),

              const Text(
                '🏷️ Jelajahi Kategori',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: kategori.length,
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.3,
                ),
                itemBuilder: (context, index) {
                  final item = kategori[index];

                  return ExploreCategory(
                    kategori: item,
                    onTap: () {
                      pilihKategori(item.nama);
                    },
                  );
                },
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🔥 Trending Sekarang',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${trending.length} tempat',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 205,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: trending.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 12);
                  },
                  itemBuilder: (context, index) {
                    final tempat = trending[index];

                    return TrendingCard(
                      wisata: tempat,
                      onTap: () {
                        bukaDetail(tempat);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                '🌏 Semua Destinasi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Column(
                children: wisata.map((tempat) {
                  return ExploreListCard(
                    wisata: tempat,
                    isFavorite:
                        FavoriteData.cekFavorit(tempat),
                    onTap: () {
                      bukaDetail(tempat);
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
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}