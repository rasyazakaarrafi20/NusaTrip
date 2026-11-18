
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../fungsi/favorite_data.dart';
import '../fungsi/foto_wisata_data.dart';
import '../fungsi/wisata_data.dart';
import '../models/wisata.dart';
import '../widgets/review_section.dart';
import '../widgets/trip_planning.dart';
import '../widgets/wisata_map.dart';
import '../widgets/wisata_image.dart';

class DetailWisata extends StatefulWidget {
  final Wisata wisata;

  const DetailWisata({super.key, required this.wisata});

  @override
  State<DetailWisata> createState() => _DetailWisataState();
}

class _DetailWisataState extends State<DetailWisata> {
  int fotoAktif = 0;

  Widget bangunFoto(String sumber) {
    return WisataImage(
      sumber: sumber,
      namaWisata: widget.wisata.nama,
      fallbackAsset: widget.wisata.gambarFallbackLokal,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }

  bool get isFavorite {
    return FavoriteData.cekFavorit(widget.wisata);
  }

  Future<void> bukaMaps() async {
    final koordinatAda =
        widget.wisata.latitude.trim().isNotEmpty &&
        widget.wisata.longitude.trim().isNotEmpty;

    final query = koordinatAda
        ? '${widget.wisata.latitude},${widget.wisata.longitude}'
        : '${widget.wisata.nama}, ${widget.wisata.lokasi}';

    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> bukaTiket() async {
    final url = Uri.parse('https://www.traveloka.com/id-id/flight');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> bukaPenginapan() async {
    final url = Uri.parse('https://www.traveloka.com/id-id/hotel');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  List<String> ambilFoto() {
    if (widget.wisata.fotoGaleri.isNotEmpty) {
      return widget.wisata.fotoGaleri;
    }

    final indexWisata = wisata.indexOf(widget.wisata);

    if (indexWisata == -1) {
      return [widget.wisata.gambar];
    }

    final idWisata = indexWisata + 1;

    final daftarFoto = fotoWisata
        .where((foto) => foto.idWisata == idWisata)
        .map((foto) => foto.gambar)
        .toList();

    if (daftarFoto.isEmpty) {
      return [widget.wisata.gambar];
    }

    return daftarFoto;
  }

  @override
  Widget build(BuildContext context) {
    final daftarFoto = ambilFoto();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    debugPrint('NAMA WISATA: ${widget.wisata.nama}');
    debugPrint('URL GAMBAR: ${widget.wisata.gambar}');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colors.primary,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colors.onPrimary,
        title: const Text(
          'Detail Destinasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final sekarangFavorit = isFavorite;

              if (sekarangFavorit) {
                FavoriteData.hapus(widget.wisata);
              } else {
                FavoriteData.tambah(widget.wisata);
              }

              setState(() {});

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    sekarangFavorit
                        ? '♡ Dihapus dari favorit'
                        : '❤️ Ditambahkan ke favorit',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: daftarFoto.length,
                    onPageChanged: (index) {
                      setState(() {
                        fotoAktif = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return bangunFoto(daftarFoto[index]);
                    },
                  ),

                  if (daftarFoto.length > 1)
                    Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(daftarFoto.length, (index) {
                          return Container(
                            width: fotoAktif == index ? 20 : 7,
                            height: 7,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.wisata.nama,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.wisata.lokasi,
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.wisata.rating,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: bukaMaps,
                      icon: const Icon(Icons.map),
                      label: const Text(
                        'Lihat Lokasi di Google Maps',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    'Tentang Destinasi',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      widget.wisata.deskripsi,
                      style: TextStyle(
                        fontSize: 15,
                        color: colors.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Lokasi Destinasi',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (widget.wisata.latitude.trim().isNotEmpty &&
                      widget.wisata.longitude.trim().isNotEmpty &&
                      double.tryParse(widget.wisata.latitude) != null &&
                      double.tryParse(widget.wisata.longitude) != null)
                    WisataMap(
                      namaWisata: widget.wisata.nama,
                      latitude: double.parse(widget.wisata.latitude),
                      longitude: double.parse(widget.wisata.longitude),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 35,
                            color: colors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Koordinat peta belum tersedia.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colors.onSurface),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Gunakan tombol Google Maps untuk mencari lokasi.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 25),

                  Text(
                    'Informasi Wisata',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: infoCard(
                          Icons.location_on,
                          'Lokasi',
                          widget.wisata.lokasi,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: infoCard(
                          Icons.star,
                          'Rating',
                          '${widget.wisata.rating} / 5',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: infoCard(
                          Icons.landscape,
                          'Jenis',
                          widget.wisata.daftarKategori.isNotEmpty
                              ? widget.wisata.daftarKategori
                                    .map((kategori) => kategori.nama)
                                    .join(', ')
                              : widget.wisata.kategori,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: infoCard(
                          Icons.map,
                          'Wilayah',
                          widget.wisata.lokasi,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Text(
                    'Tips Berkunjung',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 15),

                  tipItem(
                    Icons.access_time,
                    'Pilih waktu berkunjung yang sesuai.',
                  ),

                  tipItem(
                    Icons.backpack,
                    'Bawa perlengkapan yang diperlukan.',
                  ),

                  tipItem(
                    Icons.wb_sunny,
                    'Perhatikan kondisi cuaca sebelum berangkat.',
                  ),

                  tipItem(
                    Icons.delete_outline,
                    'Jaga kebersihan dan lingkungan wisata.',
                  ),

                  const SizedBox(height: 28),

                  TripPlanning(
                    namaWisata: widget.wisata.nama,
                    onMaps: () {
                      bukaMaps();
                    },
                    onTiket: () {
                      bukaTiket();
                    },
                    onPenginapan: () {
                      bukaPenginapan();
                    },
                  ),

                  const SizedBox(height: 28),

                  ReviewSection(
                    idWisata: wisata.indexOf(widget.wisata) + 1,
                    onReviewAdded: () {
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: Text(
                      '© 2026 NusaTrip',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoCard(IconData icon, String title, String value) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: colors.primary,
            size: 25,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget tipItem(IconData icon, String text) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: colors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
