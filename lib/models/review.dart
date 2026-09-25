class Review {
  int _id;
  int _idUser;
  int _idWisata;
  double _rating;
  String _komentar;

  Review({
    required int id,
    required int idUser,
    required int idWisata,
    required double rating,
    required String komentar,
  })  : _id = id,
        _idUser = idUser,
        _idWisata = idWisata,
        _rating = rating,
        _komentar = komentar;

  int get id => _id;
  int get idUser => _idUser;
  int get idWisata => _idWisata;
  double get rating => _rating;
  String get komentar => _komentar;

  set rating(double nilai) {
    _rating = nilai;
  }

  set komentar(String nilai) {
    _komentar = nilai;
  }
}