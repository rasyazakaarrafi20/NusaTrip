import 'kategori.dart';

class Wisata {
  String _nama;
  String _lokasi;
  String _rating;
  String _kategori;
  String _gambar;
  String _latitude;
  String _longitude;
  String _deskripsi;

  final int? id;
  final String slug;
  final String pulau;
  final String provinsi;
  final List<Kategori> daftarKategori;
  final List<String> fotoGaleri;

  Wisata({
    required String nama,
    required String lokasi,
    required String rating,
    required String kategori,
    required String gambar,
    required String latitude,
    required String longitude,
    required String deskripsi,
    this.id,
    this.slug = '',
    this.pulau = '',
    this.provinsi = '',
    this.daftarKategori = const [],
    this.fotoGaleri = const [],
  }) : _nama = nama,
       _lokasi = lokasi,
       _rating = rating,
       _kategori = kategori,
       _gambar = gambar,
       _latitude = latitude,
       _longitude = longitude,
       _deskripsi = deskripsi;

  factory Wisata.fromJson(Map<String, dynamic> json) {
    final kategoriJson = json['categories'] as List? ?? [];

    final daftarKategori = kategoriJson
        .whereType<Map<String, dynamic>>()
        .map((item) => Kategori.fromJson(item))
        .toList();

    final island = json['vacation_island'];
    final province = json['vacation_province'];

    final fotoGaleri = <String>[];
    final urlUtama = json['image_url']?.toString() ?? '';
    if (urlUtama.trim().isNotEmpty) {
      fotoGaleri.add(urlUtama);
    }

    final fotoJson = json['photos'];
    if (fotoJson is List) {
      for (final foto in fotoJson.whereType<Map>()) {
        final url =
            (foto['image_url'] ?? foto['url'] ?? foto['src'])?.toString() ?? '';
        if (url.trim().isNotEmpty && !fotoGaleri.contains(url)) {
          fotoGaleri.add(url);
        }
      }
    }

    final urlGambar = fotoGaleri.isNotEmpty ? fotoGaleri.first : '';

    return Wisata(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      nama: json['name']?.toString() ?? 'Tanpa nama',
      lokasi: json['location']?.toString() ?? 'Lokasi tidak tersedia',
      rating: '—',
      kategori: daftarKategori.isNotEmpty
          ? daftarKategori.first.nama
          : 'Lainnya',

      gambar: urlGambar,
      fotoGaleri: fotoGaleri,
      latitude: '',
      longitude: '',
      deskripsi:
          json['description']?.toString() ?? 'Belum ada deskripsi destinasi.',
      slug: json['slug']?.toString() ?? '',
      pulau: island is Map ? island['name']?.toString() ?? '' : '',
      provinsi: province is Map ? province['name']?.toString() ?? '' : '',
      daftarKategori: daftarKategori,
    );
  }

  bool get gambarDariInternet {
    final uri = Uri.tryParse(_gambar);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String get gambarFallbackLokal {
    final kataKunci = [
      nama,
      lokasi,
      pulau,
      provinsi,
      ...daftarKategori.map((item) => item.nama),
    ].join(' ').toLowerCase();
    if (kataKunci.contains('raja ampat')) {
      return 'assets/images/rajaampat.jpg';
    }
    if (kataKunci.contains('labuan bajo') || kataKunci.contains('kupang')) {
      return 'assets/images/labuanbajo.jpg';
    }
    if (kataKunci.contains('rinjani')) {
      return 'assets/images/gunungrinjani.jpg';
    }
    if (kataKunci.contains('bromo') ||
        kataKunci.contains('kintamani') ||
        kataKunci.contains('mountain') ||
        kataKunci.contains('gunung') ||
        kataKunci.contains('volcano')) {
      return 'assets/images/gunungbromo.jpg';
    }
    if (kataKunci.contains('beach') ||
        kataKunci.contains('pantai') ||
        kataKunci.contains('sanur') ||
        kataKunci.contains('seminyak') ||
        kataKunci.contains('bali')) {
      return 'assets/images/pantaikuta.jpg';
    }
    return '';
  }

  String get nama => _nama;
  String get lokasi => _lokasi;
  String get rating => _rating;
  String get kategori => _kategori;
  String get gambar => _gambar;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get deskripsi => _deskripsi;

  set nama(String nilai) => _nama = nilai;
  set lokasi(String nilai) => _lokasi = nilai;
  set rating(String nilai) => _rating = nilai;
  set kategori(String nilai) => _kategori = nilai;
  set gambar(String nilai) => _gambar = nilai;
  set latitude(String nilai) => _latitude = nilai;
  set longitude(String nilai) => _longitude = nilai;
  set deskripsi(String nilai) => _deskripsi = nilai;
}
