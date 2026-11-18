
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.4),
        ),
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
            color: colors.outlineVariant,
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
    final colors = Theme.of(context).colorScheme;

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
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),

        Text(
          label,
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
