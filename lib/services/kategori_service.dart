
import '../models/kategori.dart';
import 'api_client.dart';

class KategoriService {
  Future<List<Kategori>> ambilKategori() async {
    try {
      final response = await ApiClient.dio.get(
        '/api/category',
      );

      final data = response.data;

      if (data is! List) {
        throw Exception('Format data kategori tidak sesuai.');
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => Kategori.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }
}
