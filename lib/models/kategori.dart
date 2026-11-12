
import 'package:flutter/material.dart';

class Kategori {
  final int id;
  final String nama;
  final IconData icon;
  final String slug;
  final String imageUrl;

  Kategori({
    required this.id,
    required this.nama,
    this.icon = Icons.category_outlined,
    this.slug = '',
    this.imageUrl = '',
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      nama: json['name']?.toString() ?? 'Tanpa nama',
      slug: json['slug']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      icon: _iconUntukKategori(
        json['name']?.toString() ?? '',
      ),
    );
  }

  static IconData _iconUntukKategori(String nama) {
    switch (nama.toLowerCase()) {
      case 'beach':
        return Icons.beach_access;
      case 'mountain':
        return Icons.terrain;
      case 'lake':
        return Icons.water;
      case 'forest':
        return Icons.forest;
      case 'park':
        return Icons.park;
      case 'island':
        return Icons.landscape;
      case 'ocean':
      case 'underwater':
      case 'coral':
        return Icons.waves;
      case 'culture':
      case 'architecture':
        return Icons.account_balance;
      case 'camping':
        return Icons.local_fire_department;
      case 'rafting':
        return Icons.kayaking;
      case 'city':
        return Icons.location_city;
      case 'landscape':
        return Icons.landscape;
      default:
        return Icons.category_outlined;
    }
  }
}
