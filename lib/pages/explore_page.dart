
import 'package:flutter/material.dart';

import '../fungsi/favorite_data.dart';
import '../fungsi/wisata_data.dart' as data_lokal;
import '../fungsi/kategori_data.dart' as kategori_lokal;
import '../models/wisata.dart';
import '../models/kategori.dart';
import '../services/wisata_service.dart';
import '../services/kategori_service.dart';
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
  final WisataService _wisataService = WisataService();
  final KategoriService _kategoriService = KategoriService();
  final TextEditingController _searchController =
      TextEditingController();

  List<Wisata> _daftarWisata = [];
  List<Kategori> _daftarKategori = [];

  String search = '';
  String kategoriDipilih = '';
  String slugKategoriDipilih = '';

  bool _sedangMemuat = true;
  String? _pesanStatus;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _muatData() async {
    setState(() {
      _sedangMemuat = true;
      _pesanStatus = null;
    });

    bool memakaiDataLokal = false;

    // Mengambil destinasi dari API.
    try {
      final hasilWisata = await _wisataService.ambilDestinasi();

      if (hasilWisata.isEmpty) {
        throw Exception('Data destinasi kosong.');
      }

      if (mounted) {
        setState(() {
          _daftarWisata = hasilWisata;
        });
      }
    } catch (e) {
      memakaiDataLokal = true;

      if (mounted) {
        setState(() {
          _daftarWisata = List<Wisata>.from(data_lokal.wisata);
        });
      }
    }

    // Mengambil kategori dari API.
    try {
      final hasilKategori =
          await _kategoriService.ambilKategori();

      if (hasilKategori.isEmpty) {
        throw Exception('Data kategori kosong.');
      }

      if (mounted) {
        setState(() {
          _daftarKategori = [
            Kategori(
              id: 0,
              nama: 'Semua',
              slug: 'semua',
              icon: Icons.apps,
            ),
            ...hasilKategori,
          ];
        });
      }
    } catch (e) {
      memakaiDataLokal = true;

      if (mounted) {
        setState(() {
          _daftarKategori =
              List<Kategori>.from(kategori_lokal.kategori);
        });
      }
    }

    if (!mounted) return;

    setState(() {
      _sedangMemuat = false;

      if (memakaiDataLokal) {
        _pesanStatus =
            'Sebagian data menggunakan data lokal. Periksa koneksi atau API.';
      }
    });
  }

  void bukaDetail(Wisata tempat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailWisata(
          wisata: tempat,
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void pilihKategori(Kategori item) {
    setState(() {
      if (item.slug == 'semua' || item.nama == 'Semua') {
        kategoriDipilih = '';
        slugKategoriDipilih = '';
      } else {
        kategoriDipilih = item.nama;
        slugKategoriDipilih = item.slug;
      }

      search = '';
      _searchController.clear();
    });
  }

  List<Wisata> get _hasilFilter {
    return _daftarWisata.where((tempat) {
      final query = search.toLowerCase();

      final cocokSearch =
          tempat.nama.toLowerCase().contains(query) ||
          tempat.lokasi.toLowerCase().contains(query) ||
          tempat.provinsi.toLowerCase().contains(query) ||
          tempat.pulau.toLowerCase().contains(query);

      final cocokKategori = kategoriDipilih.isEmpty ||
          tempat.daftarKategori.any((item) {
            if (slugKategoriDipilih.isNotEmpty) {
              return item.slug == slugKategoriDipilih;
            }

            return item.nama.toLowerCase() ==
                kategoriDipilih.toLowerCase();
          }) ||
          tempat.kategori.toLowerCase() ==
              kategoriDipilih.toLowerCase();

      return cocokSearch && cocokKategori;
    }).toList();
  }

  void _ubahFavorite(Wisata tempat) {
    setState(() {
      if (FavoriteData.cekFavorit(tempat)) {
        FavoriteData.hapus(tempat);
      } else {
        FavoriteData.tambah(tempat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasilSearch = _hasilFilter;

    final destinasiPilihan =
        _daftarWisata.isNotEmpty ? _daftarWisata.first : null;

    final trending = _daftarWisata.length > 1
        ? _daftarWisata.sublist(
            1,
            _daftarWisata.length > 4
                ? 4
                : _daftarWisata.length,
          )
        : <Wisata>[];

    final sedangFilter =
        search.isNotEmpty || kategoriDipilih.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),

      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: sedangFilter,
        leading: sedangFilter
            ? IconButton(
                onPressed: () {
                  setState(() {
                    search = '';
                    kategoriDipilih = '';
                    slugKategoriDipilih = '';
                    _searchController.clear();
                  });
                },
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(
          sedangFilter ? 'Hasil Pencarian' : 'Explore',
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

      body: _sedangMemuat
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF2563EB),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Memuat destinasi NusaTrip...',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _muatData,
              color: const Color(0xFF2563EB),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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

                    if (_pesanStatus != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _pesanStatus!,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            IconButton(
                              onPressed: _muatData,
                              icon: const Icon(Icons.refresh),
                              tooltip: 'Muat ulang',
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    TextField(
                      controller: _searchController,
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

                    if (sedangFilter) ...[
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
                                    _ubahFavorite(tempat);
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
                            _ubahFavorite(destinasiPilihan);
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
                        itemCount: _daftarKategori.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.3,
                        ),
                        itemBuilder: (context, index) {
                          final item = _daftarKategori[index];

                          return ExploreCategory(
                            kategori: item,
                            onTap: () {
                              pilihKategori(item);
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
                        children: _daftarWisata.map((tempat) {
                          return ExploreListCard(
                            wisata: tempat,
                            isFavorite:
                                FavoriteData.cekFavorit(tempat),
                            onTap: () {
                              bukaDetail(tempat);
                            },
                            onFavorite: () {
                              _ubahFavorite(tempat);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
