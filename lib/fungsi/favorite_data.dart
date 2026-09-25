import '../models/wisata.dart';

class FavoriteData {
  static final List<Wisata> favorit = [];

  static void tambah(Wisata wisata) {
    if (!favorit.contains(wisata)) {
      favorit.add(wisata);
    }
  }

  static void hapus(Wisata wisata) {
    favorit.remove(wisata);
  }

  static bool cekFavorit(Wisata wisata) {
    return favorit.contains(wisata);
  }
}