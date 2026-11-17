import 'dart:async';

import 'package:flutter/material.dart';

import '../fungsi/favorite_data.dart';
import '../fungsi/wisata_data.dart' as data_lokal;
import '../models/kategori.dart';
import '../models/wisata.dart';
import '../services/kategori_service.dart';
import '../services/wisata_service.dart';
import '../widgets/category_section.dart';
import '../widgets/destination_card.dart';
import '../widgets/explore_banner.dart';

import 'detail_wisata.dart';
import 'favorite_page.dart';
import 'profile_page.dart';
import 'trip_page.dart';

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

  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _bannerIndex = 0;

  List<Wisata> _destinasiTerbaik = [];

  @override
  void initState() {
    super.initState();

    _bannerController = PageController();

    // Banner berganti otomatis setiap 4 detik.
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted ||
          !_bannerController.hasClients ||
          _destinasiTerbaik.length <= 1) {
        return;
      }

      final nextIndex = (_bannerIndex + 1) % _destinasiTerbaik.length;

      _bannerController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    _muatData();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  // Membuka halaman detail wisata.
  void _bukaDetail(Wisata tempat) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailWisata(wisata: tempat)),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  // Mengubah status favorit wisata.
  void _ubahFavorit(Wisata tempat) {
    setState(() {
      if (FavoriteData.cekFavorit(tempat)) {
        FavoriteData.hapus(tempat);
      } else {
        FavoriteData.tambah(tempat);
      }
    });
  }

  // Mengambil data destinasi dan kategori.
  Future<void> _muatData() async {
    if (mounted) {
      setState(() {
        _sedangMemuat = true;
      });
    }

    bool fallback = false;

    // Mengambil destinasi dari API.
    try {
      final hasilWisata = await WisataService().ambilDestinasi();

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

    // Mengambil kategori dari API.
    try {
      final hasilKategori = await KategoriService().ambilKategori();

      if (hasilKategori.isNotEmpty) {
        _daftarKategori = [
          Kategori(id: 0, nama: 'Semua', icon: Icons.apps, slug: 'semua'),
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

    _ambilDestinasiTerbaik();

    setState(() {
      _menggunakanFallback = fallback;
      _sedangMemuat = false;
      _bannerIndex = 0;
    });

    debugPrint('Jumlah destinasi Home: ${_daftarWisata.length}');
    debugPrint('Jumlah kategori Home: ${_daftarKategori.length}');
  }

  void _ambilDestinasiTerbaik() {
    final salinan = List<Wisata>.from(_daftarWisata);

    salinan.sort((a, b) {
      final ratingA = double.tryParse(a.rating) ?? 0.0;
      final ratingB = double.tryParse(b.rating) ?? 0.0;
      return ratingB.compareTo(ratingA);
    });

    _destinasiTerbaik = salinan.take(5).toList();
  }

  // Kategori cadangan jika API tidak tersedia.
  List<Kategori> _kategoriFallback() {
    return [
      Kategori(id: 0, nama: 'Semua', icon: Icons.apps, slug: 'semua'),
      Kategori(id: 1, nama: 'Alam', icon: Icons.park, slug: 'alam'),
      Kategori(
        id: 2,
        nama: 'Budaya',
        icon: Icons.temple_buddhist,
        slug: 'budaya',
      ),
      Kategori(id: 3, nama: 'Pantai', icon: Icons.beach_access, slug: 'pantai'),
      Kategori(id: 4, nama: 'Gunung', icon: Icons.terrain, slug: 'gunung'),
    ];
  }

  // Memfilter destinasi berdasarkan pencarian dan kategori.
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

        if (tempat.daftarKategori.isEmpty) {
          cocokKategori = tempat.kategori.toLowerCase() == kategoriDicari;
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            icon: const Icon(Icons.person_outline, color: Colors.white),
            label: const Text(
              'Profil',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 5),

              const Text(
                'Temukan destinasi wisata terbaik di seluruh nusantara.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),

              const SizedBox(height: 18),

              // PENCARIAN DESTINASI
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

              const SizedBox(height: 22),

              // BANNER DESTINASI WISATA
              const Text(
                'Destinasi Pilihan',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              if (_destinasiTerbaik.isNotEmpty)
                SizedBox(
                  height: 210,
                  child: PageView.builder(
                    controller: _bannerController,
                    itemCount: _destinasiTerbaik.length,
                    onPageChanged: (index) {
                      setState(() {
                        _bannerIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final tempat = _destinasiTerbaik[index];

                      return ExploreBanner(
                        wisata: tempat,
                        isFavorite: FavoriteData.cekFavorit(tempat),
                        onTap: () {
                          _bukaDetail(tempat);
                        },
                        onFavorite: () {
                          _ubahFavorit(tempat);
                        },
                      );
                    },
                  ),
                )
              else
                Container(
                  height: 210,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    'Belum ada destinasi untuk ditampilkan.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

              const SizedBox(height: 12),

              // INDIKATOR BANNER
              if (_destinasiTerbaik.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_destinasiTerbaik.length, (index) {
                    final aktif = _bannerIndex == index;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: aktif ? 22 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: aktif
                            ? const Color(0xFF2563EB)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),

              const SizedBox(height: 22),

              // KATEGORI BERANDA
              if (_daftarKategori.isNotEmpty)
                CategorySection(
                  kategoriDipilih: kategoriDipilih,
                  daftarKategori: _daftarKategori,
                  onKategoriChanged: (kategori) {
                    setState(() {
                      kategoriDipilih = kategori;
                    });
                  },
                  onTripTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TripPage()),
                    ).then((_) {
                      if (mounted) {
                        setState(() {});
                      }
                    });
                  },
                ),

              const SizedBox(height: 15),

              // DESTINASI POPULER
              const Text(
                'Destinasi Populer',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              if (_sedangMemuat)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (hasilPencarian.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      'Destinasi tidak ditemukan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hasilPencarian.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: lebarLayar > 900
                        ? 4
                        : (lebarLayar > 600 ? 3 : 2),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: lebarLayar > 900
                        ? 1.0
                        : (lebarLayar > 600 ? 0.9 : 0.8),
                  ),
                  itemBuilder: (context, index) {
                    final tempat = hasilPencarian[index];
                    return DestinationCard(
                      wisata: tempat,
                      isFavorite: FavoriteData.cekFavorit(tempat),
                      onTap: () {
                        _bukaDetail(tempat);
                      },
                      onFavorite: () {
                        _ubahFavorit(tempat);
                      },
                    );
                  },
                ),

              if (_menggunakanFallback && !_sedangMemuat)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Sebagian data API gagal dimuat. Data lokal digunakan sebagai cadangan.',
                    style: TextStyle(color: Colors.orange, fontSize: 11),
                  ),
                ),

              const SizedBox(height: 25),

              // FOOTER
              Center(
                child: Text(
                  '© 2026 NusaTrip',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
