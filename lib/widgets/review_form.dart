import 'package:flutter/material.dart';

class ReviewForm extends StatefulWidget {
  final Function(double rating, String komentar) onSubmit;

  const ReviewForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  double rating = 0;
  final TextEditingController komentarController = TextEditingController();

  @override
  void dispose() {
    komentarController.dispose();
    super.dispose();
  }

  void kirimReview() {
    if (rating == 0 || komentarController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi rating dan komentar terlebih dahulu.'),
        ),
      );
      return;
    }

    widget.onSubmit(
      rating,
      komentarController.text.trim(),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tulis Review',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Rating kamu',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final nomorBintang = index + 1;

              return IconButton(
                onPressed: () {
                  setState(() {
                    rating = nomorBintang.toDouble();
                  });
                },
                icon: Icon(
                  nomorBintang <= rating
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 34,
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: komentarController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tulis pengalamanmu...',
              filled: true,
              fillColor: const Color(0xFFF5F9FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: kirimReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Kirim Review',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}