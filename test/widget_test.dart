import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/main.dart';
import 'package:login_app/models/wisata.dart';

void main() {
  test('Wisata membaca detail dan foto dari payload API', () {
    final wisata = Wisata.fromJson({
      'name': 'Pulau Contoh',
      'location': 'Nusa Tenggara Timur',
      'description': 'Pulau dengan pantai dan laut yang jernih.',
      'image_url': 'https://example.com/pantai.jpg',
      'photos': [
        {'image_url': 'https://example.com/laut.jpg'},
        {'url': 'https://example.com/pasir.jpg'},
      ],
    });

    expect(wisata.nama, 'Pulau Contoh');
    expect(wisata.deskripsi, 'Pulau dengan pantai dan laut yang jernih.');
    expect(wisata.gambar, 'https://example.com/pantai.jpg');
    expect(wisata.fotoGaleri, [
      'https://example.com/pantai.jpg',
      'https://example.com/laut.jpg',
      'https://example.com/pasir.jpg',
    ]);
  });

  testWidgets('NusaTrip berhasil dijalankan', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

    expect(find.byType(MyApp), findsOneWidget);
  });
}
