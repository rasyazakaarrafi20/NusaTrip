import 'package:flutter/material.dart';

import '../models/kategori.dart';

class ExploreCategory extends StatelessWidget {
  final Kategori kategori;
  final VoidCallback onTap;

  const ExploreCategory({
    super.key,
    required this.kategori,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> warna = {
      'Semua': const Color(0xFF2563EB),
      'Gunung': const Color(0xFF8B5CF6),
      'Pantai': const Color(0xFF06B6D4),
      'Alam': const Color(0xFF16A34A),
      'Budaya': const Color(0xFFF59E0B),
    };

    final Color warnaKategori = warna[kategori.nama] ?? const Color(0xFF2563EB);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: warnaKategori.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: warnaKategori.withOpacity(0.20)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: warnaKategori.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(kategori.icon, size: 20, color: warnaKategori),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                kategori.nama,
                style: TextStyle(
                  color: warnaKategori,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
