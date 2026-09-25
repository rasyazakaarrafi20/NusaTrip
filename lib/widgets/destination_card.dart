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
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            Stack(
              children: [
                SizedBox(
                  height: 125,
                  width: double.infinity,
                  child: Image.asset(
                    wisata.gambar,
                    fit: BoxFit.cover,
                  ),
                ),

                // Favorite
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: InkWell(
                      onTap: onFavorite,
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: 34,
                        height: 34,
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 19,
                          color: isFavorite
                              ? Colors.red
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ),

                // Rating
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          wisata.rating,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Informasi wisata
            Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                11,
                12,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wisata.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          wisata.lokasi,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 9),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      wisata.kategori,
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
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
}