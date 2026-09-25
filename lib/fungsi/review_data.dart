import '../models/review.dart';

final List<Review> reviewData = [];

List<Review> reviewUntukWisata(int idWisata) {
  return reviewData
      .where((review) => review.idWisata == idWisata)
      .toList();
}

void tambahReview({
  required int idUser,
  required int idWisata,
  required double rating,
  required String komentar,
}) {
  reviewData.add(
    Review(
      id: reviewData.length + 1,
      idUser: idUser,
      idWisata: idWisata,
      rating: rating,
      komentar: komentar,
    ),
  );
}