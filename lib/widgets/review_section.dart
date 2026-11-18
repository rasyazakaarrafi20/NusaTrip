
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

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        side: BorderSide(
          color: colors.outlineVariant,
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final reviews = reviewUntukWisata(idWisata);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '⭐ Review Pengunjung',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            Text(
              '${reviews.length} review',
              style: TextStyle(
                color: colors.onSurfaceVariant,
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
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colors.outlineVariant,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  size: 40,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  'Belum ada review',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Jadilah yang pertama memberikan review.',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
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
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colors.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: colors.primaryContainer,
                          child: Icon(
                            Icons.person,
                            color: colors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            user?.nama ?? 'Pengguna',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
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
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: colors.onSurfaceVariant,
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
              foregroundColor: colors.primary,
              side: BorderSide(
                color: colors.primary,
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
