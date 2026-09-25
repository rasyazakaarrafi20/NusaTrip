import 'package:flutter/material.dart';

import '../models/kategori.dart';

class CategorySection extends StatelessWidget {
  final String kategoriDipilih;
  final Function(String) onKategoriChanged;

  const CategorySection({
    super.key,
    required this.kategoriDipilih,
    required this.onKategoriChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Kategori> kategori = [
      Kategori(
        id: 1,
        nama: 'Semua',
        icon: Icons.apps,
      ),
      Kategori(
        id: 2,
        nama: 'Alam',
        icon: Icons.park,
      ),
      Kategori(
        id: 3,
        nama: 'Budaya',
        icon: Icons.temple_buddhist,
      ),
      Kategori(
        id: 4,
        nama: 'Pantai',
        icon: Icons.beach_access,
      ),
      Kategori(
        id: 5,
        nama: 'Gunung',
        icon: Icons.terrain,
      ),
    ];

    final List<Color> warnaKategori = [
      const Color(0xFF2563EB),
      const Color(0xFF16A34A),
      const Color(0xFFF59E0B),
      const Color(0xFF06B6D4),
      const Color(0xFF8B5CF6),
    ];

    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kategori.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final item = kategori[index];
          final warna = warnaKategori[index];

          final aktif = kategoriDipilih == item.nama;

          return GestureDetector(
            onTap: () {
              onKategoriChanged(item.nama);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 58,
              decoration: BoxDecoration(
                color: warna.withOpacity(
                  aktif ? 0.18 : 0.10,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: aktif
                      ? warna
                      : warna.withOpacity(0.20),
                  width: aktif ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 23,
                    color: warna,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.nama,
                    style: TextStyle(
                      color: warna,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}