import 'package:flutter/material.dart';

import '../fungsi/review_data.dart';
import '../fungsi/user_data.dart';
import 'review_form.dart';

class ReviewSection extends StatelessWidget {
  final int idWisata;
  final VoidCallback onReviewAdded;

  const ReviewSection({
    super.key,
    required this.idWisata,
    required this.onReviewAdded,
  });

  void bukaFormReview(BuildContext context) {
    if (userAktif == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu.'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return ReviewForm(
          onSubmit: (rating, komentar) {
            tambahReview(
              idUser: userAktif!.id,
              idWisata: idWisata,
              rating: rating,
              komentar: komentar,
            );

            onReviewAdded();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviews = reviewUntukWisata(idWisata);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '⭐ Review Pengunjung',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${reviews.length} review',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (reviews.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  size: 40,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  'Belum ada review',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Jadilah yang pertama memberikan review.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Column(
            children: reviews.map((review) {
              final user = cariUser(review.idUser);
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          child: Icon(Icons.person),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            user?.nama ?? 'Pengguna',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: List.generate(
                            review.rating.round(),
                            (index) => const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      review.komentar,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => bukaFormReview(context),
            icon: const Icon(Icons.edit),
            label: const Text('Tulis Review'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
              side: const BorderSide(
                color: Color(0xFF2563EB),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}