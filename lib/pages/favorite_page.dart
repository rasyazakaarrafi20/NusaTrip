
import 'package:flutter/material.dart';

import '/fungsi/favorite_data.dart';
import '/models/wisata.dart';
import '../widgets/wisata_image.dart';
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final appBarBackground =
        theme.appBarTheme.backgroundColor ?? colors.primary;

    final appBarForeground =
        theme.appBarTheme.foregroundColor ?? colors.onPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        elevation: 0,
        automaticallyImplyLeading: !widget.dariNavbar,
        title: Text(
          'Favorit Saya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appBarForeground,
          ),
        ),
        actions: widget.dariNavbar
            ? [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: appBarForeground,
                  ),
                  icon: Icon(
                    Icons.person_outline,
                    color: appBarForeground,
                  ),
                  label: Text(
                    'Profil',
                    style: TextStyle(
                      color: appBarForeground,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ]
            : null,
      ),
      body: daftarFavorit.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 70,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Belum ada destinasi favorit',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tambahkan destinasi dengan menekan ❤️',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;

                if (constraints.maxWidth > 900) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth > 600) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth > 400) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: daftarFavorit.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 230,
                  ),
                  itemBuilder: (context, index) {
                    final tempat = daftarFavorit[index];

                    return Card(
                      color: colors.surface,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailWisata(wisata: tempat),
                            ),
                          ).then((_) {
                            if (mounted) {
                              setState(() {});
                            }
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 140,
                              width: double.infinity,
                              child: WisataImage(
                                sumber: tempat.gambar,
                                namaWisata: tempat.nama,
                                fallbackAsset:
                                    tempat.gambarFallbackLokal,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            tempat.nama,
                                            style: theme.textTheme
                                                .titleSmall
                                                ?.copyWith(
                                              fontSize: 15,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: colors
                                                    .onSurfaceVariant,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  tempat.lokasi,
                                                  style: TextStyle(
                                                    color: colors
                                                        .onSurfaceVariant,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          hapusFavorit(tempat),
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints:
                                          const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
