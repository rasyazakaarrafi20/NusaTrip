
import 'package:flutter/material.dart';

import 'profile_page.dart';
import 'detail_wisata.dart';
import 'favorite_page.dart';

import '../fungsi/favorite_data.dart';
import '../fungsi/wisata_data.dart' as data_lokal;

import '../models/wisata.dart';
import '../models/kategori.dart';

import '../services/wisata_service.dart';
import '../services/kategori_service.dart';

import '../widgets/category_section.dart';
import '../widgets/destination_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = '';
  String kategoriDipilih = 'Semua';

  List<Wisata> _daftarWisata = [];
  List<Kategori> _daftarKategori = [];

  bool _sedangMemuat = true;
  bool _menggunakanFallback = false;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    if (mounted) {
      setState(() {
        _sedangMemuat = true;
      });
    }

    bool fallback = false;

    // Ambil destinasi dari API.
    try {
      final hasilWisata =
          await WisataService().ambilDestinasi();

              debugPrint('========== DAFTAR DESTINASI API ==========');

    for (final item in hasilWisata) {
      debugPrint(
        'ID: ${item.id} | '
        'SLUG: ${item.slug} | '
        'NAMA: ${item.nama}',
      );
    }

    debugPrint('========== SELESAI ==========');

      if (hasilWisata.isNotEmpty) {
        _daftarWisata = hasilWisata;
      } else {
        _daftarWisata = data_lokal.wisata;
        fallback = true;
      }
    } catch (e) {
      debugPrint('Gagal mengambil destinasi API: $e');
      _daftarWisata = data_lokal.wisata;
      fallback = true;
    }

    // Ambil kategori dari API.
    try {
      final hasilKategori =
          await KategoriService().ambilKategori();

      if (hasilKategori.isNotEmpty) {
        _daftarKategori = [
          Kategori(
            id: 0,
            nama: 'Semua',
            icon: Icons.apps,
            slug: 'semua',
          ),
          ...hasilKategori,
        ];
      } else {
        _daftarKategori = _kategoriFallback();
        fallback = true;
      }
    } catch (e) {
      debugPrint('Gagal mengambil kategori API: $e');
      _daftarKategori = _kategoriFallback();
      fallback = true;
    }

    if (!mounted) return;

    setState(() {
      _menggunakanFallback = fallback;
      _sedangMemuat = false;
    });

    debugPrint(
      'Jumlah destinasi Home: ${_daftarWisata.length}',
    );
    debugPrint(
      'Jumlah kategori Home: ${_daftarKategori.length}',
    );
  }

  List<Kategori> _kategoriFallback() {
    return [
      Kategori(
        id: 0,
        nama: 'Semua',
        icon: Icons.apps,
        slug: 'semua',
      ),
      Kategori(
        id: 1,
        nama: 'Alam',
        icon: Icons.park,
        slug: 'alam',
      ),
      Kategori(
        id: 2,
        nama: 'Budaya',
        icon: Icons.temple_buddhist,
        slug: 'budaya',
      ),
      Kategori(
        id: 3,
        nama: 'Pantai',
        icon: Icons.beach_access,
        slug: 'pantai',
      ),
      Kategori(
        id: 4,
        nama: 'Gunung',
        icon: Icons.terrain,
        slug: 'gunung',
      ),
    ];
  }

  List<Wisata> get _hasilPencarian {
    return _daftarWisata.where((tempat) {
      final kataKunci = search.toLowerCase().trim();

      final cocokSearch =
          tempat.nama.toLowerCase().contains(kataKunci) ||
          tempat.lokasi.toLowerCase().contains(kataKunci) ||
          tempat.provinsi.toLowerCase().contains(kataKunci) ||
          tempat.pulau.toLowerCase().contains(kataKunci);

      bool cocokKategori = kategoriDipilih == 'Semua';

      if (!cocokKategori) {
        final kategoriDicari = kategoriDipilih.toLowerCase();

        cocokKategori = tempat.daftarKategori.any((kategori) {
          return kategori.nama.toLowerCase() == kategoriDicari ||
              kategori.slug.toLowerCase() == kategoriDicari;
        });

        // Mendukung data lokal yang masih memakai satu kategori.
        if (tempat.daftarKategori.isEmpty) {
          cocokKategori =
              tempat.kategori.toLowerCase() == kategoriDicari;
        }
      }

      return cocokSearch && cocokKategori;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasilPencarian = _hasilPencarian;
    final lebarLayar = MediaQuery.of(context).size.width;

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
                if (mounted) setState(() {});
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

      body: RefreshIndicator(
        onRefresh: _muatData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

              if (_daftarKategori.isNotEmpty)
                CategorySection(
                  kategoriDipilih: kategoriDipilih,
                  daftarKategori: _daftarKategori,
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

              if (_sedangMemuat)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (hasilPencarian.isEmpty)
                const Center(
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
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hasilPencarian.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: lebarLayar > 700 ? 4 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio:
                        lebarLayar > 700 ? 1.35 : 0.78,
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
                                DetailWisata(wisata: tempat),
                          ),
                        ).then((_) {
                          if (mounted) setState(() {});
                        });
                      },
                      onFavorite: () {
                        setState(() {
                          if (FavoriteData.cekFavorit(tempat)) {
                            FavoriteData.hapus(tempat);
                          } else {
                            FavoriteData.tambah(tempat);
                          }
                        });
                      },
                    );
                  },
                ),

              if (_menggunakanFallback && !_sedangMemuat)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Sebagian data API gagal dimuat. Data lokal digunakan sebagai cadangan.',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                    ),
                  ),
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
      ),
    );
  }
}
