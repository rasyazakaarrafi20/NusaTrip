import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../fungsi/favorite_data.dart';
import '../models/wisata.dart';

class DetailWisata extends StatefulWidget {
  final Wisata wisata;

  const DetailWisata({
    super.key,
    required this.wisata,
  });

  @override
  State<DetailWisata> createState() => _DetailWisataState();
}

class _DetailWisataState extends State<DetailWisata> {
  bool get isFavorite {
    return FavoriteData.cekFavorit(widget.wisata);
  }

  Future<void> bukaGoogleMaps() async {
    final latitude = widget.wisata.latitude;
    final longitude = widget.wisata.longitude;

    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
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
          'Detail Destinasi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.wisata.gambar,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.wisata.nama,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.wisata.lokasi,
                          style: const TextStyle(
                            color: Colors.grey,
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
                        style: const TextStyle(
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
                      onPressed: bukaGoogleMaps,
                      icon: const Icon(Icons.map),
                      label: const Text(
                        'Lihat Lokasi di Google Maps',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Tentang Destinasi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: Text(
                      widget.wisata.deskripsi,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Informasi Wisata',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
                          'Wisata Alam',
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

                  const Text(
                    'Tips Berkunjung',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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

                  const SizedBox(height: 25),

                  Center(
                    child: Text(
                      '© 2026 NusaTrip',
                      style: TextStyle(
                        color: Colors.grey.shade600,
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

  Widget infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF2563EB),
            size: 25,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget tipItem(
    IconData icon,
    String text,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF2563EB),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}