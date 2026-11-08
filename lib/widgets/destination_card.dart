import 'package:flutter/material.dart';
import '../models/wisata.dart';

class DestinationCard extends StatelessWidget {
  final Wisata wisata;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const DestinationCard({
    super.key,
    required this.wisata,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06), // Diperbarui ke withValues
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FOTO (Menggunakan Expanded agar fleksibel) ---
            Expanded(
              flex: 5, // Porsi 5 bagian dari 9
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    wisata.gambar,
                    fit: BoxFit.cover,
                  ),
                  
                  // Overlay gradasi tipis di bawah foto agar rating lebih jelas
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Tombol Favorite
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        onTap: onFavorite,
                        customBorder: const CircleBorder(),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFavorite ? Colors.red : const Color(0xFF4B5675),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Rating
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 12, color: Colors.amber),
                          const SizedBox(width: 3),
                          Text(
                            wisata.rating,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111A3A), // Teks Navy
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- INFORMASI WISATA (Teks) ---
            Expanded(
              flex: 4, // Porsi 4 bagian dari 9
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8), // Padding sedikit dikurangi
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Bagi ruang secara rata
                  children: [
                    // Nama Wisata
                    Text(
                      wisata.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13, // Sedikit dikecilkan agar aman
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111A3A), // Warna Navy Gelap
                      ),
                    ),

                    // Lokasi
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: Color(0xFF4B5675), // Abu Navy
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            wisata.lokasi,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF4B5675), // Abu Navy
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Kategori
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A5EE0).withValues(alpha: 0.1), // Biru transparan
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        wisata.kategori,
                        style: const TextStyle(
                          color: Color(0xFF3A5EE0), // Biru Utama
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}