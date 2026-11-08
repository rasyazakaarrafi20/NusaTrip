import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../config/maps_config.dart';

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

  @override
  Widget build(BuildContext context) {
    final apiKey = googleMapsApiKey.trim();
    final url = apiKey.isNotEmpty
        ? Uri.https('www.google.com', '/maps/embed/v1/place', {
            'key': apiKey,
            'q': '$latitude,$longitude',
            'center': '$latitude,$longitude',
            'zoom': '12',
            'maptype': 'roadmap',
            'language': 'id',
            'region': 'ID',
          })
        : Uri.https('www.google.com', '/maps', {
            'q': '$latitude,$longitude',
            'z': '12',
            'output': 'embed',
          });

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: SizedBox(
          height: 280,
          width: double.infinity,
          child: HtmlElementView.fromTagName(
            tagName: 'iframe',
            onElementCreated: (Object element) {
              final iframe = element as web.HTMLIFrameElement;

              iframe.src = url.toString();

              iframe.style.width = '100%';
              iframe.style.height = '100%';
              iframe.style.border = '0';

              iframe.setAttribute('allowfullscreen', 'true');

              iframe.setAttribute('loading', 'lazy');

              iframe.setAttribute(
                'referrerpolicy',
                'strict-origin-when-cross-origin',
              );
            },
          ),
        ),
      ),
    );
  }
}
