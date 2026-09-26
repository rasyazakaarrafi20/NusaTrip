import 'package:flutter/material.dart';

class TripPlanning extends StatelessWidget {
  final VoidCallback onMaps;
  final VoidCallback onTiket;
  final VoidCallback onPenginapan;

  const TripPlanning({
    super.key,
    required this.onMaps,
    required this.onTiket,
    required this.onPenginapan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rencanakan Perjalanan',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Siapkan kebutuhan perjalananmu dari satu tempat.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: _TripButton(
                icon: Icons.location_on_outlined,
                label: 'Lihat Lokasi',
                onTap: onMaps,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _TripButton(
                icon: Icons.flight_takeoff,
                label: 'Cari Tiket',
                onTap: onTiket,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: _TripButton(
            icon: Icons.hotel_outlined,
            label: 'Cari Penginapan',
            onTap: onPenginapan,
          ),
        ),
      ],
    );
  }
}

class _TripButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TripButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF2563EB),
        side: const BorderSide(
          color: Color(0xFF2563EB),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}