import 'package:dio/dio.dart';

class CommonsImageService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://commons.wikimedia.org/w/api.php',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // Cache agar nama destinasi yang sama tidak dicari berulang kali.
  static final Map<String, Future<String?>> _cache = {};

  static Future<String?> cariGambar(String namaWisata) {
    final kataKunci = namaWisata.trim();

    if (kataKunci.isEmpty) {
      return Future.value(null);
    }

    final key = kataKunci.toLowerCase();

    return _cache.putIfAbsent(
      key,
      () => _cariGambarDariCommons(kataKunci),
    );
  }

  static Future<String?> _cariGambarDariCommons(
    String namaWisata,
  ) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          'action': 'query',
          'generator': 'search',
          'gsrsearch': '$namaWisata Indonesia filetype:bitmap',
          'gsrnamespace': 6,
          'gsrlimit': 5,
          'prop': 'imageinfo',
          'iiprop': 'url|mime',
          'iiurlwidth': 900,
          'format': 'json',
          'origin': '*',
        },
      );

      final data = response.data;
      if (data is! Map) return null;

      final query = data['query'];
      if (query is! Map) return null;

      final pages = query['pages'];
      if (pages is! Map) return null;

      for (final page in pages.values) {
        if (page is! Map) continue;

        final title = page['title']?.toString().toLowerCase() ?? '';

        // Hindari file selain format gambar yang umum.
        final formatValid = title.endsWith('.jpg') ||
            title.endsWith('.jpeg') ||
            title.endsWith('.png') ||
            title.endsWith('.webp');

        if (!formatValid) continue;

        final imageInfo = page['imageinfo'];
        if (imageInfo is! List || imageInfo.isEmpty) continue;

        final info = imageInfo.first;
        if (info is! Map) continue;

        final mime = info['mime']?.toString() ?? '';

        if (!mime.startsWith('image/')) continue;

        final thumbnail = info['thumburl']?.toString();

        if (thumbnail != null && thumbnail.isNotEmpty) {
          return thumbnail;
        }

        final original = info['url']?.toString();

        if (original != null && original.isNotEmpty) {
          return original;
        }
      }

      return null;
    } catch (e) {
      print('Gagal mencari gambar Commons: $e');
      return null;
    }
  }
}
