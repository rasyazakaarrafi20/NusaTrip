import 'package:flutter/material.dart';

import '../models/wisata.dart';
import '../services/wisata_service.dart';
import '../widgets/destination_card.dart';
import '../fungsi/favorite_data.dart';
import 'detail_wisata.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<String> _riwayatPencarian = [];
  List<Wisata> _semuaWisata = [];
  List<Wisata> _hasilPencarian = [];
  bool _sedangMemuat = true;

  @override
  void initState() {
    super.initState();
    _ambilDataApi();
    _muatRiwayat();
  }

  Future<void> _muatRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _riwayatPencarian = prefs.getStringList('riwayat_pencarian') ?? [];
    });
  }

  Future<void> _simpanRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('riwayat_pencarian', _riwayatPencarian);
  }

  Future<void> _ambilDataApi() async {
    try {
      final hasil = await WisataService().ambilDestinasi();
      setState(() {
        _semuaWisata = hasil;
        _sedangMemuat = false;
      });
    } catch (e) {
      debugPrint('Error ambil data: $e');
      setState(() {
        _sedangMemuat = false;
      });
    }
  }

  void _tambahRiwayat(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _riwayatPencarian.remove(query);
      _riwayatPencarian.insert(0, query);
    });
    _simpanRiwayat();
  }

  void _hapusRiwayat(int index) {
    setState(() {
      _riwayatPencarian.removeAt(index);
    });
    _simpanRiwayat();
  }

  void _hapusSemuaRiwayat() {
    setState(() {
      _riwayatPencarian.clear();
    });
    _simpanRiwayat();
  }

  void _lakukanPencarian(String query) {
    _tambahRiwayat(query);
    if (query.trim().isEmpty) {
      setState(() {
        _hasilPencarian = [];
      });
      return;
    }

    setState(() {
      _hasilPencarian = _semuaWisata.where((tempat) {
        return tempat.nama.toLowerCase().contains(query.toLowerCase()) ||
            tempat.lokasi.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Widget _buildRiwayat() {
    if (_riwayatPencarian.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada riwayat pencarian.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat Pencarian',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111A3A),
                ),
              ),
              TextButton(
                onPressed: _hapusSemuaRiwayat,
                child: const Text(
                  'Hapus Semua',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _riwayatPencarian.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history, color: Colors.grey),
                  title: Text(
                    _riwayatPencarian[index],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF111A3A),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                    onPressed: () => _hapusRiwayat(index),
                  ),
                  onTap: () {
                    _searchController.text = _riwayatPencarian[index];
                    _lakukanPencarian(_riwayatPencarian[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHasilPencarian() {
    if (_sedangMemuat) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasilPencarian.isEmpty) {
      return const Center(
        child: Text(
          'Destinasi tidak ditemukan.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _hasilPencarian.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 900
            ? 4
            : (MediaQuery.of(context).size.width > 600 ? 3 : 2),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: MediaQuery.of(context).size.width > 900
            ? 1.0
            : (MediaQuery.of(context).size.width > 600 ? 0.9 : 0.8),
      ),

      itemBuilder: (context, index) {
        final tempat = _hasilPencarian[index];
        return DestinationCard(
          wisata: tempat,
          isFavorite: FavoriteData.cekFavorit(tempat),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailWisata(wisata: tempat),
              ),
            );
          },
          onFavorite: () {
            setState(() {
              if (FavoriteData.cekFavorit(tempat)) {
                FavoriteData.hapus(tempat);
              } else {
                FavoriteData.tambah(tempat);
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Cari Destinasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onSubmitted: (value) {
                _lakukanPencarian(value);
              },
              decoration: InputDecoration(
                hintText: 'Mau ke mana?',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _lakukanPencarian('');
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: _searchController.text.isEmpty
                ? _buildRiwayat()
                : _buildHasilPencarian(),
          ),
        ],
      ),
    );
  }
}
