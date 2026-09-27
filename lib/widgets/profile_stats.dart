import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int jumlahFavorit;
  final int jumlahReview;

  const ProfileStats({
    super.key,
    required this.jumlahFavorit,
    required this.jumlahReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.favorite,
              nilai: jumlahFavorit.toString(),
              label: 'Favorit',
              color: Colors.red,
            ),
          ),

          Container(
            width: 1,
            height: 45,
            color: Colors.grey.shade300,
          ),

          Expanded(
            child: _StatItem(
              icon: Icons.star,
              nilai: jumlahReview.toString(),
              label: 'Review',
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String nilai;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.nilai,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 25,
        ),

        const SizedBox(height: 5),

        Text(
          nilai,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}