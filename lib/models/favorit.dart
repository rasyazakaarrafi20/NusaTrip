class Favorite {
  final int _id;
  final int _idUser;
  final int _idWisata;

  Favorite({
    required int id,
    required int idUser,
    required int idWisata,
  })  : _id = id,
        _idUser = idUser,
        _idWisata = idWisata;

  int get id => _id;
  int get idUser => _idUser;
  int get idWisata => _idWisata;
}