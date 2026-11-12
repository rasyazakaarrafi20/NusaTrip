import '../models/wisata.dart';
import 'api_client.dart';

class WisataService {
  Future<List<Wisata>> ambilDestinasi() async {
    try {
      final response = await ApiClient.dio.get(
        '/api/destination/with-category',
      );

      final data = response.data;

      if (data is! List) {
        throw Exception('Format data destinasi tidak sesuai.');
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => Wisata.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil destinasi: $e');
    }
  }
}
