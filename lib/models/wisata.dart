class Wisata {
  String _nama;
  String _lokasi;
  String _rating;
  String _kategori;
  String _gambar;
  String _latitude;
  String _longitude;
  String _deskripsi;

  Wisata({
    required String nama,
    required String lokasi,
    required String rating,
    required String kategori,
    required String gambar,
    required String latitude,
    required String longitude,
    required String deskripsi,
  })  : _nama = nama,
        _lokasi = lokasi,
        _rating = rating,
        _kategori = kategori,
        _gambar = gambar,
        _latitude = latitude,
        _longitude = longitude,
        _deskripsi = deskripsi;

  String get nama => _nama;
  String get lokasi => _lokasi;
  String get rating => _rating;
  String get kategori => _kategori;
  String get gambar => _gambar;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get deskripsi => _deskripsi;

  set nama(String nilai) {
    _nama = nilai;
  }

  set lokasi(String nilai) {
    _lokasi = nilai;
  }

  set rating(String nilai) {
    _rating = nilai;
  }

  set kategori(String nilai) {
    _kategori = nilai;
  }

  set gambar(String nilai) {
    _gambar = nilai;
  }

  set latitude(String nilai) {
    _latitude = nilai;
  }

  set longitude(String nilai) {
    _longitude = nilai;
  }

  set deskripsi(String nilai) {
    _deskripsi = nilai;
  }
}