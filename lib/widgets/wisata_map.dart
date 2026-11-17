import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WisataMap extends StatelessWidget {
  final String namaWisata;
  final double latitude;
  final double longitude;

  const WisataMap({
    super.key,
    required this.namaWisata,
    required this.latitude,
    required this.longitude,
  });

  Future<void> _bukaPeta(BuildContext context) async {
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '$latitude,$longitude',
    });

    final berhasil = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!berhasil && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka aplikasi peta.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.location_on, size: 38, color: Color(0xFF3A5EE0)),
          const SizedBox(height: 8),
          Text(
            namaWisata,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _bukaPeta(context),
              icon: const Icon(Icons.map_outlined),
              label: const Text('Buka di Google Maps'),
            ),
          ),
        ],
      ),
    );
  }
}
