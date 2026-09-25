class FotoWisata {
  final int _id;
  final int _idWisata;
  final String _gambar;

  FotoWisata({
    required int id,
    required int idWisata,
    required String gambar,
  })  : _id = id,
        _idWisata = idWisata,
        _gambar = gambar;

  int get id => _id;
  int get idWisata => _idWisata;
  String get gambar => _gambar;
}