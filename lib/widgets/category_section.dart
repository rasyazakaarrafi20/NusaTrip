import 'package:flutter/material.dart';
import '../models/kategori.dart';

class CategorySection extends StatelessWidget {
  final String kategoriDipilih;
  final List<Kategori> daftarKategori;
  final Function(String) onKategoriChanged;
  final VoidCallback? onTripTap;

  const CategorySection({
    super.key,
    required this.kategoriDipilih,
    required this.daftarKategori,
    required this.onKategoriChanged,
    this.onTripTap,
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
        itemCount: daftarKategori.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isTrip = index == daftarKategori.length;
          final item = isTrip ? null : daftarKategori[index];

          final warna = isTrip
              ? const Color(0xFFEA580C)
              : warnaKategori[index % warnaKategori.length];

          final aktif = !isTrip && kategoriDipilih == item!.nama;

          return GestureDetector(
            onTap: isTrip
                ? onTripTap
                : () => onKategoriChanged(item!.nama),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isTrip ? 96 : 68,
              decoration: BoxDecoration(
                color: warna.withValues(
                  alpha: aktif ? 0.18 : 0.10,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: aktif ? warna : warna.withValues(alpha: 0.20),
                  width: aktif ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isTrip ? Icons.luggage_outlined : item!.icon,
                    size: 23,
                    color: warna,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      isTrip ? 'Rencana Trip' : item!.nama,
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