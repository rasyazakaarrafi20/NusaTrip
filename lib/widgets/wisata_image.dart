import 'package:flutter/material.dart';

import '../services/commons_image_service.dart';

class WisataImage extends StatefulWidget {
  final String sumber;
  final String? namaWisata;
  final String? fallbackAsset;
  final double? width;
  final double? height;
  final BoxFit fit;

  const WisataImage({
    super.key,
    required this.sumber,
    this.namaWisata,
    this.fallbackAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  State<WisataImage> createState() => _WisataImageState();
}

class _WisataImageState extends State<WisataImage> {
  String? _gambarAlternatif;
  bool _sedangMencari = false;
  bool _sudahMencari = false;

  bool get _isUrl {
    final uri = Uri.tryParse(widget.sumber);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String get _kataKunci {
    if (widget.namaWisata != null && widget.namaWisata!.trim().isNotEmpty) {
      return widget.namaWisata!.trim();
    }

    // Fallback jika namaWisata belum diberikan.
    final uri = Uri.tryParse(widget.sumber);
    final namaFile = uri?.pathSegments.isNotEmpty == true
        ? uri!.pathSegments.last
        : widget.sumber;

    return Uri.decodeComponent(namaFile)
        .replaceAll(RegExp(r'\.(jpg|jpeg|png|webp)$', caseSensitive: false), '')
        .replaceAll(RegExp(r'[-_]'), ' ');
  }

  @override
  void didUpdateWidget(covariant WisataImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sumber != widget.sumber ||
        oldWidget.namaWisata != widget.namaWisata ||
        oldWidget.fallbackAsset != widget.fallbackAsset) {
      _gambarAlternatif = null;
      _sedangMencari = false;
      _sudahMencari = false;
    }
  }

  Future<void> _cariGambarAlternatif() async {
    if (_sudahMencari || _sedangMencari) return;

    _sudahMencari = true;
    _sedangMencari = true;

    final hasil = await CommonsImageService.cariGambar(_kataKunci);

    if (!mounted) return;

    setState(() {
      _gambarAlternatif = hasil;
      _sedangMencari = false;
    });

    if (hasil != null) {
      debugPrint('FOTO ALTERNATIF DITEMUKAN: $_kataKunci');
      debugPrint('URL: $hasil');
    } else {
      debugPrint('FOTO ALTERNATIF TIDAK DITEMUKAN: $_kataKunci');
    }
  }

  Widget _placeholder({bool useFallback = true}) {
    final asset = widget.fallbackAsset;
    if (useFallback && asset != null && asset.isNotEmpty) {
      return Image.asset(
        asset,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) => Container(
          width: widget.width,
          height: widget.height,
          color: const Color(0xFFE2E8F0),
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 35,
          ),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
        size: 35,
      ),
    );
  }

  Widget _gambarInternet(String url) {
    return Image.network(
      url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
      errorBuilder: (context, error, stackTrace) {
        return _placeholder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Jika gambar utama kosong, langsung gunakan pencarian alternatif.
    if (widget.sumber.trim().isEmpty) {
      if (!_sudahMencari && !_sedangMencari) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _cariGambarAlternatif();
        });
      }

      if (_gambarAlternatif != null) {
        return _gambarInternet(_gambarAlternatif!);
      }

      return _placeholder();
    }

    // Jika gambar utama adalah URL internet.
    if (_isUrl) {
      if (_gambarAlternatif != null) {
        return _gambarInternet(_gambarAlternatif!);
      }

      if (_sudahMencari) {
        return _placeholder();
      }

      return Image.network(
        widget.sumber,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _cariGambarAlternatif();
          });

          return _placeholder();
        },
      );
    }

    // Jika sumber berupa asset lokal.
    return Image.asset(
      widget.sumber,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        return _placeholder();
      },
    );
  }
}
