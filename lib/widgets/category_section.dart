import 'package:flutter/material.dart';
import '../models/kategori.dart';

class CategorySection extends StatelessWidget {
  final String kategoriDipilih;
  final List<Kategori> daftarKategori;
  final Function(String) onKategoriChanged;

  const CategorySection({
    super.key,
    required this.kategoriDipilih,
    required this.daftarKategori,
    required this.onKategoriChanged,
  });

  static const List<Color> warnaKategori = [
    Color(0xFF2563EB),
    Color(0xFF16A34A),
    Color(0xFFF59E0B),
    Color(0xFF06B6D4),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: daftarKategori.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = daftarKategori[index];
          final warna =
              warnaKategori[index % warnaKategori.length];

          final aktif = kategoriDipilih == item.nama;

          return GestureDetector(
            onTap: () => onKategoriChanged(item.nama),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 68,
              decoration: BoxDecoration(
                color: warna.withValues(
                  alpha: aktif ? 0.18 : 0.10,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: aktif
                      ? warna
                      : warna.withValues(alpha: 0.20),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    child: Text(
                      item.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: warna,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
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
