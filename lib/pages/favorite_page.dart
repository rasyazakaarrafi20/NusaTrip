import 'package:flutter/material.dart';

import '/fungsi/favorite_data.dart';
import '/models/wisata.dart';
import 'detail_wisata.dart';
import 'profile_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({
  super.key,
  this.dariNavbar = false,
  });

  final bool dariNavbar;

  @override
  State<FavoritePage> createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  void hapusFavorit(Wisata tempat) {
    setState(() {
      FavoriteData.hapus(tempat);
    });
  }

  @override
  Widget build(BuildContext context) {
    final daftarFavorit = FavoriteData.favorit;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: !widget.dariNavbar,
        title: const Text(
          'Favorit Saya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: widget.dariNavbar
            ? [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 45,
                    minHeight: 45,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_outline),
                ),
                const SizedBox(width: 5),
              ]
            : null,
      ),
      body: daftarFavorit.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Belum ada destinasi favorit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Tambahkan destinasi dengan menekan ❤️',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: daftarFavorit.length,
              itemBuilder: (context, index) {
                final tempat = daftarFavorit[index];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        tempat.gambar,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      tempat.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 15,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            tempat.lokasi,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () => hapusFavorit(tempat),
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailWisata(wisata: tempat),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}